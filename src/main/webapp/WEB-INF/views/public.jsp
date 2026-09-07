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
            gap: 1px;
            background: var(--border);
            border: 1px solid var(--border);
            margin-top: 24px;
        }
        .partner-item {
            background: var(--surface);
            padding: 24px 16px;
            text-align: center;
        }
        .partner-mark {
            font-family: var(--font-serif);
            font-size: 24px;
            font-weight: 600;
            color: var(--navy);
            margin-bottom: 6px;
        }
        .partner-name {
            font-family: var(--font-sans);
            font-size: 12px;
            font-weight: 500;
            color: var(--ink);
        }

        @media (max-width: 900px) {
            .hero-public { grid-template-columns: 1fr; gap: 40px; padding: 48px 20px; }
            .hero-public h1 { font-size: 52px; }
            .stats-grid-public { grid-template-columns: 1fr 1fr; }
            .teams-grid { grid-template-columns: 1fr; }
            .cta-box { grid-template-columns: 1fr; gap: 30px; padding: 40px 20px; }
            .partners-grid { grid-template-columns: repeat(3, 1fr); }
        }
    </style>
</head>
<body>

    <!-- Shared Topbar -->
    <%@ include file="includes/navbar.jsp" %>

    <!-- Hero Section -->
    <section class="hero-public">
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
            <a href="<%= request.getContextPath() %>/profils" class="btn btn-secondary">Consulter l'annuaire complet →</a>
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
            <a href="<%= request.getContextPath() %>/publications" class="btn btn-secondary">Toutes les publications →</a>
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

    <!-- Partenaires -->
    <section class="section-public" style="padding-top: 0;">
        <div class="section-eyebrow">Réseau & Collaborations</div>
        <h2 class="section-title" style="font-size: 34px; margin-bottom: 24px;">Partenaires académiques et industriels</h2>
        <div class="partners-grid">
            <div class="partner-item"><div class="partner-mark">CT</div><div class="partner-name">Casa Transports</div></div>
            <div class="partner-item"><div class="partner-mark">IN</div><div class="partner-name">INRIA Paris</div></div>
            <div class="partner-item"><div class="partner-mark">UM</div><div class="partner-name">Univ. Mohammed V</div></div>
            <div class="partner-item"><div class="partner-mark">LP</div><div class="partner-name">CNRS-LIPN</div></div>
            <div class="partner-item"><div class="partner-mark">EN</div><div class="partner-name">ENSIAS Rabat</div></div>
            <div class="partner-item"><div class="partner-mark">OC</div><div class="partner-name">OCP Innovation</div></div>
        </div>
    </section>

    <!-- CTA Collaborer -->
    <section class="cta-box">
        <div>
            <div class="eyebrow" style="color: rgba(244,239,230,0.6);">Rejoignez le laboratoire</div>
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

</body>
</html>
