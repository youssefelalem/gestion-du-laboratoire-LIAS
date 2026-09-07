<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.lias.beans.Publication"%>
<%@ page import="com.lias.beans.User"%>
<%
    List<Publication> pubs = (List<Publication>) request.getAttribute("publications");
    String selectedYear = (String) request.getAttribute("selectedYear");
    String selectedTeam = (String) request.getAttribute("selectedTeam");
    User currentUser = (User) session.getAttribute("currentUser");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS — Publications Scientifiques</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=2">
    <style>
        .filter-grid {
            display: grid;
            grid-template-columns: 1.5fr 1fr 1fr auto;
            gap: 12px;
            align-items: flex-end;
        }
        .add-form-card {
            display: none;
            background: var(--surface);
            border: 1px solid var(--border);
            padding: 28px;
            margin-bottom: 28px;
            border-left: 4px solid var(--navy);
        }
        .pub-row {
            display: grid;
            grid-template-columns: 80px 1fr 120px;
            gap: 20px;
            padding: 20px 24px;
            border-bottom: 1px solid var(--border);
            align-items: baseline;
            transition: background 0.15s;
        }
        .pub-row:hover {
            background: rgba(237, 229, 211, 0.25);
        }
        .pub-year {
            font-family: var(--font-serif);
            font-size: 24px;
            font-weight: 600;
            color: var(--ink);
            font-variant-numeric: tabular-nums;
        }
        .pub-title {
            font-family: var(--font-serif);
            font-size: 17px;
            font-weight: 500;
            color: var(--ink);
            margin: 0 0 6px;
            line-height: 1.35;
        }
        .pub-authors {
            font-size: 13px;
            color: var(--muted);
        }
        .pub-venue {
            font-style: italic;
            color: var(--navy);
            font-size: 13px;
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
                <span class="eyebrow"><%= pubs != null ? pubs.size() : "0" %> publications indexées · revues & conférences</span>
                <h1 class="page-title">Publications Scientifiques</h1>
                <p class="page-sub">
                    Catalogue des productions académiques du laboratoire LIAS. Tout membre peut déclarer ses travaux ; la direction valide l'intégration au rapport annuel d'exercice.
                </p>
            </div>
            <% if (currentUser != null) { %>
                <button class="btn btn-primary" onclick="toggleAddForm()">+ Ajouter une publication</button>
            <% } %>
        </div>

        <!-- Add Form Card (Collapsible) -->
        <div id="addFormCard" class="add-form-card">
            <h3 style="font-size: 22px; margin-bottom: 18px;">Déclarer une nouvelle production scientifique</h3>
            <form action="<%= request.getContextPath() %>/publications" method="post">
                <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 16px;">
                    <div class="form-group">
                        <label class="form-label">Titre de l'article / de la communication</label>
                        <input type="text" name="titre" class="form-control" placeholder="ex: Deep Learning for Anomaly Detection..." required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Année de publication</label>
                        <input type="number" name="annee" class="form-control" value="2026" min="2000" max="2030" required>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                    <div class="form-group">
                        <label class="form-label">Auteurs (Séparés par des virgules)</label>
                        <input type="text" name="auteurs" class="form-control" placeholder="Y. Benali, A. Alami..." required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Revue, Conférence ou Ouvrage</label>
                        <input type="text" name="revue" class="form-control" placeholder="IEEE TKDE, Springer, ACM..." required>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px;">
                    <div class="form-group">
                        <label class="form-label">Type de production</label>
                        <select name="type" class="form-control">
                            <option value="Article">Article de Revue (Journal)</option>
                            <option value="Conférence">Actes de Conférence</option>
                            <option value="Ouvrage">Chapitre d'Ouvrage / Livre</option>
                            <option value="Brevet">Brevet d'Invention</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Équipe de rattachement</label>
                        <select name="equipe" class="form-control">
                            <option value="Data Science">Data Science</option>
                            <option value="Cloud & Systèmes">Cloud & Systèmes</option>
                            <option value="IA & Vision">IA & Vision</option>
                            <option value="Cybersécurité">Cybersécurité</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Identifiant DOI / Lien</label>
                        <input type="text" name="doi" class="form-control" placeholder="10.1109/TKDE.2025.1234567">
                    </div>
                </div>

                <div style="display: flex; gap: 10px; margin-top: 10px;">
                    <button type="submit" class="btn btn-primary">Enregistrer la publication →</button>
                    <button type="button" class="btn btn-secondary" onclick="toggleAddForm()">Annuler</button>
                </div>
            </form>
        </div>

        <!-- Filter Card -->
        <div class="card" style="padding: 20px; margin-bottom: 24px;">
            <form action="<%= request.getContextPath() %>/publications" method="get" class="filter-grid">
                <div>
                    <label class="form-label">Filtrer par année</label>
                    <select name="year" class="form-control" onchange="this.form.submit()">
                        <option value="">Toutes les années</option>
                        <option value="2026" <%= "2026".equals(selectedYear) ? "selected" : "" %>>2026</option>
                        <option value="2025" <%= "2025".equals(selectedYear) ? "selected" : "" %>>2025</option>
                        <option value="2024" <%= "2024".equals(selectedYear) ? "selected" : "" %>>2024</option>
                        <option value="2023" <%= "2023".equals(selectedYear) ? "selected" : "" %>>2023</option>
                    </select>
                </div>
                <div>
                    <label class="form-label">Filtrer par équipe</label>
                    <select name="team" class="form-control" onchange="this.form.submit()">
                        <option value="">Toutes les équipes</option>
                        <option value="Data Science" <%= "Data Science".equals(selectedTeam) ? "selected" : "" %>>Data Science</option>
                        <option value="Cloud & Systèmes" <%= "Cloud & Systèmes".equals(selectedTeam) ? "selected" : "" %>>Cloud & Systèmes</option>
                        <option value="IA & Vision" <%= "IA & Vision".equals(selectedTeam) ? "selected" : "" %>>IA & Vision</option>
                        <option value="Cybersécurité" <%= "Cybersécurité".equals(selectedTeam) ? "selected" : "" %>>Cybersécurité</option>
                    </select>
                </div>
                <div>
                    <label class="form-label">Recherche</label>
                    <input type="text" name="author" class="form-control" placeholder="Nom d'auteur..." value="<%= request.getParameter("author") != null ? request.getParameter("author") : "" %>">
                </div>
                <div>
                    <button type="submit" class="btn btn-secondary" style="height: 42px;">Filtrer</button>
                </div>
            </form>
        </div>

        <!-- Publications List -->
        <div class="table-container" style="background: var(--surface);">
            <%
                if (pubs != null && !pubs.isEmpty()) {
                    for (Publication p : pubs) {
            %>
            <div class="pub-row">
                <div class="pub-year"><%= p.getAnnee() %></div>
                <div>
                    <h3 class="pub-title"><%= p.getTitre() %></h3>
                    <div class="pub-authors"><%= p.getAuteurs() %></div>
                    <div class="pub-venue"><%= p.getRevue() %></div>
                    <% if (p.getDoi() != null && !p.getDoi().isEmpty()) { %>
                        <div style="font-family: var(--font-mono); font-size: 11px; color: var(--muted); margin-top: 4px;">
                            DOI : <%= p.getDoi() %>
                        </div>
                    <% } %>
                </div>
                <div style="text-align: right;">
                    <span class="badge badge-navy"><%= p.getType() != null ? p.getType() : "Article" %></span>
                    <div style="font-family: var(--font-mono); font-size: 10.5px; color: var(--muted); margin-top: 6px;">
                        <%= p.getEquipe() != null ? p.getEquipe() : "LIAS" %>
                    </div>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div style="padding: 36px; text-align: center; color: var(--muted); font-size: 14px;">
                Aucune publication ne correspond à ces critères de sélection.
            </div>
            <% } %>
        </div>

            </div>
        </main>
    </div>
</div>

    <script>
        function toggleAddForm() {
            var f = document.getElementById('addFormCard');
            f.style.display = f.style.display === 'block' ? 'none' : 'block';
            if (f.style.display === 'block') {
                f.scrollIntoView({ behavior: 'smooth' });
            }
        }
    </script>
</body>
</html>
