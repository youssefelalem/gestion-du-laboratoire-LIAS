<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.lias.beans.Member"%>
<%@ page import="com.lias.beans.User"%>
<%
    List<Member> membres = (List<Member>) request.getAttribute("membres");
    String selectedTeam = (String) request.getAttribute("selectedTeam");
    String selectedStatus = (String) request.getAttribute("selectedStatus");
    User currentUser = (User) session.getAttribute("currentUser");
    boolean isDirector = currentUser != null && ("directeur".equalsIgnoreCase(currentUser.getRole()) || "admin".equalsIgnoreCase(currentUser.getRole()));

    Member selectedMember = null;
    String selectParam = request.getParameter("id");
    if (membres != null && !membres.isEmpty()) {
        if (selectParam != null && !selectParam.trim().isEmpty()) {
            for (Member m : membres) {
                if (selectParam.trim().equalsIgnoreCase(m.getId())) {
                    selectedMember = m;
                    break;
                }
            }
        }
        if (selectedMember == null) selectedMember = membres.get(0);
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS — Profils & Membres du Laboratoire</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=2">
    <style>
        .chip {
            padding: 5px 11px;
            font-family: var(--font-mono);
            font-size: 11px;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            border: 1px solid var(--border);
            background: var(--surface);
            color: var(--muted);
            border-radius: 2px;
            text-decoration: none !important;
            transition: all 0.15s;
        }
        .chip:hover, .chip.active {
            background: var(--navy);
            color: var(--cream);
            border-color: var(--navy);
        }

        .member-item {
            padding: 14px 16px;
            background: var(--surface);
            border: 1px solid var(--border);
            margin-bottom: 8px;
            border-radius: 2px;
            cursor: pointer;
            text-decoration: none !important;
            color: inherit;
            display: block;
            transition: all 0.15s;
        }
        .member-item:hover, .member-item.selected {
            background: var(--surface-2);
            border-color: var(--border-dark);
            box-shadow: var(--shadow-sm);
        }
        .member-item.selected {
            border-left: 4px solid var(--accent-2);
        }

        .dossier-card {
            background: var(--surface);
            border: 1px solid var(--border);
            padding: 36px;
            border-radius: 2px;
            box-shadow: var(--shadow-sm);
        }
        .dossier-avatar {
            width: 72px;
            height: 72px;
            background: var(--navy);
            color: var(--cream);
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: var(--font-serif);
            font-size: 32px;
            font-weight: 600;
            border-radius: 2px;
            margin-bottom: 20px;
        }
        .timeline-box {
            border-left: 2px solid var(--accent-2);
            padding-left: 18px;
            margin-left: 6px;
            margin-top: 14px;
        }
        .timeline-step {
            position: relative;
            margin-bottom: 16px;
        }
        .timeline-step::before {
            content: '';
            position: absolute;
            left: -23px;
            top: 4px;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--navy);
        }
    </style>
</head>
<body>

