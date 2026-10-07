<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.lias.beans.Publication"%>
<%@ page import="com.lias.beans.Evenement"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS — Laboratoire d'Informatique et Applications Scientifiques</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .hero-public {
            padding: 96px 40px 80px;
            max-width: 1280px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 1.4fr 1fr;
            gap: 80px;
            align-items: end;
        }
        .hero-public .eyebrow {
            font-family: var(--font-mono);
            font-size: 11px;
            letter-spacing: 0.2em;
            text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 24px;
        }
        .hero-public h1 {
            font-family: var(--font-serif);
            font-size: 84px;
            font-weight: 500;
            line-height: 0.98;
            margin: 0;
            letter-spacing: -0.02em;
        }
        .hero-public h1 em {
            font-style: italic;
            color: var(--accent-2);
        }
        .hero-public .sub {
            font-family: var(--font-serif);
            font-style: italic;
            font-size: 21px;
            color: var(--muted);
            margin: 32px 0 0;
            line-height: 1.5;
            max-width: 580px;
        }
        .hero-side {
            padding: 32px;
            border: 1px solid var(--border);
            background: var(--surface);
            font-family: var(--font-serif);
            font-size: 17px;
            color: var(--ink);
            line-height: 1.6;
            box-shadow: var(--shadow-sm);
        }
        .hero-side .quote-mark {
            font-family: var(--font-serif);
            font-size: 56px;
            color: var(--accent-2);
            line-height: 0.8;
            display: block;
            margin-bottom: 10px;
        }
        .hero-side .attribution {
            margin-top: 18px;
            padding-top: 14px;
            border-top: 1px solid var(--border);
            font-family: var(--font-mono);
            font-size: 11px;
            color: var(--muted);
            letter-spacing: 0.1em;
            text-transform: uppercase;
        }

        .stats-strip {
            border-top: 1px solid var(--border);
            border-bottom: 1px solid var(--border);
            background: var(--surface);
        }
        .stats-grid-public {
            max-width: 1280px;
            margin: 0 auto;
            padding: 0 40px;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
        }
        .stat-item {
            padding: 36px 28px;
            border-right: 1px solid var(--border);
        }
        .stat-item:last-child {
            border-right: none;
        }
        .stat-item .k {
            font-family: var(--font-mono);
            font-size: 11px;
            letter-spacing: 0.18em;
            text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 10px;
        }
        .stat-item .v {
            font-family: var(--font-serif);
            font-size: 52px;
            font-weight: 500;
            color: var(--ink);
            line-height: 1;
            font-variant-numeric: tabular-nums;
            letter-spacing: -0.02em;
        }
        .stat-item .s {
            font-family: var(--font-sans);
            font-size: 12.5px;
            color: var(--muted);
            margin-top: 8px;
        }

        .section-public {
            padding: 80px 40px;
            max-width: 1280px;
            margin: 0 auto;
        }
        .section-head {
            margin-bottom: 44px;
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            gap: 40px;
        }
        .section-eyebrow {
            font-family: var(--font-mono);
            font-size: 11px;
            letter-spacing: 0.2em;
            text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 12px;
        }
        .section-title {
            font-family: var(--font-serif);
            font-size: 48px;
            font-weight: 500;
            line-height: 1.05;
            margin: 0;
            letter-spacing: -0.015em;
        }

        .teams-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1px;
            background: var(--border);
            border: 1px solid var(--border);
        }
        .team-card {
            background: var(--surface);
            padding: 36px 32px;
            display: flex;
            flex-direction: column;
            gap: 14px;
            transition: background 0.15s;
        }
        .team-card:hover {
            background: var(--surface-2);
        }
        .team-card .badge {
            align-self: flex-start;
            padding: 4px 10px;
            border: 1px solid var(--border);
            background: var(--bg);
            font-family: var(--font-mono);
            font-size: 10.5px;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--muted);
        }
        .team-card h3 {
            font-family: var(--font-serif);
            font-size: 26px;
            font-weight: 500;
            margin: 0;
        }
        .team-card p {
            font-family: var(--font-serif);
            font-size: 15px;
            color: var(--muted);
            line-height: 1.6;
            margin: 0;
        }
        .team-card .team-footer {
            margin-top: auto;
            padding-top: 14px;
            border-top: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: baseline;
            font-family: var(--font-sans);
            font-size: 13px;
        }

        .cta-box {
            background: var(--navy);
            color: var(--cream);
            padding: 72px 40px;
            max-width: 1280px;
            margin: 40px auto 80px;
            display: grid;
            grid-template-columns: 1fr 1.2fr;
            gap: 60px;
            align-items: center;
        }
        .cta-box h2 {
            font-family: var(--font-serif);
            font-size: 42px;
            color: var(--cream);
            margin: 12px 0 0;
            line-height: 1.15;
        }
        .cta-box p {
            font-family: var(--font-serif);
            font-size: 17px;
            color: rgba(244, 239, 230, 0.8);
            line-height: 1.6;
            margin: 0 0 28px;
        }
        .cta-buttons {
            display: flex;
            gap: 16px;
        }
        .cta-btn-primary {
            padding: 12px 24px;
            background: var(--accent-2);
            color: #1A1814;
            font-weight: 600;
            border-radius: 2px;
            text-decoration: none !important;
        }
        .cta-btn-ghost {
            padding: 12px 24px;
            border: 1px solid rgba(244, 239, 230, 0.4);
            color: var(--cream);
            border-radius: 2px;
            text-decoration: none !important;
        }

        .partners-grid {
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 16px;
            margin-top: 24px;
        }
        .partner-item {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 6px;
            padding: 20px 12px 16px;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: space-between;
            min-height: 154px;
            transition: all 0.2s ease;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.03);
        }
        .partner-item:hover {
            transform: translateY(-3px);
            border-color: var(--primary);
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.09);
        }
        .partner-logo-box {
            height: 60px;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 12px;
            background: #FFFFFF;
            border-radius: 4px;
            padding: 6px;
        }
        .partner-img {
            max-height: 48px;
            max-width: 100%;
            object-fit: contain;
            transition: transform 0.2s ease;
        }
        .partner-item:hover .partner-img {
            transform: scale(1.08);
        }
        .partner-name {
            font-family: var(--font-serif);
            font-size: 14.5px;
            font-weight: 600;
            color: var(--ink);
            line-height: 1.25;
            margin-bottom: 4px;
        }
        .partner-sub {
            font-family: var(--font-mono);
            font-size: 10px;
            color: var(--muted);
            letter-spacing: 0.02em;
        }

        .events-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
        }
        .event-card {
            background: var(--surface);
            border: 1px solid var(--border);
            padding: 28px 24px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: var(--shadow-sm);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .event-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
        }

        @media (max-width: 900px) {
            .hero-public { grid-template-columns: 1fr; gap: 40px; padding: 48px 20px; }
            .hero-public h1 { font-size: 52px; }
            .stats-grid-public { grid-template-columns: 1fr 1fr; }
            .teams-grid { grid-template-columns: 1fr; }
            .events-grid { grid-template-columns: 1fr; }
            .cta-box { grid-template-columns: 1fr; gap: 30px; padding: 40px 20px; }
            .partners-grid { grid-template-columns: repeat(3, 1fr); }
        }
    </style>
