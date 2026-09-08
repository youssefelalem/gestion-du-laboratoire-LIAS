package com.lias.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.lias.beans.Convention;
import com.lias.beans.DocumentLabo;
import com.lias.beans.Evenement;
import com.lias.beans.Member;
import com.lias.beans.Publication;
import com.lias.dao.ConventionDaoImpl;
import com.lias.dao.DocumentDaoImpl;
import com.lias.dao.EvenementDaoImpl;
import com.lias.dao.IConventionDao;
import com.lias.dao.IDocumentDao;
import com.lias.dao.IEvenementDao;
import com.lias.dao.IMemberDao;
import com.lias.dao.IPublicationDao;
import com.lias.dao.MemberDaoImpl;
import com.lias.dao.PublicationDaoImpl;

/**
 * Contrôleur de Recherche Globale Multi-Critères (CDC §15).
 */
@WebServlet(name = "RechercheServlet", urlPatterns = {"/recherche"})
public class RechercheServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IMemberDao memberDao;
    private IPublicationDao publicationDao;
    private IEvenementDao evenementDao;
    private IDocumentDao documentDao;
    private IConventionDao conventionDao;

    @Override
    public void init() throws ServletException {
        super.init();
        this.memberDao = new MemberDaoImpl();
        this.publicationDao = new PublicationDaoImpl();
        this.evenementDao = new EvenementDaoImpl();
        this.documentDao = new DocumentDaoImpl();
        this.conventionDao = new ConventionDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String q = request.getParameter("q");
        String category = request.getParameter("cat");
        if (category == null || category.trim().isEmpty()) {
            category = "tout";
        }

        List<Member> resMembers = new ArrayList<>();
        List<Publication> resPubs = new ArrayList<>();
        List<Evenement> resEvents = new ArrayList<>();
        List<DocumentLabo> resDocs = new ArrayList<>();
        List<Convention> resConventions = new ArrayList<>();

        if (q != null && !q.trim().isEmpty()) {
            String lower = q.trim().toLowerCase();

            // Recherche membres
            for (Member m : memberDao.findAll()) {
                String full = (m.getNom() + " " + m.getPrenom() + " " + m.getEmail() + " " + m.getEquipe() + " " + (m.getGrade() != null ? m.getGrade() : "")).toLowerCase();
                if (full.contains(lower)) resMembers.add(m);
            }

            // Recherche publications
            for (Publication p : publicationDao.findAll()) {
                String full = (p.getTitre() + " " + p.getAuteurs() + " " + p.getRevue() + " " + p.getEquipe()).toLowerCase();
                if (full.contains(lower)) resPubs.add(p);
            }

            // Recherche événements
            for (Evenement e : evenementDao.findAll()) {
                String full = (e.getTitre() + " " + e.getLieu() + " " + e.getOrganisateur() + " " + e.getDescription()).toLowerCase();
                if (full.contains(lower)) resEvents.add(e);
            }

            // Recherche documents
            resDocs = documentDao.search(lower);

            // Recherche conventions
            for (Convention c : conventionDao.findAll()) {
                String full = (c.getOrganismePartenaire() + " " + c.getObjet() + " " + c.getTypePartenaire()).toLowerCase();
                if (full.contains(lower)) resConventions.add(c);
            }
        }

        int totalCount = resMembers.size() + resPubs.size() + resEvents.size() + resDocs.size() + resConventions.size();

        request.setAttribute("query", q != null ? q.trim() : "");
        request.setAttribute("category", category);
        request.setAttribute("resMembers", resMembers);
        request.setAttribute("resPubs", resPubs);
        request.setAttribute("resEvents", resEvents);
        request.setAttribute("resDocs", resDocs);
        request.setAttribute("resConventions", resConventions);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("activeNav", "recherche");

        request.getRequestDispatcher("/WEB-INF/views/recherche.jsp").forward(request, response);
    }
}
