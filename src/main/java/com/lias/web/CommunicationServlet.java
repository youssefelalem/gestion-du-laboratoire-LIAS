package com.lias.web;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.lias.beans.MessageCommunication;
import com.lias.beans.User;
import com.lias.dao.CommunicationDaoImpl;
import com.lias.dao.ICommunicationDao;

/**
 * Contrôleur de la Communication Interne & Canaux d'Équipes (CDC §13).
 */
@WebServlet(name = "CommunicationServlet", urlPatterns = {"/communication"})
public class CommunicationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ICommunicationDao communicationDao;

    @Override
    public void init() throws ServletException {
        super.init();
        this.communicationDao = new CommunicationDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String canal = request.getParameter("canal");
        if (canal == null || canal.trim().isEmpty()) {
            canal = "general";
        }

        List<MessageCommunication> messages = communicationDao.findByCanal(canal);
        request.setAttribute("messages", messages);
        request.setAttribute("activeCanal", canal);
        request.setAttribute("activeNav", "communication");

        request.getRequestDispatcher("/WEB-INF/views/communication.jsp").forward(request, response);
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

        String canalId = request.getParameter("canalId");
        if (canalId == null || canalId.trim().isEmpty()) {
            canalId = "general";
        }
        String contenu = request.getParameter("message");
        if (contenu != null && !contenu.trim().isEmpty()) {
            String roleLibelle = user.getRole() != null ? user.getRole().toUpperCase() : "MEMBRE";
            String auteurNom = (user.getPrenom() != null ? user.getPrenom() + " " : "") + (user.getNom() != null ? user.getNom() : "Chercheur");
            String canalNom = "Canal " + canalId;
            if ("general".equalsIgnoreCase(canalId)) canalNom = "Général & Direction";
            else if ("team_ia".equalsIgnoreCase(canalId)) canalNom = "Équipe Intelligence Artificielle (IA)";
            else if ("team_bigdata".equalsIgnoreCase(canalId)) canalNom = "Équipe Big Data & Cloud";
            else if ("team_securite".equalsIgnoreCase(canalId)) canalNom = "Équipe Cybersécurité & Zero-Trust";
            else if ("team_nlp".equalsIgnoreCase(canalId)) canalNom = "Équipe NLP & Dialectologie";
            else if ("events".equalsIgnoreCase(canalId)) canalNom = "Manifestations & Événements";

            String dateEnvoi = "Aujourd'hui à " + DateTimeFormatter.ofPattern("HH:mm").format(LocalDateTime.now());

            MessageCommunication msg = new MessageCommunication(
                null, canalId, canalNom, auteurNom, user.getEmail(), roleLibelle, contenu.trim(), dateEnvoi
            );
            communicationDao.save(msg);
        }

        response.sendRedirect(request.getContextPath() + "/communication?canal=" + canalId + "&msg=envoye");
    }
}