</head>
<body>

    <!-- Shared Topbar -->
    <%@ include file="includes/navbar.jsp" %>

    <!-- Hero Section -->
    <section class="hero-public" id="top">
        <div>
            <div class="eyebrow">Laboratoire d'Informatique et Applications Scientifiques · FSBM Casablanca</div>
            <h1>Recherche <em>fondamentale</em> et appliquée en informatique.</h1>
            <p class="sub">
                Une institution scientifique d'excellence dédiée à la production de connaissances, à la formation doctorale et à l'impact sociétal à travers la science des données, l'intelligence artificielle et les systèmes distribués.
            </p>
        </div>
        <div class="hero-side">
            <span class="quote-mark">«</span>
            Le laboratoire n'est pas qu'un espace physique : c'est la mémoire vivante de nos travaux, la continuité des mandats de direction et l'engagement commun pour la science.
            <div class="attribution">Pr. Y. Benali — Directeur du LIAS</div>
        </div>
    </section>

    <!-- Stats Strip -->
    <div class="stats-strip">
        <div class="stats-grid-public">
            <div class="stat-item">
                <div class="k">Communauté Scientifique</div>
                <div class="v"><%= request.getAttribute("totalMembres") != null ? request.getAttribute("totalMembres") : "38" %></div>
                <div class="s">Chercheurs, enseignants & doctorants</div>
            </div>
            <div class="stat-item">
                <div class="k">Production Scientifique</div>
                <div class="v"><%= request.getAttribute("totalPublications") != null ? request.getAttribute("totalPublications") : "280+" %></div>
                <div class="s">Articles, revues & brevets indexés</div>
            </div>
            <div class="stat-item">
                <div class="k">Conventions & Partenariats</div>
                <div class="v">14</div>
                <div class="s">Accords nationaux & internationaux</div>
            </div>
            <div class="stat-item">
                <div class="k">Histoire Académique</div>
                <div class="v">23 ans</div>
                <div class="s">Fondé en 2003 · FSBM</div>
            </div>
        </div>
    </div>

    <!-- Équipes de Recherche -->
    <section class="section-public" id="equipes">
        <div class="section-head">
            <div>
                <div class="section-eyebrow">Structure Scientifique</div>
                <h2 class="section-title">Quatre équipes de recherche d'excellence</h2>
            </div>
            <a href="<%= request.getContextPath() %>/profils" class="btn-section-cta">Consulter l'annuaire complet <span class="arrow">→</span></a>
        </div>

        <div class="teams-grid">
            <div class="team-card">
                <span class="badge">Équipe 1</span>
                <h3>Science des Données & Big Data</h3>
                <p>Modélisation prédictive, traitement de flux massifs, architecture lac de données et fouille de données complexes appliquées à la santé et au transport.</p>
                <div class="team-footer">
                    <span>Responsable : <strong>Pr. A. Alami</strong></span>
                    <span style="font-family: var(--font-mono); color: var(--muted);">11 chercheurs</span>
                </div>
            </div>
            <div class="team-card">
                <span class="badge">Équipe 2</span>
                <h3>Intelligence Artificielle & Vision</h3>
                <p>Apprentissage profond, vision par ordinateur, traitement automatique du langage naturel (NLP) et systèmes d'aide à la décision.</p>
                <div class="team-footer">
                    <span>Responsable : <strong>Pr. F. Zahra</strong></span>
                    <span style="font-family: var(--font-mono); color: var(--muted);">9 chercheurs</span>
                </div>
            </div>
            <div class="team-card">
                <span class="badge">Équipe 3</span>
                <h3>Systèmes Distribués & Cloud</h3>
                <p>Infrastructures cloud hybrides, micro-services, consensus décentralisé et calcul haute performance (HPC) pour l'analyse scientifique.</p>
                <div class="team-footer">
                    <span>Responsable : <strong>Pr. M. Idrissi</strong></span>
                    <span style="font-family: var(--font-mono); color: var(--muted);">10 chercheurs</span>
                </div>
            </div>
            <div class="team-card">
                <span class="badge">Équipe 4</span>
                <h3>Cybersécurité & Réseaux</h3>
                <p>Sécurité des systèmes IoT, cryptographie appliquée, résilience des infrastructures critiques et conformité de la confidentialité des données.</p>
                <div class="team-footer">
                    <span>Responsable : <strong>Pr. K. Tazi</strong></span>
                    <span style="font-family: var(--font-mono); color: var(--muted);">8 chercheurs</span>
                </div>
            </div>
        </div>
    </section>

    <!-- Publications Récentes (Dynamic JEE) -->
    <section class="section-public" id="publications" style="padding-top: 0;">
        <div class="section-head">
            <div>
                <div class="section-eyebrow">Diffusion Scientifique</div>
                <h2 class="section-title">Dernières publications</h2>
            </div>
            <a href="<%= request.getContextPath() %>/publications" class="btn-section-cta">Toutes les publications <span class="arrow">→</span></a>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th style="width: 80px;">Année</th>
                        <th>Titre du travail scientifique</th>
                        <th>Auteurs & Laboratoire</th>
                        <th>Revue / Conférence</th>
                        <th>Indexation</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Publication> pubs = (List<Publication>) request.getAttribute("recentPublications");
                        if (pubs != null && !pubs.isEmpty()) {
                            int count = 0;
                            for (Publication p : pubs) {
                                if (++count > 5) break;
                    %>
                    <tr>
                        <td style="font-family: var(--font-serif); font-size: 17px; font-weight: 600;"><%= p.getAnnee() %></td>
                        <td style="font-family: var(--font-serif); font-size: 15.5px; font-weight: 500; color: var(--ink);">
                            <%= p.getTitre() %>
                            <% if (p.getDoi() != null && !p.getDoi().isEmpty()) { %>
                                <div style="font-family: var(--font-mono); font-size: 11px; color: var(--muted); margin-top: 3px;">DOI: <%= p.getDoi() %></div>
                            <% } %>
                        </td>
                        <td style="color: var(--muted);"><%= p.getAuteurs() %></td>
                        <td><em><%= p.getRevue() %></em></td>
                        <td><span class="badge badge-navy"><%= p.getType() != null ? p.getType() : "Article" %></span></td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td style="font-family: var(--font-serif); font-size: 17px; font-weight: 600;">2025</td>
                        <td style="font-family: var(--font-serif); font-size: 15.5px; font-weight: 500;">
                            A Deep Learning Approach for Real-Time Anomaly Detection in High-Velocity Data Streams
                        </td>
                        <td style="color: var(--muted);">Y. Benali, S. Chraibi, A. Alami</td>
                        <td><em>IEEE Transactions on Knowledge and Data Engineering</em></td>
                        <td><span class="badge badge-navy">Revue Q1</span></td>
                    </tr>
                    <tr>
                        <td style="font-family: var(--font-serif); font-size: 17px; font-weight: 600;">2024</td>
                        <td style="font-family: var(--font-serif); font-size: 15.5px; font-weight: 500;">
                            Privacy-Preserving Federated Learning for Distributed Scientific Datasets
                        </td>
                        <td style="color: var(--muted);">M. Idrissi, F. Zahra</td>
                        <td><em>ACM Computing Surveys</em></td>
                        <td><span class="badge badge-navy">Article</span></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </section>

    <!-- Événements & Séminaires -->
    <section class="section-public" id="evenements" style="padding-top: 0;">
        <div class="section-head">
            <div>
                <div class="section-eyebrow">Agenda Scientifique</div>
                <h2 class="section-title">Événements & Séminaires</h2>
            </div>
            <a href="<%= request.getContextPath() %>/evenements" class="btn-section-cta">Tous les événements <span class="arrow">→</span></a>
        </div>

        <div class="events-grid">
            <%
                List<Evenement> evts = (List<Evenement>) request.getAttribute("upcomingEvents");
                if (evts != null && !evts.isEmpty()) {
                    int eCount = 0;
                    for (Evenement evt : evts) {
                        if (++eCount > 3) break;
            %>
            <div class="event-card">
                <div>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
                        <span class="badge badge-navy"><%= evt.getType() != null ? evt.getType() : "Séminaire" %></span>
                        <span style="font-family: var(--font-mono); font-size: 11px; color: var(--muted);"><%= evt.getDate() != null ? evt.getDate() : "" %></span>
                    </div>
                    <h3 style="font-family: var(--font-serif); font-size: 20px; font-weight: 500; margin: 0 0 10px; line-height: 1.3;"><%= evt.getTitre() %></h3>
                    <p style="font-family: var(--font-serif); font-size: 14px; color: var(--muted); line-height: 1.5; margin: 0 0 16px;">
                        <%= evt.getDescription() != null && evt.getDescription().length() > 110 ? evt.getDescription().substring(0, 107) + "..." : (evt.getDescription() != null ? evt.getDescription() : "") %>
                    </p>
                </div>
                <div style="padding-top: 14px; border-top: 1px solid var(--border); font-family: var(--font-sans); font-size: 12.5px; color: var(--ink); display: flex; justify-content: space-between; align-items: center;">
                    <span>📍 <%= evt.getLieu() != null ? evt.getLieu() : "FSBM Casablanca" %></span>
                    <span style="font-family: var(--font-mono); font-size: 11px; color: var(--accent-2); font-weight: 600;"><%= evt.getStatut() != null ? evt.getStatut() : "À venir" %></span>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div class="event-card">
                <div>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
                        <span class="badge badge-navy">Workshop</span>
                        <span style="font-family: var(--font-mono); font-size: 11px; color: var(--muted);">2026-04-15</span>
                    </div>
                    <h3 style="font-family: var(--font-serif); font-size: 20px; font-weight: 500; margin: 0 0 10px; line-height: 1.3;">Journée Doctorale IA & Big Data</h3>
                    <p style="font-family: var(--font-serif); font-size: 14px; color: var(--muted); line-height: 1.5; margin: 0 0 16px;">
                        Présentation des avancées des thèses de doctorat et échanges avec les chercheurs associés.
                    </p>
                </div>
                <div style="padding-top: 14px; border-top: 1px solid var(--border); font-family: var(--font-sans); font-size: 12.5px; color: var(--ink); display: flex; justify-content: space-between; align-items: center;">
                    <span>📍 Amphithéâtre Al-Khawarizmi</span>
                    <span style="font-family: var(--font-mono); font-size: 11px; color: var(--accent-2); font-weight: 600;">À venir</span>
                </div>
            </div>
            <div class="event-card">
                <div>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
                        <span class="badge badge-navy">Séminaire</span>
                        <span style="font-family: var(--font-mono); font-size: 11px; color: var(--muted);">2026-05-10</span>
                    </div>
                    <h3 style="font-family: var(--font-serif); font-size: 20px; font-weight: 500; margin: 0 0 10px; line-height: 1.3;">Calcul Haute Performance & Clouds</h3>
                    <p style="font-family: var(--font-serif); font-size: 14px; color: var(--muted); line-height: 1.5; margin: 0 0 16px;">
                        Conférence invitée avec des experts du CNRS sur les architectures distribuées résilientes.
                    </p>
                </div>
                <div style="padding-top: 14px; border-top: 1px solid var(--border); font-family: var(--font-sans); font-size: 12.5px; color: var(--ink); display: flex; justify-content: space-between; align-items: center;">
                    <span>📍 Salle des Séminaires LIAS</span>
                    <span style="font-family: var(--font-mono); font-size: 11px; color: var(--accent-2); font-weight: 600;">À venir</span>
                </div>
            </div>
            <div class="event-card">
                <div>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
                        <span class="badge badge-navy">Soutenance</span>
                        <span style="font-family: var(--font-mono); font-size: 11px; color: var(--muted);">2026-06-20</span>
                    </div>
                    <h3 style="font-family: var(--font-serif); font-size: 20px; font-weight: 500; margin: 0 0 10px; line-height: 1.3;">Soutenance de Thèse de Doctorat</h3>
                    <p style="font-family: var(--font-serif); font-size: 14px; color: var(--muted); line-height: 1.5; margin: 0 0 16px;">
                        Thèse intitulée « Privacy-Preserving Federated Learning » présentée par Y. Amrani.
                    </p>
                </div>
                <div style="padding-top: 14px; border-top: 1px solid var(--border); font-family: var(--font-sans); font-size: 12.5px; color: var(--ink); display: flex; justify-content: space-between; align-items: center;">
                    <span>📍 Salle des Thèses, FSBM</span>
                    <span style="font-family: var(--font-mono); font-size: 11px; color: var(--accent-2); font-weight: 600;">À venir</span>
                </div>
            </div>
            <% } %>
        </div>
    </section>

    <!-- Partenaires -->
    <section class="section-public" style="padding-top: 0;">
        <div class="section-eyebrow">Réseau & Collaborations</div>
        <h2 class="section-title" style="font-size: 34px; margin-bottom: 10px;">Partenaires académiques et industriels</h2>
        <p style="font-family: var(--font-serif); font-size: 16px; color: var(--muted); margin: 0 0 24px; max-width: 820px; line-height: 1.5;">
            Conventions de recherche bilatérales, mobilités doctorales et programmes d'innovation appliquée noués avec les leaders industriels et académiques de référence.
        </p>
        <div class="partners-grid">
            <div class="partner-item">
                <div class="partner-logo-box">
                    <img src="<%= request.getContextPath() %>/images/partners/casa_transport.png" alt="Casa Transports" class="partner-img">
                </div>
                <div class="partner-name">Casa Transports</div>
                <div class="partner-sub">Partenaire Industriel</div>
            </div>
            <div class="partner-item">
                <div class="partner-logo-box">
                    <img src="<%= request.getContextPath() %>/images/partners/inria.svg" alt="INRIA Paris" class="partner-img">
                </div>
                <div class="partner-name">INRIA Paris</div>
                <div class="partner-sub">Centre de Recherche</div>
            </div>
            <div class="partner-item">
                <div class="partner-logo-box">
                    <img src="<%= request.getContextPath() %>/images/partners/um5.png" alt="Univ. Mohammed V" class="partner-img">
                </div>
                <div class="partner-name">Univ. Mohammed V</div>
                <div class="partner-sub">Partenaire Académique</div>
            </div>
            <div class="partner-item">
                <div class="partner-logo-box">
                    <img src="<%= request.getContextPath() %>/images/partners/cnrs.svg" alt="CNRS - LIPN" class="partner-img">
                </div>
                <div class="partner-name">CNRS — LIPN</div>
                <div class="partner-sub">Coopération France</div>
            </div>
            <div class="partner-item">
                <div class="partner-logo-box">
                    <img src="<%= request.getContextPath() %>/images/partners/ensias.png" alt="ENSIAS Rabat" class="partner-img">
                </div>
                <div class="partner-name">ENSIAS Rabat</div>
                <div class="partner-sub">Cotutelles & Projets</div>
            </div>
            <div class="partner-item">
                <div class="partner-logo-box">
                    <img src="<%= request.getContextPath() %>/images/partners/ocp.svg" alt="OCP Innovation" class="partner-img">
                </div>
                <div class="partner-name">OCP Innovation</div>
                <div class="partner-sub">R&D Industrielle</div>
            </div>
        </div>
    </section>

    <!-- CTA Collaborer -->
    <section class="cta-box" id="rejoindre">
        <div>
            <div class="eyebrow" style="color: rgba(255,255,255,0.7);">Rejoignez le laboratoire</div>
            <h2>Vous souhaitez collaborer avec le LIAS ?</h2>
        </div>
        <div>
            <p>Doctorants, chercheurs associés, partenaires industriels — chaque demande d'adhésion est examinée rigoureusement par la direction du laboratoire en mandat.</p>
            <div class="cta-buttons">
                <a href="<%= request.getContextPath() %>/adhesions" class="cta-btn-primary">Déposer une candidature →</a>
                <a href="mailto:contact@lias.ma" class="cta-btn-ghost">contact@lias.ma</a>
            </div>
        </div>
    </section>

    <!-- Shared Footer -->
    <%@ include file="includes/footer.jsp" %>

    <!-- Active Anchor Scroll Spy -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var navMap = {
                'top': document.getElementById('nav-top'),
                'equipes': document.getElementById('nav-equipes'),
                'publications': document.getElementById('nav-publications'),
                'evenements': document.getElementById('nav-evenements'),
                'rejoindre': document.getElementById('nav-rejoindre')
            };

            var sections = ['top', 'equipes', 'publications', 'evenements', 'rejoindre']
                .map(function(id) { return document.getElementById(id); })
                .filter(Boolean);

            if ('IntersectionObserver' in window && sections.length > 0) {
                var observer = new IntersectionObserver(function(entries) {
                    entries.forEach(function(entry) {
                        if (entry.isIntersecting) {
                            var id = entry.target.id;
                            Object.keys(navMap).forEach(function(k) {
                                if (navMap[k]) navMap[k].classList.remove('active');
                            });
                            if (navMap[id]) navMap[id].classList.add('active');
                        }
                    });
                }, {
                    rootMargin: '-20% 0px -65% 0px',
                    threshold: 0.05
                });

                sections.forEach(function(sec) { observer.observe(sec); });
            }
        });
    </script>

</body>
</html>
