package com.lias.web;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.lias.beans.DemandeAdhesion;
import com.lias.dao.DemandeDaoImpl;
import com.lias.dao.IDemandeDao;

/**
 * Contrôleur JEE pour les demandes d'adhésion au laboratoire (CDC §6).
 */
@WebServlet(name = "AdhesionServlet", urlPatterns = {"/adhesions"})
public class AdhesionServlet extends HttpServlet {
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
        List<DemandeAdhesion> adhesions = demandeDao.findAllAdhesions();
        request.setAttribute("adhesions", adhesions);
        request.getRequestDispatcher("/WEB-INF/views/adhesions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("decision".equals(action)) {
            // Décision prise par le directeur en mandat actif
            Long id = Long.parseLong(request.getParameter("id"));
            String decision = request.getParameter("decision"); // ACCEPTEE ou REFUSEE
            demandeDao.updateDecisionAdhesion(id, decision);
            response.sendRedirect(request.getContextPath() + "/adhesions?msg=decision_enregistree");
        } else {
            // Nouvelle soumission de candidature (par un visiteur ou candidat externe)
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String statutVise = request.getParameter("statutVise");
            String etablissement = request.getParameter("etablissement");
            String motivation = request.getParameter("motivation");
            String date = LocalDate.now().toString();

            DemandeAdhesion d = new DemandeAdhesion(null, nom, prenom, email, statutVise, etablissement, motivation, date, "EN_ATTENTE");
            demandeDao.saveAdhesion(d);
            response.sendRedirect(request.getContextPath() + "/adhesions?msg=soumission_reussie");
        }
    }
}
