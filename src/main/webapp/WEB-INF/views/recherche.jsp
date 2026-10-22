<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.lias.beans.Member"%>
<%@ page import="com.lias.beans.Publication"%>
<%@ page import="com.lias.beans.Evenement"%>
<%@ page import="com.lias.beans.DocumentLabo"%>
<%@ page import="com.lias.beans.Convention"%>
<%@ page import="com.lias.beans.User"%>
<%
    String query = (String) request.getAttribute("query");
    if (query == null) query = "";
    String category = (String) request.getAttribute("category");
    if (category == null) category = "tout";

    List<Member> resMembers = (List<Member>) request.getAttribute("resMembers");
    List<Publication> resPubs = (List<Publication>) request.getAttribute("resPubs");
    List<Evenement> resEvents = (List<Evenement>) request.getAttribute("resEvents");
    List<DocumentLabo> resDocs = (List<DocumentLabo>) request.getAttribute("resDocs");
    List<Convention> resConventions = (List<Convention>) request.getAttribute("resConventions");
    Integer totalCount = (Integer) request.getAttribute("totalCount");
    if (totalCount == null) totalCount = 0;
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS — Recherche Globale</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=4">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@500;700&family=Inter:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Spectral:ital,wght@0,400;0,600;1,400&display=swap" rel="stylesheet">
    <style>
        .search-category-tabs {
            display: flex;
            gap: 8px;
            margin: 20px 0;
            border-bottom: 1px solid var(--border);
            padding-bottom: 12px;
            overflow-x: auto;
        }
        .cat-tab {
            padding: 6px 14px;
            background: transparent;
            border: 1px solid var(--border);
            border-radius: 4px;
            font-family: 'Inter', sans-serif;
            font-size: 13px;
            color: var(--muted);
            text-decoration: none;
            cursor: pointer;
            white-space: nowrap;
            transition: all 0.15s ease;
        }
        .cat-tab:hover {
            color: var(--ink);
            background: var(--surface-2);
        }
        .cat-tab.active {
            background: var(--navy);
            color: #FFF;
            border-color: var(--navy);
            font-weight: 500;
        }
        .search-item-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 4px;
            padding: 14px 18px;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            transition: all 0.15s ease;
        }
        .search-item-card:hover {
            border-color: var(--navy);
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }
    </style>
