package com.lias.filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Filtre de sécurité JEE (AuthFilter).
 * Vérifie qu'une session HTTP active existe avant d'accéder aux pages privées.
 * Si non connecté, redirige automatiquement vers la page de login.
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = {"/home", "/home/*", "/admin", "/admin/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialisation du filtre
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) 
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("currentUser") != null);

        if (isLoggedIn) {
            // Utilisateur connecté -> autoriser l'accès
            chain.doFilter(req, res);
        } else {
            // Utilisateur non connecté -> redirection vers la page de connexion
            response.sendRedirect(request.getContextPath() + "/login?error=auth_requise");
        }
    }

    @Override
    public void destroy() {
        // Nettoyage des ressources du filtre
    }
}
