package com.lias.web;

import java.io.IOException;
import com.lias.dao.IPublicationDao;
import com.lias.dao.PublicationDaoImpl;
import com.lias.dao.IEvenementDao;
import com.lias.dao.EvenementDaoImpl;
import com.lias.dao.IMemberDao;
import com.lias.dao.MemberDaoImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet public d'accueil du Laboratoire LIAS.
 * Accessible à tous les visiteurs sans authentification.
 * Fournit les données réelles (publications récentes, événements, statistiques).
 */
@WebServlet(name = "PublicServlet", urlPatterns = {"/public", "/accueil"})
public class PublicServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private IPublicationDao pubDao;
    private IEvenementDao evtDao;
    private IMemberDao memberDao;

    @Override
    public void init() throws ServletException {
        pubDao = new PublicationDaoImpl();
        evtDao = new EvenementDaoImpl();
        memberDao = new MemberDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            request.setAttribute("recentPublications", pubDao.findAll());
            request.setAttribute("upcomingEvents", evtDao.findAll());
            request.setAttribute("totalMembres", memberDao.findAll().size());
            request.setAttribute("totalPublications", pubDao.findAll().size());
        } catch (Exception e) {
            // Tolérance aux pannes en cas de souci BD
        }
        request.getRequestDispatcher("/WEB-INF/views/public.jsp").forward(request, response);
    }
}
