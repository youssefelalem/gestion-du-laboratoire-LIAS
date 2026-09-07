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
        String action = request.getParameter("action");

        if ("attribuer".equals(action)) {
            Long id = Long.parseLong(request.getParameter("id"));
            String statut = request.getParameter("statut"); // ACCORDE, LIVRE, REFUSE
            String dateAttribution = LocalDate.now().toString();
            demandeDao.updateStatutMateriel(id, statut, dateAttribution);
            response.sendRedirect(request.getContextPath() + "/materiel?msg=statut_mis_a_jour");
        } else {
            // Nouvelle demande de matériel formulée par un membre
            String designation = request.getParameter("designation");
            String categorie = request.getParameter("categorie");
            String demandeur = request.getParameter("demandeur");
            String dateDemande = LocalDate.now().toString();
            String commentaire = request.getParameter("commentaire");

            Materiel mat = new Materiel(null, designation, categorie, demandeur, dateDemande, "EN_ATTENTE", null, commentaire);
            demandeDao.saveMateriel(mat);
            response.sendRedirect(request.getContextPath() + "/materiel?msg=demande_enregistree");
        }
    }
}
