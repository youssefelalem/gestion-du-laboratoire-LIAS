<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lias.beans.User"%>
<%
    User navUser = (User) session.getAttribute("currentUser");
    
    // Récupération fiable de l'URI d'origine en cas de forward JSP
    String reqUri = (String) request.getAttribute("jakarta.servlet.forward.request_uri");
    if (reqUri == null) {
        reqUri = request.getRequestURI();
    }
    String ctx = request.getContextPath();
    String pathAfterCtx = (reqUri != null && ctx != null && reqUri.startsWith(ctx)) ? reqUri.substring(ctx.length()) : (reqUri != null ? reqUri : "");

    // Détection stricte de la page d'accueil (vitrine one-page) vs pages dédiées
    boolean isHome = "/public".equals(pathAfterCtx) || "/accueil".equals(pathAfterCtx) || "/".equals(pathAfterCtx) || "".equals(pathAfterCtx);
    boolean isProfils = pathAfterCtx.startsWith("/profils") || pathAfterCtx.startsWith("/membres");
    boolean isPubs = pathAfterCtx.startsWith("/publications");
    boolean isEvents = pathAfterCtx.startsWith("/evenements");
    boolean isAdhesions = pathAfterCtx.startsWith("/adhesions");
%>
<header class="topbar">
    <div class="brand">
        <a href="<%= isHome ? "#top" : ctx + "/public" %>" style="display:flex; align-items:center; gap:12px; text-decoration:none;">
            <span class="lias-logo" role="img" aria-label="LIAS"></span>
        </a>
    </div>

    <nav class="nav">
        <% if (isHome) { %>
            <a href="#top" class="active nav-link" id="nav-top">Accueil</a>
            <a href="#equipes" class="nav-link" id="nav-equipes">Membres</a>
            <a href="#publications" class="nav-link" id="nav-publications">Publications</a>
            <a href="#evenements" class="nav-link" id="nav-evenements">Événements</a>
        <% } else { %>
            <a href="<%= ctx %>/public" class="nav-link">Accueil</a>
            <a href="<%= ctx %>/profils" class="nav-link <%= isProfils ? "active" : "" %>">Membres</a>
            <a href="<%= ctx %>/publications" class="nav-link <%= isPubs ? "active" : "" %>">Publications</a>
            <a href="<%= ctx %>/evenements" class="nav-link <%= isEvents ? "active" : "" %>">Événements</a>
        <% } %>

        <% if (navUser != null) { %>
            <a href="<%= ctx %>/home" class="nav-link <%= "/home".equals(pathAfterCtx) ? "active" : "" %>">Tableau de bord</a>
            <a href="<%= ctx %>/adhesions" class="nav-link <%= isAdhesions ? "active" : "" %>">Adhésions</a>
            <a href="<%= ctx %>/materiel" class="nav-link <%= "/materiel".equals(pathAfterCtx) ? "active" : "" %>">Matériel</a>
            <% if ("directeur".equalsIgnoreCase(navUser.getRole()) || "admin".equalsIgnoreCase(navUser.getRole())) { %>
                <a href="<%= ctx %>/rapport" class="nav-link <%= "/rapport".equals(pathAfterCtx) ? "active" : "" %>">Rapport Annuel</a>
            <% } %>

            <div class="user-badge">
                <span><%= navUser.getPrenom() %> <%= navUser.getNom() %></span>
                <span class="user-role">[<%= navUser.getRole() %>]</span>
            </div>
            <a href="<%= ctx %>/logout" class="btn btn-sm btn-secondary" style="font-size:12px; padding:4px 10px;">Déconnexion</a>
        <% } else { %>
            <% if (isHome) { %>
                <a href="#rejoindre" class="nav-badge-btn nav-link" id="nav-rejoindre">Rejoindre</a>
            <% } else { %>
                <a href="<%= ctx %>/adhesions" class="nav-badge-btn <%= isAdhesions ? "active" : "" %>">Rejoindre</a>
            <% } %>
            <a href="<%= ctx %>/login" class="cta">Espace Membres →</a>
        <% } %>
    </nav>
</header>

