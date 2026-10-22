package com.lias.web;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.lias.beans.Evenement;
import com.lias.beans.NotificationLabo;
import com.lias.dao.EvenementDaoImpl;
import com.lias.dao.IEvenementDao;
import com.lias.dao.INotificationDao;
import com.lias.dao.NotificationDaoImpl;

/**
 * Contrôleur JEE pour la gestion des évènements scientifiques (CDC §9).
 */
@WebServlet(name = "EvenementServlet", urlPatterns = {"/evenements"})
public class EvenementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IEvenementDao evtDao;
    private INotificationDao notificationDao;

    @Override
    public void init() throws ServletException {
        super.init();
        this.evtDao = new EvenementDaoImpl();
        this.notificationDao = new NotificationDaoImpl();
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
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        com.lias.beans.User user = null;
        if (session != null) {
            user = (com.lias.beans.User) session.getAttribute("currentUser");
            if (user == null) user = (com.lias.beans.User) session.getAttribute("user");
        }
        String role = (user != null && user.getRole() != null) ? user.getRole().toLowerCase() : "";
        // CDC §2.2 / §5.2 : l'organisation des événements relève des permanents et de la direction.
        if (!"directeur".equals(role) && !"permanent".equals(role) && !"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/evenements?error=unauthorized");
            return;
        }
        String titre = request.getParameter("titre");
        String type = request.getParameter("type");
        String date = request.getParameter("date");
        String lieu = request.getParameter("lieu");
        String description = request.getParameter("description");
        String organisateur = request.getParameter("organisateur");

        Evenement evt = new Evenement(null, titre, type, date, lieu, description, organisateur, "À venir");
        evtDao.save(evt);

        // Notification automatique des événements (CDC §19)
        NotificationLabo notif = new NotificationLabo(
            null, "event", "À l'instant", false,
            (organisateur != null && !organisateur.trim().isEmpty()) ? organisateur.trim() : "Direction LIAS",
            "a planifié un nouvel événement scientifique : « " + titre + " » (" + type + ") le " + date + " à " + lieu + ".",
            "Voir l'agenda →", "/evenements"
        );
        notificationDao.save(notif);

        response.sendRedirect(request.getContextPath() + "/evenements?msg=cree");
    }
}
