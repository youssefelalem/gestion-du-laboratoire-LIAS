<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- LIAS Home Dashboard - Updated with Font Awesome Icons --%>
<%@ page import="com.lias.beans.User"%>
<%@ page import="com.lias.beans.Evenement"%>
<%@ page import="com.lias.beans.DemandeAdhesion"%>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    String userRole = currentUser != null ? currentUser.getRole() : "visiteur";
    boolean isDirector = "directeur".equalsIgnoreCase(userRole) || "admin".equalsIgnoreCase(userRole);
    request.setAttribute("activeNav", "dashboard");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS — Tableau de bord institutionnel</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=4">
    <style>
        .gov-tile {
            background: var(--surface-2);
            border: 1px solid var(--border);
            border-left: 3px solid #CBD5E1;
            padding: 10px 14px;
            border-radius: 4px;
            transition: all 0.15s ease;
        }
        .gov-tile:hover {
            border-left-color: var(--primary);
            background: #EFF6FF;
            transform: translateX(2px);
        }
        .gov-tile-label {
            font-family: var(--font-mono);
            font-size: 10px;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 2px;
        }
        .gov-tile-name {
            font-family: var(--font-serif);
            font-size: 14px;
            font-weight: 500;
            color: var(--ink);
        }
        .mandate-track {
            position: relative;
            height: 8px;
            background: var(--surface-2);
            border: 1px solid var(--border);
            margin: 12px 0 8px;
            border-radius: 4px;
            overflow: hidden;
        }
        .mandate-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--primary) 0%, var(--indigo) 100%);
            width: 58%;
            border-radius: 4px;
        }
        .report-line {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 0;
            border-top: 1px solid var(--border);
            font-size: 13px;
        }
    </style>
</head>
<body>

