package com.lias.web;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.lias.beans.User;
import com.lias.metier.IMetier;
import com.lias.metier.MetierImpl;

/**
 * Contrôleur JEE d'authentification (Login).
 * Gère l'affichage du formulaire et le traitement de la connexion.
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IMetier metier;

    @Override
    public void init() throws ServletException {
        super.init();
        this.metier = new MetierImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Si l'utilisateur est déjà connecté, on le redirige directement vers /home
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Affichage de la page de connexion
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = metier.authentifier(email, password);

        if (user != null) {
            if (!user.isActif()) {
                if ("retraite".equalsIgnoreCase(user.getRole())) {
                    request.setAttribute("errorMessage", "Compte gelé pour départ en retraite (CDC §2.D & §8.1) : L'accès actif à l'espace membre est suspendu. L'historique, les publications et le parcours scientifique restent consultables en lecture seule dans l'annuaire.");
                } else if ("ancien".equalsIgnoreCase(user.getRole())) {
                    request.setAttribute("errorMessage", "Compte désactivé pour ancien membre (CDC §2.E & §8.2) : L'accès actif est désactivé mais les travaux scientifiques et l'historique restent archivés.");
                } else {
                    request.setAttribute("errorMessage", "Ce compte utilisateur est actuellement inactif. Veuillez contacter la direction du laboratoire.");
                }
                request.setAttribute("emailEntered", email);
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

            // Création / Récupération de la session HTTP
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", user);
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());

            // Redirection vers l'espace membre
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            // Échec d'authentification
            request.setAttribute("errorMessage", "Identifiants invalides. Veuillez vérifier votre email et mot de passe.");
            request.setAttribute("emailEntered", email);
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}
