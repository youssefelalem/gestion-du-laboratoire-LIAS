<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.lias.beans.AffiliationPeriod"%>
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
            background: linear-gradient(135deg, var(--primary-deep) 0%, var(--primary) 100%);
            color: #FFFFFF !important;
            border-color: var(--primary-dark);
            box-shadow: 0 2px 8px rgba(37, 99, 235, 0.25);
        }

        .member-item {
            padding: 14px 16px;
            background: var(--surface);
            border: 1px solid var(--border);
            margin-bottom: 8px;
            border-radius: 4px;
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
            border-left: 4px solid var(--primary);
            background: #EFF6FF;
        }

        .dossier-card {
            background: var(--surface);
            border: 1px solid var(--border);
            padding: 36px;
            border-radius: 6px;
            box-shadow: var(--shadow-sm);
        }
        .dossier-avatar {
            width: 72px;
            height: 72px;
            background: linear-gradient(135deg, var(--primary-deep) 0%, var(--primary) 100%);
            color: #FFFFFF;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: var(--font-serif);
            font-size: 32px;
            font-weight: 600;
            border-radius: 6px;
            margin-bottom: 20px;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);
        }
        .timeline-box {
            border-left: 2px solid var(--primary-border);
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
            background: var(--primary);
        }
    </style>
</head>
<body>

