<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.lias.beans.MessageCommunication"%>
<%@ page import="com.lias.beans.User"%>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) currentUser = (User) session.getAttribute("user");
    List<MessageCommunication> messages = (List<MessageCommunication>) request.getAttribute("messages");
    String activeCanal = (String) request.getAttribute("activeCanal");
    if (activeCanal == null) activeCanal = "general";
    String msgStatus = request.getParameter("msg");

    String canalTitre = "Canal Général & Direction";
    String canalDesc = "Discussions transversales, annonces officielles et coordination de l'ensemble des membres du LIAS.";
    if ("team_ia".equalsIgnoreCase(activeCanal)) {
        canalTitre = "Équipe Intelligence Artificielle & Deep Learning (IA)";
        canalDesc = "Travaux sur les modèles génératifs, vision par ordinateur et apprentissage automatique.";
    } else if ("team_bigdata".equalsIgnoreCase(activeCanal)) {
        canalTitre = "Équipe Big Data Streams & Cloud Computing";
        canalDesc = "Architectures distribuées, traitement de flux temps réel avec Spark et infrastructures cloud.";
    } else if ("team_securite".equalsIgnoreCase(activeCanal)) {
        canalTitre = "Équipe Cybersécurité & Architectures Zero-Trust";
        canalDesc = "Sécurité des systèmes distribués, cryptographie appliquée et résilience logicielle.";
    } else if ("team_nlp".equalsIgnoreCase(activeCanal)) {
        canalTitre = "Équipe Traitement Automatique des Langues (NLP)";
        canalDesc = "Modèles de langage pour dialectes nord-africains (Darija), TAL et fouille de textes.";
    } else if ("events".equalsIgnoreCase(activeCanal)) {
        canalTitre = "Organisation des Manifestations & Événements";
        canalDesc = "Coordination logistique, appels à communications et préparation des ateliers scientifiques.";
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS — Communication Interne & Canaux d'Équipes</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=3">
    <style>
        .comm-layout {
            display: grid;
            grid-template-columns: 280px 1fr;
            border: 1px solid var(--border);
            border-radius: 6px;
            background: var(--surface);
            overflow: hidden;
            height: calc(100vh - 210px);
            min-height: 560px;
        }
        .comm-sidebar {
            background: var(--surface-2);
            border-right: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            overflow-y: auto;
        }
        .channel-section-title {
            padding: 14px 18px 6px;
            font-family: var(--font-mono);
            font-size: 10.5px;
            text-transform: uppercase;
            letter-spacing: 0.14em;
            color: var(--muted);
            font-weight: 700;
        }
        .channel-link {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 18px;
            color: var(--ink);
            text-decoration: none !important;
            font-size: 13.5px;
            font-weight: 500;
            border-left: 3px solid transparent;
            transition: all 0.12s ease;
        }
        .channel-link:hover {
            background: rgba(21, 43, 68, 0.04);
            color: var(--navy);
        }
        .channel-link.active {
            background: #FFFFFF;
            color: var(--navy);
            font-weight: 600;
            border-left-color: var(--accent-2);
        }
        .channel-badge-hash {
            font-family: var(--font-mono);
            font-size: 14px;
            color: var(--accent-2);
            font-weight: 700;
        }
        .comm-main {
            display: flex;
            flex-direction: column;
            background: #FFFFFF;
            height: 100%;
            overflow: hidden;
        }
        .comm-header {
            padding: 16px 24px;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: var(--surface);
        }
        .comm-messages-list {
            flex: 1;
            padding: 24px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 18px;
        }
        .msg-card {
            display: flex;
            align-items: flex-start;
            gap: 14px;
        }
        .msg-avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: var(--navy);
            color: var(--cream);
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: var(--font-serif);
            font-size: 15px;
            font-weight: 600;
            flex-shrink: 0;
        }
        .msg-body {
            flex: 1;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 6px;
            padding: 14px 16px;
        }
        .msg-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 6px;
        }
        .msg-author {
            font-weight: 600;
            font-size: 14px;
            color: var(--navy);
        }
        .msg-time {
            font-size: 11px;
            color: var(--muted);
            font-family: var(--font-mono);
            margin-left: auto;
        }
        .msg-text {
            font-size: 13.5px;
            line-height: 1.55;
            color: var(--ink);
        }
        .comm-composer {
            padding: 16px 24px;
            border-top: 1px solid var(--border);
            background: var(--surface);
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

        <% if ("envoye".equals(msgStatus)) { %>
            <div class="toast-notification" id="appToast">
                <div class="toast-icon">✓</div>
                <div class="toast-content">
                    <div class="toast-title">Message publié avec succès !</div>
                    <div class="toast-desc">Votre message a été diffusé aux membres du canal et consigné dans l'historique du laboratoire.</div>
                </div>
                <button type="button" class="toast-close" onclick="closeToast()" title="Fermer">✕</button>
            </div>
        <% } %>

        <!-- Header -->
        <div class="page-header" style="margin-bottom: 20px;">
            <div>
                <span class="eyebrow">Espaces de Discussion · Canaux Thématiques (CDC §13)</span>
                <h1 class="page-title">Communication Interne</h1>
                <p class="page-sub">
                    Discussions entre membres, échanges par équipe de recherche, et coordination autour des événements.
                </p>
            </div>
        </div>

        <!-- Layout 2 colonnes -->
        <div class="comm-layout">
            <!-- Sidebar Canaux -->
            <div class="comm-sidebar">
                <div class="channel-section-title">Canaux Institutionnels</div>
                <a href="<%= request.getContextPath() %>/communication?canal=general" class="channel-link <%= "general".equals(activeCanal) ? "active" : "" %>">
                    <span class="channel-badge-hash">#</span>
                    <span>Général & Direction</span>
                </a>
                <a href="<%= request.getContextPath() %>/communication?canal=events" class="channel-link <%= "events".equals(activeCanal) ? "active" : "" %>">
                    <span class="channel-badge-hash">#</span>
                    <span>Événements & Séminaires</span>
                </a>

                <div class="channel-section-title" style="margin-top: 14px;">Équipes de Recherche (CDC §13)</div>
                <a href="<%= request.getContextPath() %>/communication?canal=team_ia" class="channel-link <%= "team_ia".equals(activeCanal) ? "active" : "" %>">
                    <span class="channel-badge-hash">#</span>
                    <span>Équipe IA (Intelligence Artificielle)</span>
                </a>
                <a href="<%= request.getContextPath() %>/communication?canal=team_bigdata" class="channel-link <%= "team_bigdata".equals(activeCanal) ? "active" : "" %>">
                    <span class="channel-badge-hash">#</span>
                    <span>Équipe Big Data & Cloud</span>
                </a>
                <a href="<%= request.getContextPath() %>/communication?canal=team_securite" class="channel-link <%= "team_securite".equals(activeCanal) ? "active" : "" %>">
                    <span class="channel-badge-hash">#</span>
                    <span>Équipe Cybersécurité</span>
                </a>
                <a href="<%= request.getContextPath() %>/communication?canal=team_nlp" class="channel-link <%= "team_nlp".equals(activeCanal) ? "active" : "" %>">
                    <span class="channel-badge-hash">#</span>
                    <span>Équipe NLP & Dialectes</span>
                </a>

                <div style="margin-top: auto; padding: 16px; border-top: 1px solid var(--border); font-size: 12px; color: var(--muted); line-height: 1.4;">
                    🔒 <strong>Archivage conforme CDC :</strong> Toutes les communications sont rattachées à la mémoire institutionnelle du LIAS.
                </div>
            </div>

            <!-- Fil Central -->
            <div class="comm-main">
                <!-- En-tête du canal actif -->
                <div class="comm-header">
                    <div>
                        <h3 style="font-size: 18px; margin: 0 0 4px; color: var(--navy); display: flex; align-items: center; gap: 8px;">
                            <span style="color: var(--accent-2);">#</span> <%= canalTitre %>
                        </h3>
                        <p style="font-size: 12.5px; color: var(--muted); margin: 0;">
                            <%= canalDesc %>
                        </p>
                    </div>
                    <span class="badge badge-navy"><%= messages != null ? messages.size() : 0 %> messages</span>
                </div>

                <!-- Liste des messages -->
                <div class="comm-messages-list" id="messagesContainer">
                    <%
                        if (messages != null && !messages.isEmpty()) {
                            for (MessageCommunication m : messages) {
                                String initials = "CH";
                                if (m.getAuteurNom() != null && m.getAuteurNom().length() >= 2) {
                                    String[] parts = m.getAuteurNom().split(" ");
                                    if (parts.length >= 2) {
                                        initials = ("" + parts[0].charAt(0) + parts[1].charAt(0)).toUpperCase();
                                    } else {
                                        initials = m.getAuteurNom().substring(0, 2).toUpperCase();
                                    }
                                }
                                String badgeStyle = "badge-navy";
                                if ("DIRECTEUR".equalsIgnoreCase(m.getAuteurRole())) badgeStyle = "badge-gold";
                                else if ("DOCTORANT".equalsIgnoreCase(m.getAuteurRole()) || "DOCTORANTE".equalsIgnoreCase(m.getAuteurRole())) badgeStyle = "badge-accent";
                    %>
                    <div class="msg-card">
                        <div class="msg-avatar"><%= initials %></div>
                        <div class="msg-body">
                            <div class="msg-header">
                                <span class="msg-author"><%= m.getAuteurNom() %></span>
                                <span class="badge <%= badgeStyle %>" style="font-size: 10.5px;"><%= m.getAuteurRole() %></span>
                                <span class="msg-time"><%= m.getDateEnvoi() %></span>
                            </div>
                            <div class="msg-text"><%= m.getMessage() %></div>
                        </div>
                    </div>
                    <%
                            }
                        } else {
                    %>
                    <div style="text-align: center; color: var(--muted); margin: auto; padding: 40px;">
                        <p style="font-size: 15px; margin-bottom: 6px;">Aucun message dans ce canal pour l'instant.</p>
                        <p style="font-size: 13px;">Soyez le premier à publier une annonce ou une discussion scientifique !</p>
                    </div>
                    <% } %>
                </div>

                <!-- Zone de saisie -->
                <div class="comm-composer">
                    <% if (currentUser != null) { %>
                        <form action="<%= request.getContextPath() %>/communication" method="post" style="display: flex; gap: 12px; align-items: flex-end;">
                            <input type="hidden" name="canalId" value="<%= activeCanal %>">
                            <div style="flex: 1;">
                                <textarea name="message" class="form-control" rows="2" placeholder="Rédiger un message ou une annonce pour le canal #<%= activeCanal %>..." required style="resize: none; font-size: 13.5px;"></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary" style="padding: 12px 20px; white-space: nowrap;">
                                Publier →
                            </button>
                        </form>
                    <% } else { %>
                        <div style="background: var(--surface-2); padding: 12px; border-radius: 4px; text-align: center; font-size: 13px; color: var(--muted);">
                            Veuillez vous <a href="<%= request.getContextPath() %>/login" style="color: var(--navy); font-weight: 600;">connecter à votre espace membre</a> pour participer aux discussions internes.
                        </div>
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

<script>
    function closeToast() {
        var toast = document.getElementById("appToast");
        if (toast) {
            toast.classList.add("toast-hide");
            setTimeout(function() { toast.remove(); }, 350);
        }
    }
    document.addEventListener("DOMContentLoaded", function() {
        var container = document.getElementById("messagesContainer");
        if (container) {
            container.scrollTop = container.scrollHeight;
        }
        var toast = document.getElementById("appToast");
        if (toast) {
            setTimeout(function() {
                closeToast();
            }, 5000);
            if (window.history.replaceState) {
                var cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname + "?canal=<%= activeCanal %>";
                window.history.replaceState({ path: cleanUrl }, '', cleanUrl);
            }
        }
    });
</script>

</body>
</html>
