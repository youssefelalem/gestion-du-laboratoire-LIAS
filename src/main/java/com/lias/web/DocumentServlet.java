package com.lias.web;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.lias.beans.DocumentLabo;
import com.lias.beans.User;
import com.lias.dao.DocumentDaoImpl;
import com.lias.dao.IDocumentDao;

/**
 * Contrôleur de l'Archive Documentaire Institutionnelle (CDC §10).
 * Gère l'arborescence, la recherche, l'upload et le téléchargement des documents.
 */
@WebServlet(name = "DocumentServlet", urlPatterns = {"/documents"})
public class DocumentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IDocumentDao documentDao;

    @Override
    public void init() throws ServletException {
        super.init();
        this.documentDao = new DocumentDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // Vérification de téléchargement
        String downloadIdStr = request.getParameter("download");
        if (downloadIdStr != null && !downloadIdStr.trim().isEmpty()) {
            try {
                int docId = Integer.parseInt(downloadIdStr.trim());
                DocumentLabo doc = documentDao.findById(docId);
                if (doc != null) {
                    streamDocument(doc, response);
                    return;
                }
            } catch (NumberFormatException ignored) {}
        }

        String search = request.getParameter("q");
        List<DocumentLabo> allDocs = documentDao.findAll();

        if (search != null && !search.trim().isEmpty()) {
            List<DocumentLabo> searchResults = documentDao.search(search);
            request.setAttribute("searchResults", searchResults);
            request.setAttribute("searchQuery", search.trim());
        }

        // Navigation dans l'arborescence
        String selDossier = request.getParameter("dossier");
        String selSousDossier = request.getParameter("sousDossier");
        String selEdition = request.getParameter("edition");

        if (selDossier == null || selDossier.trim().isEmpty()) {
            selDossier = "Évènements";
            selSousDossier = "CASA-DATA";
            selEdition = "2025 — 7e édition";
        }

        List<DocumentLabo> currentFolderDocs = documentDao.findByDossier(selDossier, selSousDossier, selEdition);

        request.setAttribute("allDocs", allDocs);
        request.setAttribute("currentDocs", currentFolderDocs);
        request.setAttribute("selDossier", selDossier);
        request.setAttribute("selSousDossier", selSousDossier);
        request.setAttribute("selEdition", selEdition);
        request.setAttribute("activeNav", "documents");

        request.getRequestDispatcher("/WEB-INF/views/documents.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = null;
        if (session != null) {
            user = (User) session.getAttribute("currentUser");
            if (user == null) user = (User) session.getAttribute("user");
        }

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=auth_requise");
            return;
        }

        String dossier = request.getParameter("dossier");
        String sousDossier = request.getParameter("sousDossier");
        String edition = request.getParameter("edition");
        String nomFichier = request.getParameter("nomFichier");
        String type = request.getParameter("type");
        String description = request.getParameter("description");

        if (dossier == null || dossier.trim().isEmpty()) dossier = "Évènements";
        if (sousDossier == null || sousDossier.trim().isEmpty()) sousDossier = "Général";
        if (nomFichier == null || nomFichier.trim().isEmpty()) {
            nomFichier = "Document_LIAS_" + System.currentTimeMillis() + "." + (type != null ? type : "pdf");
        }
        if (type == null || type.trim().isEmpty()) type = "pdf";

        String auteur = (user.getPrenom() != null ? user.getPrenom() + " " : "") + (user.getNom() != null ? user.getNom() : "Chercheur LIAS");
        String dateAujourdhui = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        DocumentLabo newDoc = new DocumentLabo(
                null,
                dossier.trim(),
                sousDossier.trim(),
                edition != null && !edition.trim().isEmpty() ? edition.trim() : null,
                nomFichier.trim(),
                "245 KB",
                dateAujourdhui,
                type.trim().toLowerCase(),
                auteur,
                description != null ? description.trim() : "Document téléversé par " + auteur
        );

        documentDao.save(newDoc);

        response.sendRedirect(request.getContextPath() + "/documents?dossier=" + java.net.URLEncoder.encode(dossier, "UTF-8") +
                "&sousDossier=" + java.net.URLEncoder.encode(sousDossier, "UTF-8") +
                (edition != null ? "&edition=" + java.net.URLEncoder.encode(edition, "UTF-8") : "") +
                "&msg=uploaded");
    }

    private void streamDocument(DocumentLabo doc, HttpServletResponse response) throws IOException {
        String ext = doc.getType() != null ? doc.getType().toLowerCase() : "pdf";
        String mimeType = "application/octet-stream";
        if ("pdf".equals(ext)) mimeType = "application/pdf";
        else if ("docx".equals(ext)) mimeType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
        else if ("xlsx".equals(ext)) mimeType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        else if ("zip".equals(ext)) mimeType = "application/zip";

        response.setContentType(mimeType);
        response.setHeader("Content-Disposition", "attachment; filename=\"" + doc.getNomFichier() + "\"");

        // Contenu institutionnel simulé conforme aux normes universitaires
        StringBuilder content = new StringBuilder();
        content.append("================================================================================\n");
        content.append("ROYAUME DU MAROC - UNIVERSITÉ HASSAN II DE CASABLANCA\n");
        content.append("FACULTÉ DES SCIENCES BEN M'SIK - DÉPARTEMENT D'INFORMATIQUE\n");
        content.append("LABORATOIRE D'INFORMATIQUE ET D'AIDE À LA DÉCISION (LIAS)\n");
        content.append("================================================================================\n\n");
        content.append("DOCUMENT OFFICIEL : ").append(doc.getNomFichier()).append("\n");
        content.append("DOSSIER : ").append(doc.getCheminComplet()).append("\n");
        content.append("DATE DE PUBLICATION : ").append(doc.getDateFichier()).append("\n");
        content.append("AUTEUR / DÉPOSANT : ").append(doc.getAuteur()).append("\n");
        content.append("TAILLE DU FICHIER : ").append(doc.getTaille()).append("\n");
        content.append("DESCRIPTION : ").append(doc.getDescription() != null ? doc.getDescription() : "Document officiel archivé du laboratoire LIAS.").append("\n\n");
        content.append("--------------------------------------------------------------------------------\n");
        content.append("Historisation & Traçabilité : Enregistré avec succès dans le système de gestion LIAS.\n");
        content.append("Conforme aux directives du Conseil de Laboratoire et du Cahier des Charges JEE.\n");
        content.append("================================================================================\n");

        byte[] bytes = content.toString().getBytes(StandardCharsets.UTF_8);
        response.setContentLength(bytes.length);
        try (OutputStream os = response.getOutputStream()) {
            os.write(bytes);
            os.flush();
        }
    }
}
