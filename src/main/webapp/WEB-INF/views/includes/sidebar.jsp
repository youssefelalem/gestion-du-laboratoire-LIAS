<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lias.beans.User"%>
<%
    User sbUser = (User) session.getAttribute("currentUser");
    String sbRole = sbUser != null ? sbUser.getRole() : "visiteur";
    boolean sbIsDir = "directeur".equalsIgnoreCase(sbRole) || "admin".equalsIgnoreCase(sbRole);
    String activeNav = (String) request.getAttribute("activeNav");
    if (activeNav == null) {
        String servletPath = request.getServletPath();
        if (servletPath != null) {
            if (servletPath.contains("home")) activeNav = "dashboard";
            else if (servletPath.contains("member") || servletPath.contains("profil")) activeNav = "profils";
            else if (servletPath.contains("publication")) activeNav = "publications";
            else if (servletPath.contains("evenement")) activeNav = "evenements";
            else if (servletPath.contains("adhesion")) activeNav = "adhesions";
            else if (servletPath.contains("materiel")) activeNav = "materiel";
            else if (servletPath.contains("rapport")) activeNav = "rapport";
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

            <a href="<%= request.getContextPath() %>/home#mandats" class="sidebar-nav-item <%= "mandats".equals(activeNav) ? "active" : "" %>">
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

            <a href="<%= request.getContextPath() %>/evenements#calendrier" class="sidebar-nav-item">
                <span class="nav-glyph">▦</span>
                <span class="nav-label">Calendrier</span>
            </a>

            <a href="<%= request.getContextPath() %>/publications" class="sidebar-nav-item <%= "publications".equals(activeNav) ? "active" : "" %>">
                <span class="nav-glyph">¶</span>
                <span class="nav-label">Publications</span>
            </a>

            <a href="<%= request.getContextPath() %>/home#documents" class="sidebar-nav-item">
                <span class="nav-glyph">▤</span>
                <span class="nav-label">Archive documentaire</span>
            </a>

            <a href="<%= request.getContextPath() %>/home#communication" class="sidebar-nav-item">
                <span class="nav-glyph">❝</span>
                <span class="nav-label">Communication</span>
            </a>

            <a href="<%= request.getContextPath() %>/materiel" class="sidebar-nav-item <%= "materiel".equals(activeNav) ? "active" : "" %>">
                <span class="nav-glyph">▭</span>
                <span class="nav-label">Matériel</span>
            </a>

            <a href="<%= request.getContextPath() %>/home#conventions" class="sidebar-nav-item">
                <span class="nav-glyph">⌘</span>
                <span class="nav-label">Conventions</span>
            </a>

            <a href="<%= request.getContextPath() %>/home#pv" class="sidebar-nav-item">
                <span class="nav-glyph">≡</span>
                <span class="nav-label">Procès-verbaux</span>
            </a>
        </div>

        <!-- OUTILS -->
        <div class="sidebar-section">
            <div class="sidebar-section-title">Outils</div>

            <button type="button" class="sidebar-nav-item" onclick="openSearchModal()" style="background:none; border:none; width:100%; cursor:pointer;">
                <span class="nav-glyph">⌕</span>
                <span class="nav-label">Recherche globale</span>
            </button>

            <% if ("admin".equalsIgnoreCase(sbRole)) { %>
            <a href="<%= request.getContextPath() %>/home#admin" class="sidebar-nav-item">
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
