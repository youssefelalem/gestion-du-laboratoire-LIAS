package com.lias.web;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.lias.beans.Materiel;
import com.lias.dao.DemandeDaoImpl;
import com.lias.dao.IDemandeDao;

/**
 * Contrôleur JEE pour la gestion et distribution équitable du matériel (CDC §14 & §15).
 */
@WebServlet(name = "MaterielServlet", urlPatterns = {"/materiel"})
public class MaterielServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IDemandeDao demandeDao;

    @Override
    public void init() throws ServletException {
        super.init();
        this.demandeDao = new DemandeDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Materiel> materiels = demandeDao.findAllMateriels();
        request.setAttribute("materiels", materiels);
        request.getRequestDispatcher("/WEB-INF/views/materiel.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        jakarta.servlet.http.HttpSession session = request.getSession(false);
        com.lias.beans.User user = null;
        if (session != null) {
            user = (com.lias.beans.User) session.getAttribute("currentUser");
            if (user == null) user = (com.lias.beans.User) session.getAttribute("user");
        }

        String action = request.getParameter("action");

        if ("attribuer".equals(action)) {
            if (user == null || (!"directeur".equalsIgnoreCase(user.getRole()) && !"admin".equalsIgnoreCase(user.getRole()))) {
                response.sendRedirect(request.getContextPath() + "/login?error=auth_requise");
                return;
            }

            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                idStr = request.getParameter("materielId");
            }
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    Long id = Long.parseLong(idStr.trim());
                    String statut = request.getParameter("statut"); // ACCORDE, LIVRE, REFUSE, ATTRIBUE
                    if (statut == null || statut.trim().isEmpty()) {
                        statut = "ATTRIBUE";
                    }
                    String dateAttribution = LocalDate.now().toString();
                    demandeDao.updateStatutMateriel(id, statut, dateAttribution);
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect(request.getContextPath() + "/materiel?msg=statut_mis_a_jour");
        } else {
            // Nouvelle demande de matériel formulée par un membre
            String designation = request.getParameter("designation");
            String categorie = request.getParameter("categorie");
            String demandeur = request.getParameter("demandeur");
            if (demandeur == null || demandeur.trim().isEmpty()) {
                if (user != null) {
                    demandeur = (user.getPrenom() != null ? user.getPrenom() + " " : "") + (user.getNom() != null ? user.getNom() : user.getEmail());
                } else {
                    demandeur = "Chercheur LIAS";
                }
            }
            String dateDemande = LocalDate.now().toString();
            String commentaire = request.getParameter("commentaire");
            if (commentaire == null || commentaire.trim().isEmpty()) {
                commentaire = request.getParameter("description");
            }

            Materiel mat = new Materiel(null, designation, categorie, demandeur, dateDemande, "EN_ATTENTE", null, commentaire);
            demandeDao.saveMateriel(mat);
            response.sendRedirect(request.getContextPath() + "/materiel?msg=demande_enregistree");
        }
    }
}
