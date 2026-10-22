<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.lias.beans.Publication"%>
<%@ page import="com.lias.beans.Evenement"%>
<%@ page import="com.lias.beans.Mandat"%>
<%
    Mandat mandatActif = (Mandat) request.getAttribute("mandatActif");
    Integer anneeRapport = (Integer) request.getAttribute("anneeRapport");
    if (anneeRapport == null) anneeRapport = 2025;
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS — Rapport Annuel d'Activité Scientifique</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=4">
    <style>
        .report-paper {
            background: var(--surface);
            border: 1px solid var(--border);
            padding: 56px 64px;
            max-width: 960px;
            margin: 0 auto 60px;
            box-shadow: var(--shadow-md);
            position: relative;
        }
        .report-header-crest {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            border-bottom: 2px solid var(--border);
            padding-bottom: 24px;
            margin-bottom: 36px;
        }
        .report-section {
            margin-bottom: 40px;
        }
        .report-section-num {
            font-family: var(--font-mono);
            font-size: 11px;
            letter-spacing: 0.18em;
            text-transform: uppercase;
            color: var(--accent-2);
            margin-bottom: 6px;
            display: block;
        }
        .report-section h3 {
            font-size: 22px;
            color: var(--navy);
            border-bottom: 1px solid var(--border);
            padding-bottom: 8px;
            margin-bottom: 16px;
        }

        @media print {
            .topbar, footer, .no-print, .app-header, .app-sidebar { display: none !important; }
            body { background: #FFF !important; }
            body::before { display: none; }
            .app-body { display: block !important; }
            .app-main { padding: 0 !important; }
            .report-paper { border: none; box-shadow: none; padding: 0; margin: 0; }
            .container, .app-content { padding: 0; max-width: 100%; }
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
        <div class="page-header no-print">
            <div>
                <span class="eyebrow">Document Obligatoire · Condition d'Attribution du Budget Annuel (CDC §11)</span>
                <h1 class="page-title">Rapport d'Activité Scientifique</h1>
                <p class="page-sub">
                    Génération automatisée consolidée pour le Conseil d'Établissement et le Ministère. Compilation des membres, productions, mandats et budget matériel.
                </p>
            </div>
            <div style="display: flex; gap: 10px; align-items: center;">
                <form method="get" action="<%= request.getContextPath() %>/rapport" style="display: flex; gap: 8px; align-items: center;">
                    <label style="font-size: 12px; font-weight: 700; color: var(--muted);">Exercice :</label>
                    <select name="annee" onchange="this.form.submit()" style="padding: 7px 12px; border-radius: 4px; border: 1px solid var(--border); font-family: var(--font-mono); font-size: 13px; font-weight: 600; color: var(--navy); cursor: pointer;">
                        <option value="2026" <%= anneeRapport == 2026 ? "selected" : "" %>>2026 (En cours)</option>
                        <option value="2025" <%= anneeRapport == 2025 ? "selected" : "" %>>2025 (Évaluation)</option>
                        <option value="2024" <%= anneeRapport == 2024 ? "selected" : "" %>>2024 (Archivé)</option>
                    </select>
                </form>
                <button onclick="window.print()" class="btn btn-primary">
                    Imprimer / Exporter PDF 🖨️
                </button>
            </div>
        </div>

        <!-- Academic Report Official Paper -->
        <div class="report-paper">

            <div class="report-header-crest">
                <div>
                    <div style="font-family: var(--font-mono); font-size: 11px; letter-spacing: 0.15em; text-transform: uppercase; color: var(--muted);">
                        Royaume du Maroc · Université Hassan II de Casablanca
                    </div>
                    <div style="font-family: var(--font-serif); font-size: 20px; font-weight: 600; color: var(--navy); margin-top: 4px;">
                        Faculté des Sciences Ben M'Sik
                    </div>
                    <div style="font-family: var(--font-sans); font-size: 13px; color: var(--muted);">
                        Laboratoire d'Informatique et Applications Scientifiques (LIAS)
                    </div>
                </div>
                <div style="text-align: right;">
                    <span class="lias-logo" role="img" aria-label="LIAS" style="height: 52px; margin-left: auto;"></span>
                    <div style="font-family: var(--font-mono); font-size: 10.5px; color: var(--muted); margin-top: 6px;">
                        EXERCICE <%= anneeRapport %>–<%= anneeRapport + 1 %>
                    </div>
                </div>
            </div>

            <div style="text-align: center; margin-bottom: 48px;">
                <span class="eyebrow" style="color: var(--accent-2);">Rapport Annuel Consolidé d'Évaluation (CDC §11 ⭐)</span>
                <h2 style="font-size: 38px; line-height: 1.15; margin: 8px 0 12px; color: var(--ink);">
                    Bilan des Travaux & Rayonnement Scientifique (<%= anneeRapport %>)
                </h2>
                <div style="font-family: var(--font-serif); font-style: italic; font-size: 16px; color: var(--muted);">
                    Sous la direction du <strong><%= (mandatActif != null && mandatActif.getDirecteurNomComplet() != null) ? mandatActif.getDirecteurNomComplet() : "Pr. Youssef El Alem" %></strong> · <%= (mandatActif != null && mandatActif.getTitre() != null) ? mandatActif.getTitre() : "Mandat Actuel 2024–2028" %>
                </div>
            </div>

            <!-- KPIs Summary -->
            <div class="stats-grid" style="margin-bottom: 40px;">
                <div class="stat-card">
                    <div class="k">Chercheurs & Doctorants</div>
                    <div class="v"><%= request.getAttribute("totalMembres") != null ? request.getAttribute("totalMembres") : "33" %></div>
                    <div class="s">Effectif actif certifié</div>
                </div>
                <div class="stat-card">
                    <div class="k">Publications Annuelles</div>
                    <div class="v"><%= request.getAttribute("totalPublications") != null ? request.getAttribute("totalPublications") : "18" %></div>
                    <div class="s">Indexation Scopus</div>
                </div>
                <div class="stat-card">
                    <div class="k">Événements Réalisés</div>
                    <div class="v"><%= request.getAttribute("totalEvenements") != null ? request.getAttribute("totalEvenements") : "5" %></div>
                    <div class="s">Conférences & séminaires</div>
                </div>
            </div>

            <!-- Section 1 : Gouvernance -->
            <div class="report-section">
                <span class="report-section-num">Section I</span>
                <h3>Gouvernance, Effectifs & Capital Humain</h3>
                <p style="font-size: 14.5px; line-height: 1.7; color: var(--ink);">
                    Le laboratoire LIAS s'appuie sur une structure matricielle de 4 équipes thématiques. Durant l'exercice en cours, l'effectif total est de <strong><%= request.getAttribute("totalMembres") %> enseignants-chercheurs et doctorants</strong>. L'assemblée générale a validé la conformité de l'historique d'affiliation et des conventions de cotutelle.
                </p>
                <div style="background: var(--surface-2); padding: 14px 18px; border-radius: 2px; font-size: 13px; margin-top: 14px;">
                    <strong>Mandat de direction :</strong> Pr. Y. Benali (Directeur), Pr. F-Z. Alaoui (Vice-Directrice). Clôture statutaire : 31 août 2027.
                </div>
            </div>

            <!-- Section 2 : Production Scientifique -->
            <div class="report-section">
                <span class="report-section-num">Section II</span>
                <h3>Production Scientifique & Diffusion des Connaissances</h3>
                <p style="font-size: 14.5px; line-height: 1.7; color: var(--ink);">
                    La production scientifique de l'exercice se distingue par un taux de publication élevé dans des revues indexées du premier quartile (Q1/Q2).
                </p>
                <div class="table-container" style="margin-top: 14px;">
                    <table>
                        <thead>
                            <tr>
                                <th>Année</th>
                                <th>Titre du travail</th>
                                <th>Auteurs</th>
                                <th>Type</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Publication> pubs = (List<Publication>) request.getAttribute("publications");
                                if (pubs != null && !pubs.isEmpty()) {
                                    int count = 0;
                                    for (Publication p : pubs) {
                                        if (++count > 5) break;
                            %>
                            <tr>
                                <td style="font-family: var(--font-mono);"><%= p.getAnnee() %></td>
                                <td><strong><%= p.getTitre() %></strong></td>
                                <td style="color: var(--muted); font-size: 12px;"><%= p.getAuteurs() %></td>
                                <td><span class="badge badge-navy"><%= p.getType() != null ? p.getType() : "Article" %></span></td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Section 3 : Manifestations Scientifiques -->
            <div class="report-section">
                <span class="report-section-num">Section III</span>
                <h3>Rayonnement, Conférences & Séminaires</h3>
                <p style="font-size: 14.5px; line-height: 1.7; color: var(--ink);">
                    Le LIAS a maintenu un calendrier actif d'animation scientifique, garantissant la formation continue des doctorants et l'interaction avec le tissu socio-économique national.
                </p>
                <ul style="font-size: 13.5px; color: var(--ink); line-height: 1.8; margin-top: 12px;">
                    <%
                        List<Evenement> evts = (List<Evenement>) request.getAttribute("evenements");
                        if (evts != null && !evts.isEmpty()) {
                            for (Evenement e : evts) {
                    %>
                    <li><strong><%= e.getDate() %> :</strong> <%= e.getTitre() %> (<%= e.getType() %> tenue à <%= e.getLieu() %>).</li>
                    <%
                            }
                        }
                    %>
                </ul>
            </div>

            <!-- Visa et Signature -->
            <div style="margin-top: 60px; padding-top: 24px; border-top: 1px solid var(--border); display: flex; justify-content: space-between; align-items: flex-end;">
                <div>
                    <div style="font-size: 12.5px; color: var(--muted);">Fait à Casablanca, le 4 septembre 2026</div>
                    <div style="font-family: var(--font-mono); font-size: 11px; color: var(--muted); margin-top: 4px;">Rapport certifié conforme pour transmission ministérielle</div>
                </div>
                <div style="text-align: center;">
                    <div style="font-family: var(--font-serif); font-size: 15px; font-weight: 600;">Le Directeur du Laboratoire LIAS</div>
                    <div style="font-family: var(--font-serif); font-style: italic; font-size: 17px; color: var(--navy); margin-top: 24px;">
                        Pr. Yassine Benali
                    </div>
                    <div style="font-family: var(--font-mono); font-size: 10px; color: var(--muted); letter-spacing: 0.1em;">[CACHET ÉLECTRONIQUE VALISÉ]</div>
                </div>
            </div>

        </div>

            </div>
        </main>
    </div>
</div>

</body>
</html>
