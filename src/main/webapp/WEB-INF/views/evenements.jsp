<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.lias.beans.Evenement"%>
<%@ page import="com.lias.beans.User"%>
<%
    List<Evenement> evts = (List<Evenement>) request.getAttribute("evenements");
    User currentUser = (User) session.getAttribute("currentUser");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS — Événements Scientifiques & Séminaires</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=3">
    <style>
        .event-row {
            display: grid;
            grid-template-columns: 100px 1fr auto;
            gap: 24px;
            padding: 22px 24px;
            border-bottom: 1px solid var(--border);
            align-items: center;
            transition: background 0.15s;
        }
        .event-row:hover {
            background: rgba(237, 229, 211, 0.3);
        }
        .event-date-box {
            text-align: center;
            font-family: var(--font-serif);
            font-size: 28px;
            font-weight: 600;
            color: var(--navy);
            line-height: 1;
        }
        .event-date-sub {
            font-family: var(--font-mono);
            font-size: 11px;
            color: var(--muted);
            letter-spacing: 0.1em;
            text-transform: uppercase;
            margin-top: 4px;
        }
        .event-title {
            font-family: var(--font-serif);
            font-size: 19px;
            font-weight: 500;
            color: var(--ink);
            margin: 0 0 4px;
        }
        .event-meta {
            font-size: 13px;
            color: var(--muted);
        }
        .add-event-panel {
            display: none;
            background: var(--surface);
            border: 1px solid var(--border);
            padding: 28px;
            margin-bottom: 28px;
            border-left: 4px solid var(--accent-2);
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
                <span class="eyebrow"><%= evts != null ? evts.size() : "0" %> événements programmés · agenda académique</span>
                <h1 class="page-title">Événements Scientifiques</h1>
                <p class="page-sub">
                    Conférences, séminaires, soutenances de thèses et workshops organisés ou co-organisés par le laboratoire LIAS.
                </p>
            </div>
            <% if (currentUser != null) { %>
                <button class="btn btn-primary" onclick="toggleAddEvent()">+ Planifier un événement</button>
            <% } %>
        </div>

        <% if ("cree".equals(msg)) { %>
            <div class="toast-notification" id="appToast">
                <div class="toast-icon">✓</div>
                <div class="toast-content">
                    <div class="toast-title">Événement planifié avec succès !</div>
                    <div class="toast-desc">La manifestation scientifique a été enregistrée et ajoutée à l'agenda officiel du laboratoire.</div>
                </div>
                <button type="button" class="toast-close" onclick="closeToast()" title="Fermer">✕</button>
            </div>
        <% } %>

        <!-- Add Event Form -->
        <div id="addEventPanel" class="add-event-panel">
            <h3 style="font-size: 22px; margin-bottom: 16px;">Programmer une manifestation scientifique</h3>
            <form action="<%= request.getContextPath() %>/evenements" method="post">
                <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 16px;">
                    <div class="form-group">
                        <label class="form-label">Titre de la manifestation / Séminaire</label>
                        <input type="text" name="titre" class="form-control" placeholder="ex: Journée Nationale sur l'IA et le Big Data..." required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Date</label>
                        <input type="date" name="date" class="form-control" required>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px;">
                    <div class="form-group">
                        <label class="form-label">Type d'événement</label>
                        <select name="type" class="form-control">
                            <option value="Conférence">Conférence Internationale</option>
                            <option value="Séminaire">Séminaire Scientifique</option>
                            <option value="Workshop">Atelier / Workshop</option>
                            <option value="Soutenance">Soutenance de Doctorat</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Lieu / Salle</label>
                        <input type="text" name="lieu" class="form-control" placeholder="Amphi 1 / Salle des Thèses" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Coordonnateur / Organisateur</label>
                        <input type="text" name="organisateur" class="form-control" value="<%= currentUser != null ? currentUser.getPrenom() + " " + currentUser.getNom() : "" %>" required>
                    </div>
                </div>

                <div style="display: flex; gap: 10px; margin-top: 12px;">
                    <button type="submit" class="btn btn-primary">Valider la programmation →</button>
                    <button type="button" class="btn btn-secondary" onclick="toggleAddEvent()">Annuler</button>
                </div>
            </form>
        </div>

        <!-- Events List -->
        <div class="table-container" style="background: var(--surface);">
            <%
                if (evts != null && !evts.isEmpty()) {
                    for (Evenement e : evts) {
                        String typeTone = "badge-navy";
                        if ("Séminaire".equalsIgnoreCase(e.getType())) typeTone = "badge-gold";
                        else if ("Workshop".equalsIgnoreCase(e.getType())) typeTone = "badge-sage";
            %>
            <div class="event-row">
                <div class="event-date-box">
                    <div><%= e.getDate() != null ? e.getDate().toString().substring(8) : "15" %></div>
                    <div class="event-date-sub"><%= e.getDate() != null ? e.getDate().toString().substring(0,7) : "2026-06" %></div>
                </div>
                <div>
                    <h3 class="event-title"><%= e.getTitre() %></h3>
                    <div class="event-meta">
                        Lieu : <strong><%= e.getLieu() %></strong> · Coordonné par : <%= e.getOrganisateur() != null ? e.getOrganisateur() : "LIAS" %>
                    </div>
                </div>
                <div>
                    <span class="badge <%= typeTone %>"><%= e.getType() %></span>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div style="padding: 36px; text-align: center; color: var(--muted);">
                Aucun événement enregistré.
            </div>
            <% } %>
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

    <script>
        function toggleAddEvent() {
            var el = document.getElementById('addEventPanel');
            el.style.display = el.style.display === 'block' ? 'none' : 'block';
            if (el.style.display === 'block') el.scrollIntoView({ behavior: 'smooth' });
        }
        function closeToast() {
            var toast = document.getElementById("appToast");
            if (toast) {
                toast.classList.add("toast-hide");
                setTimeout(function() { toast.remove(); }, 350);
            }
        }
        document.addEventListener("DOMContentLoaded", function() {
            var toast = document.getElementById("appToast");
            if (toast) {
                setTimeout(function() {
                    closeToast();
                }, 5000);
                if (window.history.replaceState) {
                    var cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname;
                    window.history.replaceState({ path: cleanUrl }, '', cleanUrl);
                }
            }
        });
    </script>
</body>
</html>
