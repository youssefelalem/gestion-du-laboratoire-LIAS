<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.lias.beans.NotificationLabo"%>
<%@ page import="com.lias.beans.User"%>
<%
    List<NotificationLabo> notifs = (List<NotificationLabo>) request.getAttribute("notifications");
    Integer unreadCount = (Integer) request.getAttribute("unreadCount");
    if (unreadCount == null) unreadCount = 0;
    String activeFilter = (String) request.getAttribute("activeFilter");
    if (activeFilter == null) activeFilter = "toutes";

    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS — Centre de Notifications</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@500;700&family=Inter:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Spectral:ital,wght@0,400;0,600;1,400&display=swap" rel="stylesheet">
    <style>
        .filter-pills {
            display: flex;
            gap: 8px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .filter-pill {
            padding: 6px 14px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 100px;
            font-family: 'Inter', sans-serif;
            font-size: 12.5px;
            color: var(--muted);
            text-decoration: none;
            cursor: pointer;
            transition: all 0.15s ease;
        }
        .filter-pill:hover {
            color: var(--ink);
            border-color: var(--ink);
        }
        .filter-pill.active {
            background: var(--navy);
            color: #FFF;
            border-color: var(--navy);
            font-weight: 500;
        }
        .notif-item {
            display: grid;
            grid-template-columns: auto 1fr auto;
            gap: 16px;
            align-items: center;
            padding: 16px 20px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 4px;
            margin-bottom: 10px;
            transition: all 0.15s ease;
        }
        .notif-item.unread {
            background: #FAF8F5;
            border-left: 3px solid var(--navy);
        }
        .notif-item:hover {
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }
        .notif-icon-circle {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 15px;
            flex-shrink: 0;
        }
        .tone-gold { background: #FAF3E3; color: #8A6520; border: 1px solid #E8D3A5; }
        .tone-navy { background: #EAF0F8; color: #1B2F4A; border: 1px solid #B8CDE5; }
        .tone-sage { background: #EBF3ED; color: #2C5E3B; border: 1px solid #BED8C5; }
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
            <!-- NOTIFICATION TOAST -->
            <% if ("lu".equals(msg)) { %>
                <div class="toast toast-success" style="display:flex; align-items:center; gap:10px; margin-bottom:16px; padding:12px 18px; background:#E8F5E9; border-left:4px solid #2E7D32; color:#1B5E20; border-radius:3px;">
                    <span style="font-size:18px;">✓</span>
                    <div>
                        <strong>Mise à jour réussie !</strong> Les notifications ont été marquées comme lues.
                    </div>
                </div>
            <% } %>

            <!-- SECTION HEAD -->
            <div class="section-head">
                <div>
                    <div class="section-eyebrow"><%= notifs != null ? notifs.size() : 0 %> notifications · historique institutionnel (CDC §19)</div>
                    <h1 class="section-title">Centre de notifications</h1>
                    <p class="section-subtitle">
                        Événements scientifiques, flux d'adhésion, publications à valider, alertes de gouvernance et rappels administratifs.
                    </p>
                </div>
                <div class="section-actions">
                    <form action="<%= request.getContextPath() %>/notifications" method="POST" style="margin:0;">
                        <input type="hidden" name="action" value="markAllRead">
                        <button type="submit" class="btn btn-secondary btn-sm">
                            ✓ Tout marquer comme lu
                        </button>
                    </form>
                </div>
            </div>

            <!-- FILTER PILLS -->
            <div class="filter-pills">
                <a href="<%= request.getContextPath() %>/notifications?filter=toutes" class="filter-pill <%= "toutes".equalsIgnoreCase(activeFilter) ? "active" : "" %>">
                    Toutes (<%= notifs != null ? notifs.size() : 0 %>)
                </a>
                <a href="<%= request.getContextPath() %>/notifications?filter=non lues" class="filter-pill <%= "non lues".equalsIgnoreCase(activeFilter) ? "active" : "" %>">
                    Non lues (<%= unreadCount %>)
                </a>
                <a href="<%= request.getContextPath() %>/notifications?filter=adhesion" class="filter-pill <%= "adhesion".equalsIgnoreCase(activeFilter) ? "active" : "" %>">
                    Adhésions
                </a>
                <a href="<%= request.getContextPath() %>/notifications?filter=publication" class="filter-pill <%= "publication".equalsIgnoreCase(activeFilter) ? "active" : "" %>">
                    Publications
                </a>
                <a href="<%= request.getContextPath() %>/notifications?filter=event" class="filter-pill <%= "event".equalsIgnoreCase(activeFilter) ? "active" : "" %>">
                    Évènements
                </a>
                <a href="<%= request.getContextPath() %>/notifications?filter=document" class="filter-pill <%= "document".equalsIgnoreCase(activeFilter) ? "active" : "" %>">
                    Documents
                </a>
            </div>

            <!-- NOTIFICATIONS LIST -->
            <div>
                <% if (notifs == null || notifs.isEmpty()) { %>
                    <div class="card" style="padding:48px 24px; text-align:center; color:var(--muted);">
                        Aucune notification ne correspond aux filtres sélectionnés.
                    </div>
                <% } else { %>
                    <% for (NotificationLabo n : notifs) { 
                        String tone = "tone-navy";
                        String icon = "¶";
                        String k = n.getKind() != null ? n.getKind().toLowerCase() : "";
                        if ("adhesion".equals(k) || "materiel".equals(k)) {
                            tone = "tone-gold";
                            icon = "+";
                        } else if ("event".equals(k) || "meeting".equals(k) || "convention".equals(k)) {
                            tone = "tone-sage";
                            icon = "◇";
                        }
                    %>
                        <div class="notif-item <%= !n.isRead() ? "unread" : "" %>">
                            <div class="notif-icon-circle <%= tone %>">
                                <%= icon %>
                            </div>
                            <div>
                                <div style="font-size:13.5px; color:var(--ink); line-height:1.4;">
                                    <strong><%= n.getWho() %></strong> <%= n.getBody() %>
                                </div>
                                <div style="font-family:'JetBrains Mono', monospace; font-size:11px; color:var(--muted); margin-top:4px;">
                                    <%= n.getWhenText() %> · <%= k.toUpperCase() %>
                                </div>
                            </div>
                            <div>
                                <% if (n.getTargetUrl() != null && !n.getTargetUrl().trim().isEmpty()) { %>
                                    <a href="<%= request.getContextPath() %><%= n.getTargetUrl() %>" class="btn btn-ghost btn-sm" style="font-size:12.5px; white-space:nowrap;">
                                        <%= n.getActionLabel() != null ? n.getActionLabel() : "Consulter →" %>
                                    </a>
                                <% } %>
                            </div>
                        </div>
                    <% } %>
                <% } %>
            </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>
