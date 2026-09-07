<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lias.beans.User"%>
<%
    User navUser = (User) session.getAttribute("currentUser");
    String currentPath = request.getServletPath();
%>
<header class="topbar">
    <div class="brand">
        <a href="<%= request.getContextPath() %>/public" style="display:flex; align-items:center; gap:12px; text-decoration:none;">
            <div class="brand-mark">L</div>
            <div class="brand-name">LIAS <span class="est">EST. 2003</span></div>
        </a>
    </div>

    <nav class="nav">
        <a href="<%= request.getContextPath() %>/public" class="<%= "/public".equals(currentPath) ? "active" : "" %>">Accueil</a>
        <a href="<%= request.getContextPath() %>/profils" class="<%= "/profils".equals(currentPath) ? "active" : "" %>">Membres</a>
        <a href="<%= request.getContextPath() %>/publications" class="<%= "/publications".equals(currentPath) ? "active" : "" %>">Publications</a>
        <a href="<%= request.getContextPath() %>/evenements" class="<%= "/evenements".equals(currentPath) ? "active" : "" %>">Événements</a>

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
            <a href="<%= request.getContextPath() %>/adhesions">Rejoindre</a>
            <a href="<%= request.getContextPath() %>/login" class="cta">Espace Membres →</a>
        <% } %>
    </nav>
</header>