</head>
<body>
<div class="app-shell">
    <!-- APP HEADER -->
    <%@ include file="includes/app_header.jsp" %>

    <div class="app-body">
        <!-- SIDEBAR -->
        <%@ include file="includes/sidebar.jsp" %>

        <!-- MAIN -->
        <main class="app-main">
            <div class="app-content">
            <!-- SECTION HEAD -->
            <div class="section-head">
                <div>
                    <div class="section-eyebrow">Indexation transverse · full-text (CDC §15)</div>
                    <h1 class="section-title">Recherche globale</h1>
                    <p class="section-subtitle">
                        Recherche unifiée à travers les membres du laboratoire, publications, manifestations, conventions et archives.
                    </p>
                </div>
            </div>

            <!-- SEARCH BAR -->
            <div style="margin-bottom: 20px;">
                <form action="<%= request.getContextPath() %>/recherche" method="GET" style="display:flex; gap:10px;">
                    <div style="flex:1; position:relative;">
                        <span style="position:absolute; left:14px; top:50%; transform:translateY(-50%); color:var(--muted); font-size:16px;">⌕</span>
                        <input type="text" name="q" value="<%= query %>" autofocus
                               placeholder="Rechercher par mot-clé, nom de chercheur, thématique, titre de papier, partenaire..." 
                               style="width:100%; padding:12px 14px 12px 40px; border:1px solid var(--border); border-radius:4px; font-family:'Inter', sans-serif; font-size:14px; background:var(--surface);">
                    </div>
                    <button type="submit" class="btn btn-primary" style="padding:0 24px;">Rechercher</button>
                </form>
            </div>

            <!-- CATEGORY TABS -->
            <% if (!query.isEmpty()) { %>
                <div class="search-category-tabs">
                    <a href="<%= request.getContextPath() %>/recherche?q=<%= java.net.URLEncoder.encode(query, "UTF-8") %>&cat=tout" class="cat-tab <%= "tout".equals(category) ? "active" : "" %>">
                        Tout (<%= totalCount %>)
                    </a>
                    <a href="<%= request.getContextPath() %>/recherche?q=<%= java.net.URLEncoder.encode(query, "UTF-8") %>&cat=membres" class="cat-tab <%= "membres".equals(category) ? "active" : "" %>">
                        Membres (<%= resMembers != null ? resMembers.size() : 0 %>)
                    </a>
                    <a href="<%= request.getContextPath() %>/recherche?q=<%= java.net.URLEncoder.encode(query, "UTF-8") %>&cat=publications" class="cat-tab <%= "publications".equals(category) ? "active" : "" %>">
                        Publications (<%= resPubs != null ? resPubs.size() : 0 %>)
                    </a>
                    <a href="<%= request.getContextPath() %>/recherche?q=<%= java.net.URLEncoder.encode(query, "UTF-8") %>&cat=evenements" class="cat-tab <%= "evenements".equals(category) ? "active" : "" %>">
                        Évènements (<%= resEvents != null ? resEvents.size() : 0 %>)
                    </a>
                    <a href="<%= request.getContextPath() %>/recherche?q=<%= java.net.URLEncoder.encode(query, "UTF-8") %>&cat=documents" class="cat-tab <%= "documents".equals(category) ? "active" : "" %>">
                        Documents (<%= resDocs != null ? resDocs.size() : 0 %>)
                    </a>
                    <a href="<%= request.getContextPath() %>/recherche?q=<%= java.net.URLEncoder.encode(query, "UTF-8") %>&cat=conventions" class="cat-tab <%= "conventions".equals(category) ? "active" : "" %>">
                        Conventions (<%= resConventions != null ? resConventions.size() : 0 %>)
                    </a>
                </div>

                <!-- RESULTS SECTION -->
                <% if (totalCount == 0) { %>
                    <div class="card" style="padding:48px 24px; text-align:center; color:var(--muted);">
                        Aucun résultat trouvé pour « <em><%= query %></em> ». Essayez d'autres mots-clés ou vérifiez l'orthographe.
                    </div>
                <% } else { %>
                    <!-- MEMBRES -->
                    <% if (("tout".equals(category) || "membres".equals(category)) && resMembers != null && !resMembers.isEmpty()) { %>
                        <div style="margin:20px 0 10px; font-family:'Spectral', serif; font-size:17px; color:var(--ink); font-weight:600;">
                            Membres du Laboratoire (<%= resMembers.size() %>)
                        </div>
                        <% for (Member m : resMembers) { %>
                            <div class="search-item-card">
                                <div>
                                    <div style="font-size:15px; font-weight:600; color:var(--ink);">
                                        <%= m.getNom() %> <%= m.getPrenom() %>
                                    </div>
                                    <div style="font-size:12px; color:var(--muted); margin-top:2px;">
                                        <%= m.getStatut() != null ? m.getStatut().toUpperCase() : "CHERCHEUR" %> · <%= m.getEquipe() %> · <%= m.getEmail() %>
                                    </div>
                                </div>
                                <a href="<%= request.getContextPath() %>/profils" class="btn btn-ghost btn-sm">Voir profil →</a>
                            </div>
                        <% } %>
                    <% } %>

                    <!-- PUBLICATIONS -->
                    <% if (("tout".equals(category) || "publications".equals(category)) && resPubs != null && !resPubs.isEmpty()) { %>
                        <div style="margin:24px 0 10px; font-family:'Spectral', serif; font-size:17px; color:var(--ink); font-weight:600;">
                            Publications Scientifiques (<%= resPubs.size() %>)
                        </div>
                        <% for (Publication p : resPubs) { %>
                            <div class="search-item-card">
                                <div>
                                    <div style="font-size:15px; font-weight:600; color:var(--ink);">
                                        <%= p.getTitre() %>
                                    </div>
                                    <div style="font-size:12px; color:var(--muted); margin-top:2px;">
                                        <%= p.getAuteurs() %> · <em><%= p.getRevue() %></em> (<%= p.getAnnee() %>)
                                    </div>
                                </div>
                                <a href="<%= request.getContextPath() %>/publications" class="btn btn-ghost btn-sm">Consulter →</a>
                            </div>
                        <% } %>
                    <% } %>

                    <!-- ÉVÈNEMENTS -->
                    <% if (("tout".equals(category) || "evenements".equals(category)) && resEvents != null && !resEvents.isEmpty()) { %>
                        <div style="margin:24px 0 10px; font-family:'Spectral', serif; font-size:17px; color:var(--ink); font-weight:600;">
                            Événements Scientifiques (<%= resEvents.size() %>)
                        </div>
                        <% for (Evenement e : resEvents) { %>
                            <div class="search-item-card">
                                <div>
                                    <div style="font-size:15px; font-weight:600; color:var(--ink);">
                                        <%= e.getTitre() %>
                                    </div>
                                    <div style="font-size:12px; color:var(--muted); margin-top:2px;">
                                        <%= e.getType() %> · <%= e.getDate() %> · <%= e.getLieu() %>
                                    </div>
                                </div>
                                <a href="<%= request.getContextPath() %>/calendrier" class="btn btn-ghost btn-sm">Au calendrier →</a>
                            </div>
                        <% } %>
                    <% } %>

                    <!-- DOCUMENTS -->
                    <% if (("tout".equals(category) || "documents".equals(category)) && resDocs != null && !resDocs.isEmpty()) { %>
                        <div style="margin:24px 0 10px; font-family:'Spectral', serif; font-size:17px; color:var(--ink); font-weight:600;">
                            Documents Archivés (<%= resDocs.size() %>)
                        </div>
                        <% for (DocumentLabo d : resDocs) { %>
                            <div class="search-item-card">
                                <div>
                                    <div style="font-size:15px; font-weight:600; color:var(--ink);">
                                        <%= d.getNomFichier() %>
                                    </div>
                                    <div style="font-size:12px; color:var(--muted); margin-top:2px;">
                                        <%= d.getCheminComplet() %> · <%= d.getTaille() %> · <%= d.getDateFichier() %>
                                    </div>
                                </div>
                                <a href="<%= request.getContextPath() %>/documents?download=<%= d.getId() %>" class="btn btn-ghost btn-sm">Télécharger ⤓</a>
                            </div>
                        <% } %>
                    <% } %>

                    <!-- CONVENTIONS -->
                    <% if (("tout".equals(category) || "conventions".equals(category)) && resConventions != null && !resConventions.isEmpty()) { %>
                        <div style="margin:24px 0 10px; font-family:'Spectral', serif; font-size:17px; color:var(--ink); font-weight:600;">
                            Conventions & Partenariats (<%= resConventions.size() %>)
                        </div>
                        <% for (Convention c : resConventions) { %>
                            <div class="search-item-card">
                                <div>
                                    <div style="font-size:15px; font-weight:600; color:var(--ink);">
                                        <%= c.getOrganismePartenaire() %>
                                    </div>
                                    <div style="font-size:12px; color:var(--muted); margin-top:2px;">
                                        <%= c.getTypePartenaire() %> · Signée le <%= c.getDateSignature() %>
                                    </div>
                                </div>
                                <a href="<%= request.getContextPath() %>/conventions" class="btn btn-ghost btn-sm">Voir convention →</a>
                            </div>
                        <% } %>
                    <% } %>

                <% } %>
            <% } else { %>
                <div class="card" style="padding:48px 24px; text-align:center; color:var(--muted);">
                    Saisissez un mot-clé ci-dessus pour lancer une recherche instantanée dans tout le système d'information du laboratoire.
                </div>
            <% } %>
            </div>
        </main>
    </div>
</div>
</body>
</html>