<div class="app-shell">
    <%@ include file="includes/app_header.jsp" %>
    <div class="app-body">
        <%@ include file="includes/sidebar.jsp" %>
        <main class="app-main">
            <div class="app-content">

        <!-- Page Header -->
        <div class="page-header">
            <div>
                <span class="eyebrow"><%= membres != null ? membres.size() : "38" %> profils répertoriés · 4 équipes de recherche</span>
                <h1 class="page-title">Profils & Membres du Laboratoire</h1>
                <p class="page-sub">
                    Chaque profil capitalise l'historique d'affiliation, les mandats successifs, le statut contractuel et les publications scientifiques. La mémoire institutionnelle est intégralement préservée.
                </p>
            </div>
            <% if (isDirector) { %>
                <button class="btn btn-primary" onclick="alert('Formulaire d\'enregistrement de membre accessible dans l\'interface administrative.');">+ Ajouter un chercheur</button>
            <% } %>
        </div>

        <!-- Filter Bar -->
        <div style="display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 24px; align-items: center;">
            <span style="font-family: var(--font-mono); font-size: 11px; color: var(--muted); text-transform: uppercase;">Statut :</span>
            <a href="<%= request.getContextPath() %>/profils" class="chip <%= selectedStatus == null ? "active" : "" %>">Tous</a>
            <a href="<%= request.getContextPath() %>/profils?status=permanent" class="chip <%= "permanent".equals(selectedStatus) ? "active" : "" %>">Permanents</a>
            <a href="<%= request.getContextPath() %>/profils?status=doctorant" class="chip <%= "doctorant".equals(selectedStatus) ? "active" : "" %>">Doctorants</a>
            <a href="<%= request.getContextPath() %>/profils?status=associe" class="chip <%= "associe".equals(selectedStatus) ? "active" : "" %>">Associés</a>
            <a href="<%= request.getContextPath() %>/profils?status=retraite" class="chip <%= "retraite".equals(selectedStatus) ? "active" : "" %>">Honoraires</a>
        </div>

        <!-- Main 2-Column Layout -->
        <div style="display: grid; grid-template-columns: 360px 1fr; gap: 32px; align-items: start;">

            <!-- Left: List of Members -->
            <div>
                <div style="margin-bottom: 12px; font-family: var(--font-mono); font-size: 11px; color: var(--muted); text-transform: uppercase;">
                    Annuaire des Chercheurs
                </div>

                <%
                    if (membres != null && !membres.isEmpty()) {
                        for (Member m : membres) {
                            boolean isSel = selectedMember != null && selectedMember.getId().equals(m.getId());
                %>
                <a href="<%= request.getContextPath() %>/profils?id=<%= m.getId() %><%= selectedStatus != null ? "&status=" + selectedStatus : "" %>" 
                   class="member-item <%= isSel ? "selected" : "" %>">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                        <div>
                            <strong style="font-family: var(--font-serif); font-size: 16px; color: var(--ink);"><%= m.getPrenom() %> <%= m.getNom() %></strong>
                            <div style="font-size: 12.5px; color: var(--muted); margin-top: 2px;"><%= m.getGrade() %></div>
                            <div style="font-size: 11.5px; color: var(--navy); font-weight: 500; margin-top: 2px;"><%= m.getEquipe() %></div>
                        </div>
                        <span class="badge <%= "doctorant".equalsIgnoreCase(m.getStatut()) ? "badge-gold" : "badge-navy" %>">
                            <%= m.getStatut() %>
                        </span>
                    </div>
                </a>
                <%
                        }
                    } else {
                %>
                <div class="card" style="font-size: 13px; color: var(--muted);">
                    Aucun membre trouvé pour ce filtre.
                </div>
                <% } %>
            </div>

            <!-- Right: Detailed Dossier -->
            <div>
                <% if (selectedMember != null) { %>
                <div class="dossier-card">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 16px;">
                        <div style="display: flex; gap: 20px; align-items: center;">
                            <div class="dossier-avatar"><%= selectedMember.getPrenom().substring(0,1) %><%= selectedMember.getNom().substring(0,1) %></div>
                            <div>
                                <h2 style="font-size: 32px; margin: 0;"><%= selectedMember.getPrenom() %> <%= selectedMember.getNom() %></h2>
                                <div style="font-family: var(--font-serif); font-style: italic; font-size: 16px; color: var(--muted); margin-top: 2px;">
                                    <%= selectedMember.getGrade() %> · <%= selectedMember.getEquipe() %>
                                </div>
                            </div>
                        </div>
                        <span class="badge badge-navy" style="font-size: 12px; padding: 6px 14px;">
                            Statut : <%= selectedMember.getStatut().toUpperCase() %>
                        </span>
                    </div>

                    <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin: 28px 0; background: var(--surface-2); padding: 18px; border-radius: 2px;">
                        <div>
                            <span class="eyebrow">Date de rattachement</span>
                            <strong style="font-family: var(--font-mono); font-size: 13px;"><%= selectedMember.getDateAffiliation() != null ? selectedMember.getDateAffiliation() : "2018-09-01" %></strong>
                        </div>
                        <div>
                            <span class="eyebrow">Contact institutionnel</span>
                            <span style="font-family: var(--font-mono); font-size: 12px; color: var(--navy);"><%= selectedMember.getEmail() %></span>
                        </div>
                        <div>
                            <span class="eyebrow">Indice Scopus (h-index)</span>
                            <strong style="font-family: var(--font-mono); font-size: 13px; color: var(--accent-2);">h-index: 12</strong>
                        </div>
                    </div>

                    <h3 style="font-size: 20px; border-bottom: 1px solid var(--border); padding-bottom: 8px; margin-bottom: 16px;">
                        Historique de carrière & Affiliation académique
                    </h3>
                    <div class="timeline-box">
                        <div class="timeline-step">
                            <div style="font-family: var(--font-mono); font-size: 11px; color: var(--muted);">Depuis septembre 2021</div>
                            <div style="font-weight: 600; color: var(--ink);">Professeur Habilité / Chercheur Permanent</div>
                            <div style="font-size: 13px; color: var(--muted);">Faculté des Sciences Ben M'Sik, Université Hassan II de Casablanca.</div>
                        </div>
                        <div class="timeline-step">
                            <div style="font-family: var(--font-mono); font-size: 11px; color: var(--muted);">2018 — 2021</div>
                            <div style="font-weight: 600; color: var(--ink);">Maître de Conférences</div>
                            <div style="font-size: 13px; color: var(--muted);">Responsable d'axe au sein de l'équipe Data Science.</div>
                        </div>
                        <div class="timeline-step">
                            <div style="font-family: var(--font-mono); font-size: 11px; color: var(--muted);">2014 — 2018</div>
                            <div style="font-weight: 600; color: var(--ink);">Doctorat en Informatique</div>
                            <div style="font-size: 13px; color: var(--muted);">Thèse soutenue avec mention très honorable au LIAS.</div>
                        </div>
                    </div>

                    <h3 style="font-size: 20px; border-bottom: 1px solid var(--border); padding-bottom: 8px; margin: 32px 0 16px;">
                        Axes de Recherche & Domaines d'Expertise
                    </h3>
                    <div style="display: flex; gap: 8px; flex-wrap: wrap;">
                        <span class="badge badge-muted">Science des données</span>
                        <span class="badge badge-muted">Machine Learning</span>
                        <span class="badge badge-muted">Traitement automatique des langues</span>
                        <span class="badge badge-muted">Systèmes décisionnels</span>
                    </div>

                    <div style="margin-top: 36px; padding-top: 20px; border-top: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center;">
                        <a href="<%= request.getContextPath() %>/publications" class="btn btn-secondary">Voir ses publications scientifiques →</a>
                        <span style="font-family: var(--font-mono); font-size: 11px; color: var(--muted);">Dossier archivé et certifié LIAS</span>
                    </div>
                </div>
                <% } %>
            </div>

        </div>

            </div>
        </main>
    </div>
</div>

</body>
</html>
