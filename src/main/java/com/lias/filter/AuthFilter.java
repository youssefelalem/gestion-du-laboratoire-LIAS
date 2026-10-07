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
@WebFilter(filterName = "AuthFilter", urlPatterns = {
    "/home", "/home/*",
    "/admin", "/admin/*",
    "/publications", "/publications/*",
    "/evenements", "/evenements/*",
    "/calendrier", "/calendrier/*",
    "/membres", "/membres/*",
    "/profils", "/profils/*",
    "/materiel", "/materiel/*",
    "/conventions", "/conventions/*",
    "/mandats", "/mandats/*",
    "/pv", "/pv/*",
    "/documents", "/documents/*",
    "/communication", "/communication/*",
    "/rapport", "/rapport/*",
    "/notifications", "/notifications/*",
    "/recherche", "/recherche/*"
})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialisation du filtre
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) 
            throws IOException, ServletException {
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(false);
        if (session != null) {
            com.lias.beans.User u = (com.lias.beans.User) session.getAttribute("currentUser");
            if (u != null && ((u.getPrenom() != null && u.getPrenom().contains("?")) || (u.getNom() != null && u.getNom().contains("?")))) {
                com.lias.dao.IUserDao userDao = new com.lias.dao.UserDaoImpl();
                com.lias.beans.User freshUser = userDao.findById(u.getId());
                if (freshUser != null) {
                    session.setAttribute("currentUser", freshUser);
                    session.setAttribute("user", freshUser);
                }
            }
        }

        boolean isLoggedIn = (session != null && (session.getAttribute("currentUser") != null || session.getAttribute("user") != null));

        String servletPath = request.getServletPath();
        if (servletPath == null || servletPath.isEmpty()) servletPath = request.getRequestURI();
        String method = request.getMethod();

        // 1. Consultation publique libre pour les visiteurs (CDC §2.1)
        // Les visiteurs sans compte ont accès libre en consultation (GET) aux pages publiques
        boolean isPublicConsultation = "GET".equalsIgnoreCase(method) && (
            servletPath.startsWith("/publications") ||
            servletPath.startsWith("/evenements") ||
            servletPath.startsWith("/calendrier") ||
            servletPath.startsWith("/membres") ||
            servletPath.startsWith("/profils") ||
            servletPath.startsWith("/recherche")
        );

        if (!isLoggedIn && isPublicConsultation) {
            chain.doFilter(req, res);
            return;
        }

        // 2. Interception du mode maintenance (CDC §5.1 : Administrateur Système)
        Boolean isMaintenance = (Boolean) request.getServletContext().getAttribute("MAINTENANCE_MODE");
        if (Boolean.TRUE.equals(isMaintenance)) {
            boolean isAdmin = false;
            if (session != null) {
                com.lias.beans.User u = (com.lias.beans.User) session.getAttribute("currentUser");
                if (u == null) u = (com.lias.beans.User) session.getAttribute("user");
                if (u != null && "admin".equalsIgnoreCase(u.getRole())) {
                    isAdmin = true;
                }
            }
            String uri = request.getRequestURI();
            if (!isAdmin && !uri.endsWith("/admin") && !uri.endsWith("/login") && !uri.contains("/css/")) {
                response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().write("<!DOCTYPE html><html lang='fr'><head><meta charset='UTF-8'><title>Maintenance — LIAS</title>"
                    + "<style>body{font-family:system-ui,sans-serif;background:#F8FAFC;color:#1E293B;display:flex;align-items:center;justify-content:center;height:100vh;margin:0;}"
                    + ".box{background:#FFF;padding:40px;border-radius:8px;border:1px solid #E2E8F0;text-align:center;max-width:500px;box-shadow:0 4px 6px -1px rgba(0,0,0,0.1);}"
                    + "h1{color:#152B44;font-size:22px;margin-bottom:12px;}p{font-size:14px;color:#64748B;line-height:1.6;}"
                    + "a{display:inline-block;margin-top:16px;color:#152B44;font-weight:700;text-decoration:none;}</style></head><body>"
                    + "<div class='box'><div style='font-size:48px;margin-bottom:12px;'>🚧</div>"
                    + "<h1>Plateforme en Maintenance Technique</h1>"
                    + "<p>Le système du laboratoire LIAS effectue une opération de maintenance planifiée (CDC §5.1). L'accès public est temporairement suspendu pour garantir l'intégrité des données.</p>"
                    + "<a href='" + request.getContextPath() + "/login'>Connexion Administrateur →</a></div></body></html>");
                return;
            }
        }

        if (isLoggedIn) {
            com.lias.beans.User u = (com.lias.beans.User) session.getAttribute("currentUser");
            if (u == null) u = (com.lias.beans.User) session.getAttribute("user");
            String userRole = (u != null && u.getRole() != null) ? u.getRole().toLowerCase() : "";

            // 3. Règle stricte CDC §2.2 C : Doctorants
            // "Compte personnel. Accès limité : Ajouter publications, Consulter publications. ❌ Aucun accès aux modules internes"
            if ("doctorant".equals(userRole)) {
                boolean isForbiddenInternalModule = servletPath.startsWith("/materiel")
                        || servletPath.startsWith("/conventions")
                        || servletPath.startsWith("/pv")
                        || servletPath.startsWith("/mandats")
                        || servletPath.startsWith("/admin")
                        || servletPath.startsWith("/adhesions")
                        || servletPath.startsWith("/rapport");

                if (isForbiddenInternalModule) {
                    response.sendRedirect(request.getContextPath() + "/home?error=acces_interdit_doctorant");
                    return;
                }
            }

            // Utilisateur connecté et autorisé -> autoriser l'accès
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
