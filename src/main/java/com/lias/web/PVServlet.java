package com.lias.web;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

import com.lias.beans.ReunionPV;
import com.lias.beans.User;
import com.lias.dao.IPVDao;
import com.lias.dao.PVDaoImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class PVServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IPVDao pvDao;

    @Override
    public void init() throws ServletException {
        this.pvDao = new PVDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<ReunionPV> pvs = pvDao.findAll();
        request.setAttribute("pvs", pvs);
        request.setAttribute("activeMenu", "pv");

        request.getRequestDispatcher("/WEB-INF/views/pv.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = null;
        if (session != null) {
            user = (User) session.getAttribute("currentUser");
            if (user == null) user = (User) session.getAttribute("user");
        }

        if (user == null || (!"directeur".equalsIgnoreCase(user.getRole()) && !"permanent".equalsIgnoreCase(user.getRole()) && !"admin".equalsIgnoreCase(user.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/pv?error=unauthorized");
            return;
        }

        String titre = request.getParameter("titre");
        String dateReunionStr = request.getParameter("dateReunion");
        String ordreDuJour = request.getParameter("ordreDuJour");
        String cheminFichierPV = request.getParameter("cheminFichierPV");
        String directeurSignataire = request.getParameter("directeurSignataire");

        if (titre != null && !titre.trim().isEmpty() && dateReunionStr != null && !dateReunionStr.trim().isEmpty()) {
            try {
                ReunionPV pv = new ReunionPV();
                pv.setTitre(titre.trim());
                pv.setDateReunion(LocalDate.parse(dateReunionStr.trim()));
                pv.setOrdreDuJour(ordreDuJour != null ? ordreDuJour.trim() : "");
                pv.setCheminFichierPV(cheminFichierPV != null && !cheminFichierPV.trim().isEmpty() ? cheminFichierPV.trim() : "archives/pv_document.pdf");
                pv.setDirecteurSignataire(directeurSignataire != null && !directeurSignataire.trim().isEmpty() ? directeurSignataire.trim() : "Prof. Youssef El Alem");

                pvDao.save(pv);
            } catch (Exception e) {
                // Ignore parse errors safely
            }
        }

        response.sendRedirect(request.getContextPath() + "/pv?success=created");
    }
}
