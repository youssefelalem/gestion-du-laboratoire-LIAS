package com.lias.web;

import java.io.IOException;
import com.lias.dao.IMemberDao;
import com.lias.dao.MemberDaoImpl;
import com.lias.dao.IPublicationDao;
import com.lias.dao.PublicationDaoImpl;
import com.lias.dao.IEvenementDao;
import com.lias.dao.EvenementDaoImpl;
import com.lias.dao.IDemandeDao;
import com.lias.dao.DemandeDaoImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Contrôleur du tableau de bord institutionnel (/home).
 * Fournit les KPI, mandats, événements à venir et alertes de gouvernance.
 */
@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private IMemberDao memberDao;
    private IPublicationDao pubDao;
    private IEvenementDao evtDao;
    private IDemandeDao demandeDao;

    @Override
    public void init() throws ServletException {
        memberDao = new MemberDaoImpl();
        pubDao = new PublicationDaoImpl();
        evtDao = new EvenementDaoImpl();
        demandeDao = new DemandeDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            request.setAttribute("totalMembres", memberDao.findAll().size());
            request.setAttribute("totalPublications", pubDao.findAll().size());
            request.setAttribute("totalEvenements", evtDao.findAll().size());
            request.setAttribute("totalDemandes", demandeDao.findAllAdhesions().size());
            request.setAttribute("upcomingEvents", evtDao.findAll());
            request.setAttribute("pendingDemandes", demandeDao.findAllAdhesions());
        } catch (Exception e) {
            // Tolérance aux pannes
        }
        request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
    }
}
