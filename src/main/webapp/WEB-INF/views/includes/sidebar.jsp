<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lias.beans.User"%>
<%
    User sbUser = (User) session.getAttribute("currentUser");
    if (sbUser == null) sbUser = (User) session.getAttribute("user");
    String sbRole = sbUser != null ? sbUser.getRole() : "visiteur";
    boolean sbIsDir = "directeur".equalsIgnoreCase(sbRole) || "admin".equalsIgnoreCase(sbRole);
    String activeNav = (String) request.getAttribute("activeNav");
    if (activeNav == null) {
        String servletPath = request.getServletPath();
        if (servletPath != null) {
            if (servletPath.contains("home")) activeNav = "dashboard";
            else if (servletPath.contains("member") || servletPath.contains("profil")) activeNav = "profils";
            else if (servletPath.contains("publication")) activeNav = "publications";
            else if (servletPath.contains("calendrier")) activeNav = "calendrier";
            else if (servletPath.contains("evenement")) activeNav = "evenements";
            else if (servletPath.contains("document")) activeNav = "documents";
            else if (servletPath.contains("communication")) activeNav = "communication";
            else if (servletPath.contains("adhesion")) activeNav = "adhesions";
            else if (servletPath.contains("materiel")) activeNav = "materiel";
            else if (servletPath.contains("rapport")) activeNav = "rapport";
            else if (servletPath.contains("mandat")) activeNav = "mandats";
            else if (servletPath.contains("convention")) activeNav = "conventions";
            else if (servletPath.contains("pv")) activeNav = "pv";
            else if (servletPath.contains("admin")) activeNav = "admin";
            else if (servletPath.contains("notif")) activeNav = "notifications";
            else if (servletPath.contains("recherche")) activeNav = "recherche";
        }
    }
%>
<aside class="app-sidebar">
    <div class="sidebar-scroll">
        <!-- PRINCIPAL -->
        <div class="sidebar-section">
            <div class="sidebar-section-title">Principal</div>
            
            <a href="<%= request.getContextPath() %>/home" class="sidebar-nav-item <%= "dashboard".equals(activeNav) ? "active" : "" %>">
                <span class="nav-glyph">⊟</span>
                <span class="nav-label">Tableau de bord</span>
            </a>
            
            <a href="<%= request.getContextPath() %>/profils" class="sidebar-nav-item <%= "profils".equals(activeNav) ? "active" : "" %>">
                <span class="nav-glyph">⊙</span>
                <span class="nav-label">Profils</span>
            </a>

            <a href="<%= request.getContextPath() %>/mandats" class="sidebar-nav-item <%= "mandats".equals(activeNav) ? "active" : "" %>">
                <span class="nav-glyph">⌗</span>
                <span class="nav-label">Mandats</span>
            </a>

            <a href="<%= request.getContextPath() %>/adhesions" class="sidebar-nav-item <%= "adhesions".equals(activeNav) ? "active" : "" %>">
                <span class="nav-glyph">+</span>
                <span class="nav-label">Demandes d'adhésion</span>
                <% if (!sbIsDir && !"permanent".equalsIgnoreCase(sbRole)) { %>
                    <span class="nav-lock" title="Réservé aux membres permanents et direction">🔒</span>
                <% } %>
            </a>

            <a href="<%= request.getContextPath() %>/rapport" class="sidebar-nav-item <%= "rapport".equals(activeNav) ? "active" : "" %>">
                <span class="nav-glyph">§</span>
                <span class="nav-label">Rapport annuel</span>
            </a>
        </div>

        <!-- MODULES SECONDAIRES -->
        <div class="sidebar-section">
            <div class="sidebar-section-title">Modules secondaires</div>

            <a href="<%= request.getContextPath() %>/evenements" class="sidebar-nav-item <%= "evenements".equals(activeNav) ? "active" : "" %>">
                <span class="nav-glyph">◇</span>
                <span class="nav-label">Évènements</span>
            </a>

            <a href="<%= request.getContextPath() %>/calendrier" class="sidebar-nav-item <%= "calendrier".equals(activeNav) ? "active" : "" %>">
                <span class="nav-glyph">▦</span>
                <span class="nav-label">Calendrier</span>
            </a>

            <a href="<%= request.getContextPath() %>/publications" class="sidebar-nav-item <%= "publications".equals(activeNav) ? "active" : "" %>">
                <span class="nav-glyph">¶</span>
                <span class="nav-label">Publications</span>
            </a>

            <a href="<%= request.getContextPath() %>/documents" class="sidebar-nav-item <%= "documents".equals(activeNav) ? "active" : "" %>">
                <span class="nav-glyph">▤</span>
                <span class="nav-label">Archive documentaire</span>
            </a>

            <a href="<%= request.getContextPath() %>/communication" class="sidebar-nav-item <%= "communication".equals(activeNav) ? "active" : "" %>">
                <span class="nav-glyph">❝</span>
                <span class="nav-label">Communication</span>
            </a>

            <a href="<%= request.getContextPath() %>/materiel" class="sidebar-nav-item <%= "materiel".equals(activeNav) ? "active" : "" %>">
                <span class="nav-glyph">▭</span>
                <span class="nav-label">Matériel</span>
            </a>

            <a href="<%= request.getContextPath() %>/conventions" class="sidebar-nav-item <%= "conventions".equals(activeNav) ? "active" : "" %>">
                <span class="nav-glyph">⌘</span>
                <span class="nav-label">Conventions</span>
            </a>

            <a href="<%= request.getContextPath() %>/pv" class="sidebar-nav-item <%= "pv".equals(activeNav) ? "active" : "" %>">
                <span class="nav-glyph">≡</span>
                <span class="nav-label">Procès-verbaux</span>
            </a>
        </div>

        <!-- OUTILS -->
        <div class="sidebar-section">
            <div class="sidebar-section-title">Outils</div>

            <a href="<%= request.getContextPath() %>/recherche" class="sidebar-nav-item <%= "recherche".equals(activeNav) ? "active" : "" %>">
                <span class="nav-glyph">⌕</span>
                <span class="nav-label">Recherche globale</span>
            </a>

            <a href="<%= request.getContextPath() %>/notifications" class="sidebar-nav-item <%= "notifications".equals(activeNav) ? "active" : "" %>" style="display:flex; align-items:center;">
                <span class="nav-glyph">◉</span>
                <span class="nav-label">Notifications</span>
                <span style="margin-left:auto; background:#B5453E; color:#FFF; font-size:10px; padding:1px 6px; border-radius:10px; font-family:'JetBrains Mono', monospace; font-weight:600;">3</span>
            </a>

            <% if (sbIsDir) { %>
            <a href="<%= request.getContextPath() %>/admin" class="sidebar-nav-item <%= "admin".equals(activeNav) ? "active" : "" %>">
                <span class="nav-glyph">⚙</span>
                <span class="nav-label">Administration</span>
            </a>
            <% } %>
        </div>
    </div>

    <!-- SIDEBAR FOOTER -->
    <div class="sidebar-footer">
        <a href="<%= request.getContextPath() %>/public" class="sidebar-footer-link">↗ Site public</a>
        <a href="<%= request.getContextPath() %>/logout" class="sidebar-footer-link">↗ Déconnexion</a>
        <div class="sidebar-version">v 0.1.0 · projet JEE</div>
    </div>
</aside>
