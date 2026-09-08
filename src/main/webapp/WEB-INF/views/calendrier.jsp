<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.lias.beans.Evenement"%>
<%@ page import="com.lias.beans.User"%>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) currentUser = (User) session.getAttribute("user");
    List<Evenement> evenements = (List<Evenement>) request.getAttribute("evenements");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS — Calendrier Scientifique & Navigation Temporelle</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=3">
    <style>
        .cal-nav-btn {
            background: var(--surface);
            border: 1px solid var(--border);
            color: var(--navy);
            width: 38px;
            height: 38px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            cursor: pointer;
            border-radius: 4px;
            transition: all 0.15s ease;
        }
        .cal-nav-btn:hover {
            background: var(--navy);
            color: var(--cream);
            border-color: var(--navy);
        }
        .cal-grid-table {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            border: 1px solid var(--border);
            border-radius: 6px;
            overflow: hidden;
            background: var(--surface);
        }
        .cal-header-cell {
            padding: 12px 14px;
            background: var(--surface-2);
            border-bottom: 1px solid var(--border);
            font-family: var(--font-mono);
            font-size: 11px;
            letter-spacing: 0.12em;
            color: var(--muted);
            text-transform: uppercase;
            text-align: center;
            font-weight: 600;
        }
        .cal-day-cell {
            min-height: 120px;
            padding: 10px 8px;
            border-right: 1px solid var(--border);
            border-bottom: 1px solid var(--border);
            background: var(--surface);
            position: relative;
            transition: background 0.12s ease;
        }
        .cal-day-cell:nth-child(7n) {
            border-right: none;
        }
        .cal-day-cell.other-month {
            background: rgba(21, 43, 68, 0.02);
            opacity: 0.45;
        }
        .cal-day-cell.is-today {
            background: rgba(176, 136, 56, 0.07);
        }
        .cal-day-number {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 26px;
            height: 26px;
            font-family: var(--font-serif);
            font-size: 15px;
            color: var(--ink);
            border-radius: 50%;
            margin-bottom: 8px;
            font-weight: 500;
        }
        .cal-day-cell.is-today .cal-day-number {
            background: var(--accent-2);
            color: #FFFFFF;
            font-weight: 700;
        }
        .cal-event-pill {
            display: block;
            margin-bottom: 4px;
            padding: 4px 7px;
            border-radius: 4px;
            font-size: 11px;
            line-height: 1.3;
            font-family: var(--font-sans);
            font-weight: 500;
            color: #FFFFFF;
            text-decoration: none;
            cursor: pointer;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            transition: transform 0.12s ease, box-shadow 0.12s ease;
        }
        .cal-event-pill:hover {
            transform: translateY(-1px);
            box-shadow: 0 3px 6px rgba(0,0,0,0.15);
        }
        .pill-conference { background: var(--navy); }
        .pill-seminaire { background: #B08838; }
        .pill-workshop { background: #33503A; }
        .pill-autre { background: #556B82; }

        .legend-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            display: inline-block;
        }
    </style>
</head>
<body>

<% if (currentUser == null) { %>
    <%@ include file="includes/navbar.jsp" %>
    <div class="container" style="max-width: 1200px; margin: 0 auto; padding: 40px 24px;">
<% } else { %>
<div class="app-shell">
    <%@ include file="includes/app_header.jsp" %>
    <div class="app-body">
        <%@ include file="includes/sidebar.jsp" %>
        <main class="app-main">
            <div class="app-content">
<% } %>

        <!-- En-tête de page -->
        <div class="page-header" style="margin-bottom: 24px;">
            <div>
                <span class="eyebrow">Visualisation des Événements · Navigation Temporelle (CDC §20)</span>
                <h1 class="page-title">Calendrier Scientifique</h1>
                <p class="page-sub">
                    Vue mensuelle et annuelle officielle de toutes les manifestations, conférences, séminaires et soutenances du laboratoire LIAS.
                </p>
            </div>
            <div style="display: flex; gap: 10px; align-items: center;">
                <button type="button" class="btn btn-ghost" onclick="setToday()">Aujourd'hui</button>
                <div style="display: inline-flex; border: 1px solid var(--border); border-radius: 4px; overflow: hidden;">
                    <button type="button" id="btnVueMois" class="btn btn-sm btn-primary" onclick="switchView('mois')" style="border-radius:0;">Mois</button>
                    <button type="button" id="btnVueAgenda" class="btn btn-sm btn-ghost" onclick="switchView('agenda')" style="border-radius:0;">Agenda</button>
                </div>
                <% if (currentUser != null) { %>
                    <a href="<%= request.getContextPath() %>/evenements" class="btn btn-primary">+ Planifier</a>
                <% } %>
            </div>
        </div>

        <!-- Barre de navigation temporelle & Légende -->
        <div class="card" style="padding: 16px 20px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px;">
            <div style="display: flex; align-items: center; gap: 16px;">
                <button type="button" class="cal-nav-btn" onclick="changeMonth(-1)" title="Mois précédent">←</button>
                <h2 id="calendarTitle" style="font-family: var(--font-serif); font-size: 26px; font-weight: 600; color: var(--navy); margin: 0; min-width: 220px; text-transform: capitalize;">
                    Septembre 2026
                </h2>
                <button type="button" class="cal-nav-btn" onclick="changeMonth(1)" title="Mois suivant">→</button>
            </div>

            <div style="display: flex; gap: 16px; align-items: center; font-size: 13px; color: var(--muted);">
                <div style="display: flex; align-items: center; gap: 6px;">
                    <span class="legend-dot" style="background: var(--navy);"></span>
                    <span>Conférence</span>
                </div>
                <div style="display: flex; align-items: center; gap: 6px;">
                    <span class="legend-dot" style="background: #B08838;"></span>
                    <span>Séminaire</span>
                </div>
                <div style="display: flex; align-items: center; gap: 6px;">
                    <span class="legend-dot" style="background: #33503A;"></span>
                    <span>Workshop / Atelier</span>
                </div>
            </div>
        </div>

        <!-- Grille Mensuelle (Vue par défaut) -->
        <div id="calendarMonthView">
            <div class="cal-grid-table">
                <div class="cal-header-cell">Lundi</div>
                <div class="cal-header-cell">Mardi</div>
                <div class="cal-header-cell">Mercredi</div>
                <div class="cal-header-cell">Jeudi</div>
                <div class="cal-header-cell">Vendredi</div>
                <div class="cal-header-cell">Samedi</div>
                <div class="cal-header-cell">Dimanche</div>

                <div id="calendarGridDays" style="display: contents;">
                    <!-- Les cellules des jours seront générées dynamiquement par JavaScript -->
                </div>
            </div>
        </div>

        <!-- Vue Agenda / Liste (Alternative) -->
        <div id="calendarAgendaView" style="display: none;">
            <div class="card" style="padding: 24px;">
                <h3 style="font-size: 20px; margin-bottom: 16px; color: var(--navy);">Événements programmés pour ce mois</h3>
                <div id="agendaListContent">
                    <!-- Rempli en JS -->
                </div>
            </div>
        </div>

        <!-- Modal de détail d'un événement -->
        <div id="eventModal" style="display:none; position: fixed; inset: 0; background: rgba(21,43,68,0.45); backdrop-filter: blur(3px); z-index: 99999; align-items: center; justify-content: center;">
            <div class="card" style="max-width: 520px; width: 90%; padding: 30px; border-top: 5px solid var(--accent-2); position: relative;">
                <button type="button" onclick="closeEventModal()" style="position: absolute; top: 16px; right: 16px; background: none; border: none; font-size: 20px; cursor: pointer; color: var(--muted);">✕</button>
                <span id="modalTypeBadge" class="badge badge-gold" style="margin-bottom: 10px;">Conférence</span>
                <h3 id="modalEventTitle" style="font-family: var(--font-serif); font-size: 22px; color: var(--navy); margin-bottom: 12px;">Titre de l'événement</h3>
                <div style="font-size: 13.5px; color: var(--muted); margin-bottom: 16px; line-height: 1.6;">
                    <p style="margin-bottom: 6px;">📅 <strong>Date :</strong> <span id="modalEventDate">2026-09-15</span></p>
                    <p style="margin-bottom: 6px;">📍 <strong>Lieu :</strong> <span id="modalEventLieu">Amphithéâtre FSBM</span></p>
                    <p style="margin-bottom: 6px;">👤 <strong>Organisateur :</strong> <span id="modalEventOrg">Prof. Amine Alami</span></p>
                </div>
                <div style="background: var(--surface-2); padding: 14px; border-radius: 4px; font-size: 13px; color: var(--ink); line-height: 1.5; margin-bottom: 20px;">
                    <strong style="display: block; margin-bottom: 4px; color: var(--navy);">Description :</strong>
                    <span id="modalEventDesc">Détails de la manifestation...</span>
                </div>
                <div style="display: flex; justify-content: flex-end; gap: 10px;">
                    <button type="button" class="btn btn-ghost" onclick="closeEventModal()">Fermer</button>
                    <% if (currentUser != null) { %>
                        <a href="<%= request.getContextPath() %>/evenements" class="btn btn-primary">Gérer dans les Événements →</a>
                    <% } %>
                </div>
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

<!-- Données JSON des événements du laboratoire pour le calendrier -->
<script>
    var labEvents = [
        <%
            if (evenements != null) {
                for (int i = 0; i < evenements.size(); i++) {
                    Evenement e = evenements.get(i);
        %>
        {
            id: <%= e.getId() %>,
            title: "<%= e.getTitre() != null ? e.getTitre().replace("\"", "\\\"") : "" %>",
            type: "<%= e.getType() != null ? e.getType() : "Séminaire" %>",
            date: "<%= e.getDate() != null ? e.getDate() : "" %>",
            lieu: "<%= e.getLieu() != null ? e.getLieu().replace("\"", "\\\"") : "FSBM Casablanca" %>",
            organisateur: "<%= e.getOrganisateur() != null ? e.getOrganisateur().replace("\"", "\\\"") : "LIAS" %>",
            description: "<%= e.getDescription() != null ? e.getDescription().replace("\"", "\\\"").replace("\n", " ") : "" %>"
        }<%= (i < evenements.size() - 1) ? "," : "" %>
        <%
                }
            }
        %>
    ];

    var currentYear = 2026;
    var currentMonth = 8; // 0-indexed : 8 = Septembre

    var monthNames = [
        "Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
        "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"
    ];

    function renderCalendar() {
        var titleEl = document.getElementById("calendarTitle");
        titleEl.innerText = monthNames[currentMonth] + " " + currentYear;

        var gridDaysEl = document.getElementById("calendarGridDays");
        gridDaysEl.innerHTML = "";

        // Premier jour du mois (0 = Dimanche, 1 = Lundi ...)
        var firstDayDate = new Date(currentYear, currentMonth, 1);
        var startDay = (firstDayDate.getDay() + 6) % 7; // Convertir Lundi = 0
        var daysInMonth = new Date(currentYear, currentMonth + 1, 0).getDate();
        var daysInPrevMonth = new Date(currentYear, currentMonth, 0).getDate();

        var today = new Date();
        var isCurrentRealMonth = (today.getFullYear() === currentYear && today.getMonth() === currentMonth);
        var realTodayDate = today.getDate();

        // 1. Jours du mois précédent pour combler la première semaine
        for (var i = startDay - 1; i >= 0; i--) {
            var prevD = daysInPrevMonth - i;
            var cell = document.createElement("div");
            cell.className = "cal-day-cell other-month";
            cell.innerHTML = '<span class="cal-day-number">' + prevD + '</span>';
            gridDaysEl.appendChild(cell);
        }

        // 2. Jours du mois courant
        var monthEventsList = [];
        for (var d = 1; d <= daysInMonth; d++) {
            var cell = document.createElement("div");
            var isTodayCell = (isCurrentRealMonth && d === realTodayDate);
            cell.className = "cal-day-cell" + (isTodayCell ? " is-today" : "");

            var dateStr = currentYear + "-" + String(currentMonth + 1).padStart(2, '0') + "-" + String(d).padStart(2, '0');
            
            var dayHtml = '<span class="cal-day-number">' + d + '</span>';

            // Filtrer les événements de ce jour
            var dayEvts = labEvents.filter(function(ev) {
                return ev.date === dateStr;
            });

            dayEvts.forEach(function(ev) {
                monthEventsList.push(ev);
                var pillClass = "pill-seminaire";
                var t = (ev.type || "").toLowerCase();
                if (t.indexOf("conf") !== -1) pillClass = "pill-conference";
                else if (t.indexOf("work") !== -1 || t.indexOf("atelier") !== -1) pillClass = "pill-workshop";

                dayHtml += '<div class="cal-event-pill ' + pillClass + '" onclick="showEventModal(' + ev.id + ')" title="' + ev.title + '">' +
                           ev.title + '</div>';
            });

            cell.innerHTML = dayHtml;
            gridDaysEl.appendChild(cell);
        }

        // 3. Jours du mois suivant pour combler la dernière semaine
        var totalCells = startDay + daysInMonth;
        var nextDays = (7 - (totalCells % 7)) % 7;
        for (var n = 1; n <= nextDays; n++) {
            var cell = document.createElement("div");
            cell.className = "cal-day-cell other-month";
            cell.innerHTML = '<span class="cal-day-number">' + n + '</span>';
            gridDaysEl.appendChild(cell);
        }

        // Remplir l'agenda list
        var agendaListEl = document.getElementById("agendaListContent");
        if (monthEventsList.length === 0) {
            agendaListEl.innerHTML = '<p style="color:var(--muted); font-size:14px;">Aucun événement enregistré pour ce mois.</p>';
        } else {
            var agHtml = '<div style="display:flex; flex-direction:column; gap:12px;">';
            monthEventsList.forEach(function(ev) {
                agHtml += '<div class="card" style="padding:14px 18px; display:flex; justify-content:space-between; align-items:center; cursor:pointer;" onclick="showEventModal(' + ev.id + ')">' +
                          '<div><strong style="font-size:15px; color:var(--navy);">' + ev.title + '</strong>' +
                          '<div style="font-size:12px; color:var(--muted); margin-top:4px;">📍 ' + ev.lieu + ' · 👤 ' + ev.organisateur + '</div></div>' +
                          '<div style="text-align:right;"><span class="badge badge-gold">' + ev.date + '</span><div style="font-size:11px; color:var(--muted); margin-top:4px;">' + ev.type + '</div></div>' +
                          '</div>';
            });
            agHtml += '</div>';
            agendaListEl.innerHTML = agHtml;
        }
    }

    function changeMonth(delta) {
        currentMonth += delta;
        if (currentMonth < 0) {
            currentMonth = 11;
            currentYear--;
        } else if (currentMonth > 11) {
            currentMonth = 0;
            currentYear++;
        }
        renderCalendar();
    }

    function setToday() {
        var now = new Date();
        currentYear = now.getFullYear();
        currentMonth = now.getMonth();
        renderCalendar();
    }

    function switchView(view) {
        var m = document.getElementById("calendarMonthView");
        var a = document.getElementById("calendarAgendaView");
        var bm = document.getElementById("btnVueMois");
        var ba = document.getElementById("btnVueAgenda");

        if (view === 'mois') {
            m.style.display = "block";
            a.style.display = "none";
            bm.className = "btn btn-sm btn-primary";
            ba.className = "btn btn-sm btn-ghost";
        } else {
            m.style.display = "none";
            a.style.display = "block";
            bm.className = "btn btn-sm btn-ghost";
            ba.className = "btn btn-sm btn-primary";
        }
    }

    function showEventModal(id) {
        var ev = labEvents.find(function(e) { return e.id === id; });
        if (!ev) return;

        document.getElementById("modalEventTitle").innerText = ev.title;
        document.getElementById("modalTypeBadge").innerText = ev.type;
        document.getElementById("modalEventDate").innerText = ev.date;
        document.getElementById("modalEventLieu").innerText = ev.lieu;
        document.getElementById("modalEventOrg").innerText = ev.organisateur;
        document.getElementById("modalEventDesc").innerText = ev.description || "Aucune description détaillée renseignée.";

        var modal = document.getElementById("eventModal");
        modal.style.display = "flex";
    }

    function closeEventModal() {
        document.getElementById("eventModal").style.display = "none";
    }

    document.addEventListener("DOMContentLoaded", function() {
        renderCalendar();
    });
</script>

</body>
</html>