<div class="app-shell">
    <!-- Top Sticky Header -->
    <%@ include file="includes/app_header.jsp" %>

    <div class="app-body">
        <!-- Left Sidebar Navigation -->
        <%@ include file="includes/sidebar.jsp" %>

        <!-- Main Workspace -->
        <main class="app-main">
            <div class="app-content">

                <!-- Header Welcome Section -->
                <div>
                    <div class="eyebrow" style="margin-bottom: 6px;">
                        LUNDI 26 MAI 2026 · 15 MOIS RESTANTS DE MANDAT
                    </div>
                    <h1 style="font-size: 38px; font-weight: 500; margin: 0 0 6px; letter-spacing: -0.015em;">
                        Bonjour, <%= currentUser != null ? currentUser.getPrenom() + " " + currentUser.getNom() : "Youssef" %>.
                    </h1>
                    <p style="font-family: var(--font-serif); font-style: italic; font-size: 18px; color: var(--muted); margin: 0 0 16px; line-height: 1.5;">
                        <% if (isDirector) { %>
                            Quatre demandes d'adhésion attendent votre décision. Le rapport annuel 2025–2026 est à 78 % de complétude.
                        <% } else { %>
                            Bienvenue sur la plateforme de mémoire institutionnelle et de gestion du laboratoire LIAS.
                        <% } %>
                    </p>
                </div>

                <% if ("acces_interdit_doctorant".equals(request.getParameter("error"))) { %>
                <div style="background: #FFFBEB; border: 1px solid #FDE68A; border-left: 4px solid #D97706; padding: 14px 18px; border-radius: 6px; margin-bottom: 24px; color: #92400E; font-size: 13.5px; display: flex; align-items: flex-start; gap: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.05);">
                    <span style="font-size: 22px; line-height: 1;">🔒</span>
                    <div>
                        <strong style="display: block; font-size: 14px; margin-bottom: 2px;">Module Interne Réservé (Règle Métier CDC §2.2 C)</strong>
                        Conformément au cahier des charges officiel du laboratoire LIAS, les comptes <strong>Doctorants</strong> bénéficient d'un accès focalisé sur la consultation et la déclaration de leurs <em>publications scientifiques</em> et de leur profil. L'accès aux modules de gouvernance et gestion interne (matériel, conventions, mandats, délibérations PV, budget) est statutairement réservé aux membres permanents et à la direction.
                    </div>
                </div>
                <% } %>

                <!-- KPI Cards Strip -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="k">Membres Actifs</div>
                        <div class="v"><%= request.getAttribute("totalMembres") != null ? request.getAttribute("totalMembres") : "33" %></div>
                        <div class="s">dont 11 doctorants inscrits</div>
                    </div>
                    <div class="stat-card">
                        <div class="k">Publications 2026</div>
                        <div class="v"><%= request.getAttribute("totalPublications") != null ? request.getAttribute("totalPublications") : "18" %></div>
                        <div class="s">Indexées Scopus & DBLP</div>
                    </div>
                    <div class="stat-card">
                        <div class="k">Évènements à Venir</div>
                        <div class="v"><%= request.getAttribute("totalEvenements") != null ? request.getAttribute("totalEvenements") : "5" %></div>
                        <div class="s">Prochains 6 mois</div>
                    </div>
                    <div class="stat-card">
                        <div class="k">Demandes en Attente</div>
                        <div class="v"><%= request.getAttribute("totalDemandes") != null ? request.getAttribute("totalDemandes") : "4" %></div>
                        <div class="s">À valider</div>
                    </div>
                </div>

                <!-- 2-Column Main Layout Grid -->
                <div style="display: grid; grid-template-columns: 1.5fr 1fr; gap: 24px; align-items: start;">

                    <!-- LEFT COLUMN: Gouvernance & Agenda -->
                    <div style="display: flex; flex-direction: column; gap: 24px;">

                        <!-- Card Mandat en cours -->
                        <div class="card" id="mandats">
                            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 6px;">
                                <div>
                                    <div class="eyebrow" style="margin-bottom: 4px;">GOUVERNANCE · MANDAT EN COURS</div>
                                    <h3 style="font-size: 22px; margin: 0;">Mandat 2024 — 2027</h3>
                                </div>
                                <span class="badge badge-sage">ACTIF · 15 MOIS RESTANTS</span>
                            </div>

                            <div class="mandate-track">
                                <div class="mandate-fill"></div>
                            </div>
                            <div style="display: flex; justify-content: space-between; font-family: var(--font-mono); font-size: 11px; color: var(--muted); margin-bottom: 18px;">
                                <span>sept. 2024</span>
                                <span>58 % écoulé</span>
                                <span>août 2027</span>
                            </div>

                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                                <div class="gov-tile">
                                    <div class="gov-tile-label">DIRECTEUR</div>
                                    <div class="gov-tile-name">Pr. Yassine El Amrani</div>
                                </div>
                                <div class="gov-tile">
                                    <div class="gov-tile-label">VICE-DIRECTRICE</div>
                                    <div class="gov-tile-name">Pr. Fatima-Zahra Alaoui</div>
                                </div>
                                <div class="gov-tile">
                                    <div class="gov-tile-label">CHEF D'ÉQUIPE — IA</div>
                                    <div class="gov-tile-name">Pr. Khalid Tazi</div>
                                </div>
                                <div class="gov-tile">
                                    <div class="gov-tile-label">CHEF D'ÉQUIPE — BD</div>
                                    <div class="gov-tile-name">Pr. Salma Bennani</div>
                                </div>
                                <div class="gov-tile">
                                    <div class="gov-tile-label">CHEF D'ÉQUIPE — NLP</div>
                                    <div class="gov-tile-name">Dr. Omar Lahlou</div>
                                </div>
                                <div class="gov-tile">
                                    <div class="gov-tile-label">CHEF D'ÉQUIPE — SEC</div>
                                    <div class="gov-tile-name">Dr. Fatima Zahra Idrissi</div>
                                </div>
                            </div>
                            <div style="margin-top: 14px; padding-top: 12px; border-top: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; font-size: 12px;">
                                <a href="<%= request.getContextPath() %>/mandats" style="color: var(--accent-2); font-weight: 600; text-decoration: none;">Historique des mandats →</a>
                                <div style="display: flex; gap: 14px;">
                                    <a href="<%= request.getContextPath() %>/conventions" style="color: var(--navy); font-weight: 500; text-decoration: none;">Conventions</a>
                                    <a href="<%= request.getContextPath() %>/pv" style="color: var(--navy); font-weight: 500; text-decoration: none;">Procès-verbaux</a>
                                </div>
                            </div>
                        </div>

                        <!-- Card Agenda Scientifique -->
                        <div class="card" style="padding: 0; overflow: hidden;" id="evenements">
                            <div style="display: flex; justify-content: space-between; align-items: center; padding: 18px 24px; border-bottom: 1px solid var(--border);">
                                <div>
                                    <div class="eyebrow" style="margin-bottom: 2px;">AGENDA SCIENTIFIQUE</div>
                                    <h3 style="font-size: 18px; margin: 0;">Évènements à venir</h3>
                                </div>
                                <span class="badge badge-muted">6 mois</span>
                            </div>
                            <div>
                                <%
                                    List<Evenement> events = (List<Evenement>) request.getAttribute("upcomingEvents");
                                    if (events != null && !events.isEmpty()) {
                                        int i = 0;
                                        for (Evenement ev : events) {
                                            if (++i > 4) break;
                                %>
                                <div style="display: grid; grid-template-columns: 85px 1fr auto; gap: 16px; padding: 14px 24px; border-bottom: 1px solid var(--border); align-items: center;">
                                    <div style="font-family: var(--font-mono); text-align: left;">
                                        <div style="font-size: 13px; font-weight: 600; color: var(--ink);"><%= ev.getDate() != null ? ev.getDate().toString() : "2026-06" %></div>
                                        <div style="font-size: 11px; color: var(--muted);">2026</div>
                                    </div>
                                    <div>
                                        <div style="font-family: var(--font-serif); font-size: 15px; font-weight: 500; color: var(--ink);"><%= ev.getTitre() %></div>
                                        <div style="font-size: 12px; color: var(--muted); margin-top: 2px;">
                                            <%= ev.getType() %> · <%= ev.getLieu() %>
                                        </div>
                                    </div>
                                    <span class="badge badge-navy"><%= ev.getType() %></span>
                                </div>
                                <%
                                        }
                                    } else {
                                %>
                                <div style="display: grid; grid-template-columns: 85px 1fr auto; gap: 16px; padding: 14px 24px; border-bottom: 1px solid var(--border); align-items: center;">
                                    <div style="font-family: var(--font-mono); text-align: left;">
                                        <div style="font-size: 13px; font-weight: 600; color: var(--ink);">14 JUIN</div>
                                        <div style="font-size: 11px; color: var(--muted);">2026</div>
                                    </div>
                                    <div>
                                        <div style="font-family: var(--font-serif); font-size: 15px; font-weight: 500; color: var(--ink);">Federated Learning sur Edge</div>
                                        <div style="font-size: 12px; color: var(--muted); margin-top: 2px;">Séminaire · Salle 12 · Ben M'Sik</div>
                                    </div>
                                    <span class="badge badge-navy">Séminaire</span>
                                </div>
                                <div style="display: grid; grid-template-columns: 85px 1fr auto; gap: 16px; padding: 14px 24px; border-bottom: 1px solid var(--border); align-items: center;">
                                    <div style="font-family: var(--font-mono); text-align: left;">
                                        <div style="font-size: 13px; font-weight: 600; color: var(--ink);">10 JUIL.</div>
                                        <div style="font-size: 11px; color: var(--muted);">2026</div>
                                    </div>
                                    <div>
                                        <div style="font-family: var(--font-serif); font-size: 15px; font-weight: 500; color: var(--ink);">ACL 2026 — Vienne, Autriche</div>
                                        <div style="font-size: 12px; color: var(--muted); margin-top: 2px;">Conférence · Présentation travaux NLP</div>
                                    </div>
                                    <span class="badge badge-navy">Conférence</span>
                                </div>
                                <% } %>
                            </div>
                        </div>

                    </div>

                    <!-- RIGHT COLUMN: Rapport Annuel & Demandes -->
                    <div style="display: flex; flex-direction: column; gap: 24px;">

                        <!-- Card Rapport Annuel avec Circular RingProgress -->
                        <div class="card" id="rapport">
                            <div class="eyebrow" style="margin-bottom: 4px;">RAPPORT ANNUEL · OBLIGATOIRE</div>
                            <h3 style="font-size: 21px; margin: 0 0 16px;">Exercice 2025 — 2026</h3>

                            <!-- SVG Circular Ring Gauge matching Standalone Design -->
                            <div class="ring-progress-wrapper">
                                <svg class="ring-progress-svg" width="100" height="100" viewBox="0 0 100 100">
                                    <circle cx="50" cy="50" r="40" stroke="var(--border)" stroke-width="6" fill="none" />
                                    <circle cx="50" cy="50" r="40" stroke="var(--primary)" stroke-width="6" fill="none"
                                            stroke-dasharray="196 251.3" stroke-dashoffset="-62.8"
                                            transform="rotate(-90 50 50)" stroke-linecap="round" />
                                    <text x="50" y="53" text-anchor="middle" font-family="var(--font-serif)" font-size="24" font-weight="600" fill="var(--primary-deep)">
                                        78<tspan font-size="12" fill="var(--muted)">%</tspan>
                                    </text>
                                </svg>
                                <div class="ring-progress-text">
                                    Données agrégées depuis le 1<sup>er</sup> septembre 2025. Mise à jour automatique chaque nuit.
                                </div>
                            </div>

                            <div style="margin-top: 14px;">
                                <div class="report-line">
                                    <span style="color: var(--ink);">Évènements collectés</span>
                                    <span style="font-family: var(--font-mono); font-size: 12px; color: var(--sage); font-weight: 500;">24/24</span>
                                </div>
                                <div class="report-line">
                                    <span style="color: var(--ink);">Publications validées</span>
                                    <span style="font-family: var(--font-mono); font-size: 12px; color: var(--muted); font-weight: 500;">42/52</span>
                                </div>
                                <div class="report-line">
                                    <span style="color: var(--ink);">Conventions actives</span>
                                    <span style="font-family: var(--font-mono); font-size: 12px; color: var(--sage); font-weight: 500;">7/7</span>
                                </div>
                                <div class="report-line">
                                    <span style="color: var(--ink);">Mandat / gouvernance</span>
                                    <span style="font-family: var(--font-mono); font-size: 12px; color: var(--sage); font-weight: 500;">OK</span>
                                </div>
                                <div class="report-line">
                                    <span style="color: var(--ink);">Approbation directeur</span>
                                    <span style="font-family: var(--font-mono); font-size: 12px; color: var(--warning); font-weight: 500;">à faire</span>
                                </div>
                            </div>

                            <a href="<%= request.getContextPath() %>/rapport" class="btn btn-primary" style="width: 100%; margin-top: 16px; justify-content: center;">
                                Ouvrir le rapport →
                            </a>
                        </div>

                        <!-- Card Demandes d'adhésion -->
                        <div class="card" id="adhesions">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                                <div>
                                    <div class="eyebrow" style="margin-bottom: 2px;">À DÉCIDER</div>
                                    <h3 style="font-size: 18px; margin: 0;">Demandes d'adhésion</h3>
                                </div>
                                <span class="badge badge-gold">4 en attente</span>
                            </div>

                            <div style="display: flex; flex-direction: column; gap: 10px;">
                                <div style="display: flex; align-items: center; gap: 12px; padding: 10px 0; border-top: 1px solid var(--border);">
                                    <div style="width: 32px; height: 32px; background: var(--surface-2); border: 1px solid var(--border); display: flex; align-items: center; justify-content: center; font-family: var(--font-mono); font-size: 11px; font-weight: 600; color: var(--navy); border-radius: 2px;">
                                        SF
                                    </div>
                                    <div style="flex: 1; min-width: 0;">
                                        <div style="font-size: 13px; font-weight: 500; color: var(--ink);">Salma El Fassi</div>
                                        <div style="font-size: 11.5px; color: var(--muted);">Doctorante · FS Ben M'Sik</div>
                                    </div>
                                </div>
                                <div style="display: flex; align-items: center; gap: 12px; padding: 10px 0; border-top: 1px solid var(--border);">
                                    <div style="width: 32px; height: 32px; background: var(--surface-2); border: 1px solid var(--border); display: flex; align-items: center; justify-content: center; font-family: var(--font-mono); font-size: 11px; font-weight: 600; color: var(--navy); border-radius: 2px;">
                                        KT
                                    </div>
                                    <div style="flex: 1; min-width: 0;">
                                        <div style="font-size: 13px; font-weight: 500; color: var(--ink);">Karim Tazi</div>
                                        <div style="font-size: 11.5px; color: var(--muted);">Chercheur associé · ENSIAS</div>
                                    </div>
                                </div>
                            </div>

                            <a href="<%= request.getContextPath() %>/adhesions" class="btn btn-secondary" style="width: 100%; margin-top: 12px; justify-content: center; font-size: 12.5px;">
                                Traiter les demandes
                            </a>
                        </div>

                    </div>

                </div>

            </div>
        </main>
    </div>
</div>

</body>
</html>