<% if (currentUser == null) { %>
    <%@ include file="includes/navbar.jsp" %>
    <div class="container" style="max-width: 1280px; margin: 0 auto; padding: 40px 24px;">
<% } else { %>
    <div class="app-shell">
        <%@ include file="includes/app_header.jsp" %>
        <div class="app-body">
            <%@ include file="includes/sidebar.jsp" %>
            <main class="app-main">
                <div class="app-content">
<% } %>

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
                <a href="<%= request.getContextPath() %>/admin" class="btn btn-primary">+ Gérer les comptes chercheurs →</a>
            <% } %>
        </div>

        <% if ("profil_mis_a_jour".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success" style="background:#e8f5e9; border:1px solid #c8e6c9; color:#2e7d32; padding:12px 16px; border-radius:4px; margin-bottom:20px; font-size:13px; display:flex; align-items:center; gap:8px;">
                <span>✓</span>
                <strong>Succès :</strong> Le profil a été mis à jour avec succès dans le registre institutionnel du LIAS.
            </div>
        <% } %>

        <!-- Filter Bar -->
        <div style="display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 24px; align-items: center;">
            <span style="font-family: var(--font-mono); font-size: 11px; color: var(--muted); text-transform: uppercase;">Statut :</span>
            <a href="<%= request.getContextPath() %>/profils" class="chip <%= selectedStatus == null ? "active" : "" %>">Tous</a>
            <a href="<%= request.getContextPath() %>/profils?status=permanent" class="chip <%= "permanent".equals(selectedStatus) ? "active" : "" %>">Permanents</a>
            <a href="<%= request.getContextPath() %>/profils?status=doctorant" class="chip <%= "doctorant".equals(selectedStatus) ? "active" : "" %>">Doctorants</a>
            <a href="<%= request.getContextPath() %>/profils?status=associe" class="chip <%= "associe".equals(selectedStatus) ? "active" : "" %>">Associés</a>
            <a href="<%= request.getContextPath() %>/profils?status=retraite" class="chip <%= "retraite".equals(selectedStatus) ? "active" : "" %>">Retraités / Émérites</a>
            <a href="<%= request.getContextPath() %>/profils?status=ancien" class="chip <%= "ancien".equals(selectedStatus) ? "active" : "" %>">Anciens membres</a>
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
                    <div style="display: flex; gap: 12px; align-items: center;">
                        <% if (m.getPhoto() != null && !m.getPhoto().trim().isEmpty()) { %>
                            <img src="<%= m.getPhoto() %>" alt="" style="width: 42px; height: 42px; border-radius: 50%; object-fit: cover; border: 1.5px solid var(--border); flex-shrink:0;">
                        <% } else { %>
                            <div style="width: 42px; height: 42px; border-radius: 50%; background: var(--surface-2); display: flex; align-items: center; justify-content: center; font-weight: 600; font-size: 13px; color: var(--navy); border: 1.5px solid var(--border); flex-shrink:0;">
                                <%= m.getPrenom().substring(0,1) %><%= m.getNom().substring(0,1) %>
                            </div>
                        <% } %>
                        <div style="flex: 1; min-width: 0;">
                            <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                                <strong style="font-family: var(--font-serif); font-size: 15.5px; color: var(--ink);"><%= m.getPrenom() %> <%= m.getNom() %></strong>
                                <span class="badge <%= "doctorant".equalsIgnoreCase(m.getStatut()) ? "badge-gold" : "badge-navy" %>" style="font-size: 10px; padding: 2px 7px;">
                                    <%= m.getStatut() %>
                                </span>
                            </div>
                            <div style="font-size: 12px; color: var(--muted); margin-top: 1px;"><%= m.getGrade() %></div>
                            <div style="font-size: 11px; color: var(--navy); font-weight: 500; margin-top: 1px;"><%= m.getEquipe() %> · <%= m.getLaboratoire() %></div>
                        </div>
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
                            <% if (selectedMember.getPhoto() != null && !selectedMember.getPhoto().trim().isEmpty()) { %>
                                <img src="<%= selectedMember.getPhoto() %>" alt="<%= selectedMember.getPrenom() %> <%= selectedMember.getNom() %>" 
                                     style="width: 84px; height: 84px; border-radius: 50%; object-fit: cover; border: 3px solid var(--navy); box-shadow: var(--shadow-md); flex-shrink:0;">
                            <% } else { %>
                                <div class="dossier-avatar"><%= selectedMember.getPrenom().substring(0,1) %><%= selectedMember.getNom().substring(0,1) %></div>
                            <% } %>
                            <div>
                                <h2 style="font-size: 30px; margin: 0;"><%= selectedMember.getPrenom() %> <%= selectedMember.getNom() %></h2>
                                <div style="font-family: var(--font-serif); font-style: italic; font-size: 16px; color: var(--muted); margin-top: 2px;">
                                    <%= selectedMember.getGrade() %> · Équipe <%= selectedMember.getEquipe() %>
                                </div>
                                <div style="font-size: 12.5px; color: var(--navy); margin-top: 4px;">
                                    🏛️ <%= selectedMember.getEtablissement() %> (<%= selectedMember.getLaboratoire() %>)
                                </div>
                            </div>
                        </div>
                        <div style="display: flex; gap: 8px; align-items: center;">
                            <span class="badge badge-navy" style="font-size: 12px; padding: 6px 14px;">
                                Statut : <%= selectedMember.getStatut().toUpperCase() %>
                            </span>
                            <% if (currentUser != null && (isDirector || (currentUser.getEmail() != null && currentUser.getEmail().equalsIgnoreCase(selectedMember.getEmail())))) { %>
                                <button type="button" class="btn btn-sm btn-secondary" onclick="openEditModal()" style="font-size: 12px; padding: 6px 12px; cursor: pointer;">
                                    ✎ Modifier ce profil
                                </button>
                            <% } %>
                        </div>
                    </div>

                    <% if ("retraite".equalsIgnoreCase(selectedMember.getStatut())) { %>
                        <div style="background: #fffbeb; border: 1px solid #fde68a; border-left: 4px solid #d97706; padding: 14px 18px; border-radius: 6px; margin: 20px 0; font-size: 13px; color: #92400e; display: flex; align-items: flex-start; gap: 12px; box-shadow: var(--shadow-sm);">
                            <span style="font-size: 22px; line-height: 1;">🏛️</span>
                            <div>
                                <strong style="display: block; font-size: 13.5px; margin-bottom: 2px;">Mémoire Académique Institutionnelle (CDC §2.D & §8.1)</strong>
                                Professeur Émérite / Retraité. Ce compte est <strong>gelé</strong> pour préserver l'intégrité des archives, tout en maintenant l'ensemble des publications scientifiques, contributions et thématiques accessibles au public et aux chercheurs.
                            </div>
                        </div>
                    <% } else if ("ancien".equalsIgnoreCase(selectedMember.getStatut())) { %>
                        <div style="background: #f8fafc; border: 1px solid #cbd5e1; border-left: 4px solid #64748b; padding: 14px 18px; border-radius: 6px; margin: 20px 0; font-size: 13px; color: #334155; display: flex; align-items: flex-start; gap: 12px; box-shadow: var(--shadow-sm);">
                            <span style="font-size: 22px; line-height: 1;">📋</span>
                            <div>
                                <strong style="display: block; font-size: 13.5px; margin-bottom: 2px;">Ancien Membre (CDC §2.E & §8.2)</strong>
                                Chercheur ayant quitté le laboratoire. Compte utilisateur désactivé. L'historique des travaux scientifiques et les périodes d'affiliation restent archivés dans le système.
                            </div>
                        </div>
                    <% } %>

                    <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 14px; margin: 24px 0; background: var(--surface-2); padding: 16px; border-radius: 4px; border: 1px solid var(--border);">
                        <div>
                            <span class="eyebrow">Rattachement</span>
                            <strong style="font-family: var(--font-mono); font-size: 12.5px;"><%= selectedMember.getDateAffiliation() != null ? selectedMember.getDateAffiliation() : "2021-09-01" %></strong>
                        </div>
                        <div>
                            <span class="eyebrow">Établissement</span>
                            <span style="font-size: 12px; color: var(--ink); font-weight: 500;"><%= selectedMember.getEtablissement() %></span>
                        </div>
                        <div>
                            <span class="eyebrow">Laboratoire</span>
                            <span style="font-size: 12px; color: var(--navy); font-weight: 600;"><%= selectedMember.getLaboratoire() %></span>
                        </div>
                        <div>
                            <span class="eyebrow">Contact</span>
                            <span style="font-family: var(--font-mono); font-size: 11.5px; color: var(--navy);"><%= selectedMember.getEmail() %></span>
                        </div>
                    </div>

                    <!-- Biographie Scientifique (CDC §3) -->
                    <h3 style="font-size: 19px; border-bottom: 1px solid var(--border); padding-bottom: 6px; margin: 24px 0 10px;">
                        Biographie Scientifique (CDC §3)
                    </h3>
                    <p style="font-size: 14px; color: var(--ink); line-height: 1.65; margin-bottom: 20px;">
                        <%= selectedMember.getBiographie() != null && !selectedMember.getBiographie().trim().isEmpty() ? selectedMember.getBiographie() : "Chercheur au sein du Laboratoire LIAS, impliqué dans les projets de recherche scientifique et la formation académique." %>
                    </p>

                    <!-- Centres d'Intérêt & Thématiques (CDC §3) -->
                    <h3 style="font-size: 19px; border-bottom: 1px solid var(--border); padding-bottom: 6px; margin: 24px 0 10px;">
                        Centres d'Intérêt & Thématiques de Recherche (CDC §3)
                    </h3>
                    <div style="display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 24px;">
                        <%
                            String ci = selectedMember.getCentresInteret();
                            if (ci != null && !ci.trim().isEmpty()) {
                                for (String tag : ci.split(",")) {
                        %>
                            <span class="badge badge-navy" style="font-size: 12px; padding: 5px 12px;"><%= tag.trim() %></span>
                        <%
                                }
                            } else {
                        %>
                            <span class="badge badge-muted">Science des données</span>
                            <span class="badge badge-muted">Intelligence Artificielle</span>
                        <% } %>
                    </div>

                    <%
                        List<AffiliationPeriod> affPeriods = (List<AffiliationPeriod>) request.getAttribute("affiliationPeriods");
                        if (affPeriods == null && selectedMember != null) {
                            affPeriods = new com.lias.dao.MemberDaoImpl().getAffiliationPeriods(selectedMember.getId());
                        }
                    %>
                    <h3 style="font-size: 19px; border-bottom: 1px solid var(--border); padding-bottom: 6px; margin-bottom: 14px;">
                        Historique de carrière & Périodes d'affiliation (CDC §3 & §4.3 ⭐)
                    </h3>
                    <div class="timeline-box">
                        <% if (affPeriods != null && !affPeriods.isEmpty()) { 
                            for (AffiliationPeriod ap : affPeriods) { %>
                                <div class="timeline-step">
                                    <div style="font-family: var(--font-mono); font-size: 11.5px; color: #B89255; font-weight: 700;">
                                        <%= ap.getDateDebut() %> ⟶ <%= ap.getDateFin() != null ? ap.getDateFin() : "Présent (En exercice)" %>
                                    </div>
                                    <div style="font-weight: 700; color: var(--navy); text-transform: uppercase; font-size: 13.5px; margin-top: 2px;">
                                        Rôle officiel : <%= ap.getRoleHistorique() %>
                                    </div>
                                    <div style="font-size: 12.5px; color: var(--muted); margin-top: 2px;">
                                        <%= selectedMember.getEtablissement() %> · <%= selectedMember.getLaboratoire() %> (Équipe <%= selectedMember.getEquipe() %>)
                                    </div>
                                </div>
                        <% } } else { %>
                            <div class="timeline-step">
                                <div style="font-family: var(--font-mono); font-size: 11.5px; color: #B89255; font-weight: 700;">
                                    Depuis le <%= selectedMember.getDateAffiliation() != null ? selectedMember.getDateAffiliation() : "2021-09-01" %>
                                </div>
                                <div style="font-weight: 700; color: var(--navy); font-size: 13.5px;">
                                    <%= selectedMember.getGrade() %> / Statut <%= selectedMember.getStatut() %>
                                </div>
                                <div style="font-size: 12.5px; color: var(--muted); margin-top: 2px;">
                                    <%= selectedMember.getEtablissement() %> · <%= selectedMember.getLaboratoire() %> (Équipe <%= selectedMember.getEquipe() %>)
                                </div>
                            </div>
                        <% } %>
                    </div>

                    <div style="margin-top: 32px; padding-top: 18px; border-top: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px;">
                        <a href="<%= request.getContextPath() %>/publications?author=<%= java.net.URLEncoder.encode(selectedMember.getNom(), "UTF-8") %>" class="btn-section-cta">
                            Voir les publications de <%= selectedMember.getPrenom() %> <%= selectedMember.getNom() %> <span class="arrow">→</span>
                        </a>
                        <span style="font-family: var(--font-mono); font-size: 11px; color: var(--muted);">Dossier archivé et certifié LIAS (CDC §3)</span>
                    </div>

                </div>
                <% } %>
            </div>

        </div>

