<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lias.beans.User"%>
<%
    User navUser = (User) session.getAttribute("currentUser");
    String currentPath = request.getServletPath();
    boolean isPublicPage = currentPath != null && (currentPath.contains("public") || currentPath.contains("accueil") || "/".equals(currentPath));
%>
<header class="topbar">
    <div class="brand">
        <a href="<%= isPublicPage ? "#top" : request.getContextPath() + "/public" %>" style="display:flex; align-items:center; gap:12px; text-decoration:none;">
            <div class="brand-mark">L</div>
            <div class="brand-name">LIAS <span class="est">EST. 2003</span></div>
        </a>
    </div>

    <nav class="nav">
        <% if (isPublicPage) { %>
            <a href="#top" class="active nav-link" id="nav-top">Accueil</a>
            <a href="#equipes" class="nav-link" id="nav-equipes">Membres</a>
            <a href="#publications" class="nav-link" id="nav-publications">Publications</a>
            <a href="#evenements" class="nav-link" id="nav-evenements">Événements</a>
        <% } else { %>
            <a href="<%= request.getContextPath() %>/public" class="<%= "/public".equals(currentPath) ? "active" : "" %>">Accueil</a>
            <a href="<%= request.getContextPath() %>/profils" class="<%= "/profils".equals(currentPath) ? "active" : "" %>">Membres</a>
            <a href="<%= request.getContextPath() %>/publications" class="<%= "/publications".equals(currentPath) ? "active" : "" %>">Publications</a>
            <a href="<%= request.getContextPath() %>/evenements" class="<%= "/evenements".equals(currentPath) ? "active" : "" %>">Événements</a>
        <% } %>

        <% if (navUser != null) { %>
            <a href="<%= request.getContextPath() %>/home" class="<%= "/home".equals(currentPath) ? "active" : "" %>">Tableau de bord</a>
            <a href="<%= request.getContextPath() %>/adhesions" class="<%= "/adhesions".equals(currentPath) ? "active" : "" %>">Adhésions</a>
            <a href="<%= request.getContextPath() %>/materiel" class="<%= "/materiel".equals(currentPath) ? "active" : "" %>">Matériel</a>
            <% if ("directeur".equalsIgnoreCase(navUser.getRole()) || "admin".equalsIgnoreCase(navUser.getRole())) { %>
                <a href="<%= request.getContextPath() %>/rapport" class="<%= "/rapport".equals(currentPath) ? "active" : "" %>">Rapport Annuel</a>
            <% } %>

            <div class="user-badge">
                <span><%= navUser.getPrenom() %> <%= navUser.getNom() %></span>
                <span class="user-role">[<%= navUser.getRole() %>]</span>
            </div>
            <a href="<%= request.getContextPath() %>/logout" class="btn btn-sm btn-secondary" style="font-size:12px; padding:4px 10px;">Déconnexion</a>
        <% } else { %>
            <% if (isPublicPage) { %>
                <a href="#rejoindre" class="nav-badge-btn nav-link" id="nav-rejoindre">Rejoindre</a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/adhesions" class="nav-badge-btn <%= "/adhesions".equals(currentPath) ? "active" : "" %>">Rejoindre</a>
            <% } %>
            <a href="<%= request.getContextPath() %>/login" class="cta">Espace Membres →</a>
        <% } %>
    </nav>
</header>
