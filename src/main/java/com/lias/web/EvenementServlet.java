package com.lias.web;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.lias.beans.Evenement;
import com.lias.dao.EvenementDaoImpl;
import com.lias.dao.IEvenementDao;

/**
 * Contrôleur JEE pour la gestion des évènements scientifiques (CDC §9).
 */
@WebServlet(name = "EvenementServlet", urlPatterns = {"/evenements", "/calendrier"})
public class EvenementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IEvenementDao evtDao;

    @Override
    public void init() throws ServletException {
        super.init();
        this.evtDao = new EvenementDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Evenement> liste = evtDao.findAll();
        request.setAttribute("evenements", liste);
        request.getRequestDispatcher("/WEB-INF/views/evenements.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String titre = request.getParameter("titre");
        String type = request.getParameter("type");
        String date = request.getParameter("date");
        String lieu = request.getParameter("lieu");
        String description = request.getParameter("description");
        String organisateur = request.getParameter("organisateur");

        Evenement evt = new Evenement(null, titre, type, date, lieu, description, organisateur, "À venir");
        evtDao.save(evt);

        response.sendRedirect(request.getContextPath() + "/evenements?msg=cree");
    }
}