<% if (currentUser == null) { %>
    </div>
    <%@ include file="includes/footer.jsp" %>
<% } else { %>
            </div>
        </main>
    </div>
</div>
<% } %>

<% if (currentUser != null && selectedMember != null) { %>
<!-- Modal Modifier Profil (CDC §3) -->
<div id="editProfileModal" class="modal-backdrop" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:2000; align-items:center; justify-content:center;">
    <div class="modal-card" style="background:var(--surface); border:1px solid var(--border); width:100%; max-width:540px; padding:28px; border-radius:4px; box-shadow:var(--shadow-lg);">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; border-bottom:1px solid var(--border); padding-bottom:12px;">
            <h3 style="margin:0; font-family:var(--font-serif); font-size:20px; color:var(--navy);">Modifier le profil chercheur (CDC §3)</h3>
            <button type="button" onclick="closeEditModal()" style="background:none; border:none; font-size:18px; cursor:pointer; color:var(--muted);">✕</button>
        </div>
        <form action="<%= request.getContextPath() %>/profils" method="post">
            <input type="hidden" name="id" value="<%= selectedMember.getId() %>">
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px; margin-bottom:14px;">
                <div>
                    <label style="display:block; font-family:var(--font-mono); font-size:11px; text-transform:uppercase; color:var(--muted); margin-bottom:6px;">Prénom</label>
                    <input type="text" name="firstName" class="form-control" value="<%= selectedMember.getPrenom() %>" required>
                </div>
                <div>
                    <label style="display:block; font-family:var(--font-mono); font-size:11px; text-transform:uppercase; color:var(--muted); margin-bottom:6px;">Nom</label>
                    <input type="text" name="lastName" class="form-control" value="<%= selectedMember.getNom() %>" required>
                </div>
            </div>
            <div style="margin-bottom:14px;">
                <label style="display:block; font-family:var(--font-mono); font-size:11px; text-transform:uppercase; color:var(--muted); margin-bottom:6px;">Photo de profil (URL / Image)</label>
                <input type="url" name="photo" class="form-control" value="<%= selectedMember.getPhoto() != null ? selectedMember.getPhoto() : "" %>" placeholder="https://exemple.com/photo.jpg">
            </div>
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px; margin-bottom:14px;">
                <div>
                    <label style="display:block; font-family:var(--font-mono); font-size:11px; text-transform:uppercase; color:var(--muted); margin-bottom:6px;">Établissement d'origine</label>
                    <input type="text" name="etablissementOrigine" class="form-control" value="<%= selectedMember.getEtablissement() %>">
                </div>
                <div>
                    <label style="display:block; font-family:var(--font-mono); font-size:11px; text-transform:uppercase; color:var(--muted); margin-bottom:6px;">Laboratoire d'origine</label>
                    <input type="text" name="laboratoireOrigine" class="form-control" value="<%= selectedMember.getLaboratoire() %>">
                </div>
            </div>
            <div style="margin-bottom:14px;">
                <label style="display:block; font-family:var(--font-mono); font-size:11px; text-transform:uppercase; color:var(--muted); margin-bottom:6px;">Grade académique</label>
                <input type="text" name="grade" class="form-control" value="<%= selectedMember.getGrade() %>" required>
            </div>
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px; margin-bottom:14px;">
                <div>
                    <label style="display:block; font-family:var(--font-mono); font-size:11px; text-transform:uppercase; color:var(--muted); margin-bottom:6px;">Équipe de recherche</label>
                    <select name="team" class="form-control">
                        <option value="IA" <%= "IA".equalsIgnoreCase(selectedMember.getEquipe()) ? "selected" : "" %>>IA (Intelligence Artificielle)</option>
                        <option value="Big Data" <%= "Big Data".equalsIgnoreCase(selectedMember.getEquipe()) ? "selected" : "" %>>Big Data & Cloud</option>
                        <option value="NLP" <%= "NLP".equalsIgnoreCase(selectedMember.getEquipe()) ? "selected" : "" %>>NLP & Traitement Automatique</option>
                        <option value="Sécurité" <%= "Sécurité".equalsIgnoreCase(selectedMember.getEquipe()) ? "selected" : "" %>>Sécurité & Systèmes</option>
                    </select>
                </div>
                <div>
                    <label style="display:block; font-family:var(--font-mono); font-size:11px; text-transform:uppercase; color:var(--muted); margin-bottom:6px;">Statut</label>
                    <select name="status" class="form-control" <%= isDirector ? "" : "disabled" %>>
                        <option value="permanent" <%= "permanent".equalsIgnoreCase(selectedMember.getStatut()) ? "selected" : "" %>>Permanent</option>
                        <option value="doctorant" <%= "doctorant".equalsIgnoreCase(selectedMember.getStatut()) ? "selected" : "" %>>Doctorant</option>
                        <option value="associe" <%= "associe".equalsIgnoreCase(selectedMember.getStatut()) ? "selected" : "" %>>Associé</option>
                        <option value="retraite" <%= "retraite".equalsIgnoreCase(selectedMember.getStatut()) ? "selected" : "" %>>Retraité / Émérite (Compte gelé - CDC §8.1)</option>
                        <option value="ancien" <%= "ancien".equalsIgnoreCase(selectedMember.getStatut()) ? "selected" : "" %>>Ancien membre (Départ - CDC §8.2)</option>
                    </select>
                    <% if (!isDirector) { %>
                        <input type="hidden" name="status" value="<%= selectedMember.getStatut() %>">
                    <% } %>
                </div>
            </div>
            <div style="margin-bottom:14px;">
                <label style="display:block; font-family:var(--font-mono); font-size:11px; text-transform:uppercase; color:var(--muted); margin-bottom:6px;">Centres d'intérêt (séparés par des virgules)</label>
                <input type="text" name="centresInteret" class="form-control" value="<%= selectedMember.getCentresInteret() != null ? selectedMember.getCentresInteret() : "" %>" placeholder="NLP, Deep Learning, Big Data">
            </div>
            <div style="margin-bottom:18px;">
                <label style="display:block; font-family:var(--font-mono); font-size:11px; text-transform:uppercase; color:var(--muted); margin-bottom:6px;">Biographie Scientifique</label>
                <textarea name="biographie" class="form-control" rows="3" placeholder="Parcours et thématiques de recherche..."><%= selectedMember.getBiographie() != null ? selectedMember.getBiographie() : "" %></textarea>
            </div>
            <div style="display:flex; justify-content:flex-end; gap:12px;">
                <button type="button" onclick="closeEditModal()" class="btn btn-secondary">Annuler</button>
                <button type="submit" class="btn btn-primary">Enregistrer les modifications</button>
            </div>
        </form>
    </div>
</div>
<script>
    function openEditModal() {
        var m = document.getElementById('editProfileModal');
        if (m) m.style.display = 'flex';
    }
    function closeEditModal() {
        var m = document.getElementById('editProfileModal');
        if (m) m.style.display = 'none';
    }
</script>
<% } %>

</body>
</html>
