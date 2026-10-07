<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.lias.beans.User"%>
<%@ page import="com.lias.beans.LaboratoireInfo"%>
<%
    User currentAdmin = (User) session.getAttribute("currentUser");
    if (currentAdmin == null) currentAdmin = (User) session.getAttribute("user");

    String activeTab = (String) request.getAttribute("activeTab");
    if (activeTab == null || activeTab.isEmpty()) activeTab = "users";

    List<User> users = (List<User>) request.getAttribute("users");
    LaboratoireInfo labInfo = (LaboratoireInfo) request.getAttribute("labInfo");
    if (labInfo == null) labInfo = new LaboratoireInfo();

    String msg = request.getParameter("success");

    int totalUsers = (users != null) ? users.size() : 0;
    int activeUsers = 0;
    int adminCount = 0;
    int researcherCount = 0;

    if (users != null) {
        for (User u : users) {
            if (u.isActif()) activeUsers++;
            if ("admin".equalsIgnoreCase(u.getRole())) adminCount++;
            if ("directeur".equalsIgnoreCase(u.getRole()) || "permanent".equalsIgnoreCase(u.getRole()) || "associe".equalsIgnoreCase(u.getRole())) {
                researcherCount++;
            }
        }
    }

    boolean isDbConnected = Boolean.TRUE.equals(request.getAttribute("dbConnected"));
    long dbLatency = request.getAttribute("dbLatency") != null ? (Long) request.getAttribute("dbLatency") : 0L;
    long jvmUsed = request.getAttribute("jvmUsedMemory") != null ? (Long) request.getAttribute("jvmUsedMemory") : 0L;
    long jvmMax = request.getAttribute("jvmMaxMemory") != null ? (Long) request.getAttribute("jvmMaxMemory") : 1L;
    int jvmPercent = request.getAttribute("jvmPercent") != null ? (Integer) request.getAttribute("jvmPercent") : 0;
    boolean isMaintenance = Boolean.TRUE.equals(request.getAttribute("maintenanceMode"));
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS — Console d'Administration Technique (CDC §5.1)</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=2">
    <style>
        .stat-bar-container {
            width: 100%;
            height: 10px;
            background: #E2E8F0;
            border-radius: 5px;
            overflow: hidden;
            margin: 8px 0;
        }
        .stat-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #10B981, #F59E0B);
            border-radius: 5px;
        }

        /* Modal Confirmation Élégante (Alternative à window.confirm) */
        .confirm-modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.65);
            backdrop-filter: blur(5px);
            -webkit-backdrop-filter: blur(5px);
            z-index: 99999;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            animation: confirmFadeIn 0.2s ease-out forwards;
        }
        .confirm-modal-box {
            background: #FFFFFF;
            border-radius: 14px;
            box-shadow: 0 25px 50px -12px rgba(15, 23, 42, 0.35), 0 0 0 1px rgba(0, 0, 0, 0.05);
            width: 100%;
            max-width: 440px;
            padding: 28px 24px;
            text-align: center;
            transform: scale(0.94);
            animation: confirmPopIn 0.25s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }
        .confirm-modal-icon-wrap {
            width: 56px;
            height: 56px;
            margin: 0 auto 16px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            background: #FEF2F2;
            color: #DC2626;
            border: 2px solid #FEE2E2;
        }
        .confirm-modal-icon-wrap.warning {
            background: #FFFBEB;
            color: #D97706;
            border-color: #FEF3C7;
        }
        .confirm-modal-title {
            font-size: 18px;
            font-weight: 800;
            color: var(--navy-primary);
            margin: 0 0 8px;
        }
        .confirm-modal-desc {
            font-size: 13.5px;
            color: var(--text-muted);
            line-height: 1.55;
            margin: 0 0 24px;
        }
        .confirm-modal-actions {
            display: flex;
            justify-content: center;
            gap: 12px;
        }
        .confirm-modal-actions .btn {
            padding: 10px 22px;
            font-size: 13px;
            font-weight: 700;
            border-radius: 6px;
            min-width: 120px;
            cursor: pointer;
        }
        .btn-danger-confirm {
            background: #DC2626 !important;
            color: #FFFFFF !important;
            border: 1px solid #DC2626 !important;
        }
        .btn-danger-confirm:hover {
            background: #B91C1C !important;
            border-color: #B91C1C !important;
        }
        .btn-warning-confirm {
            background: #D97706 !important;
            color: #FFFFFF !important;
            border: 1px solid #D97706 !important;
        }
        .btn-warning-confirm:hover {
            background: #B45309 !important;
            border-color: #B45309 !important;
        }
        @keyframes confirmFadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        @keyframes confirmPopIn {
            from { opacity: 0; transform: scale(0.92); }
            to { opacity: 1; transform: scale(1); }
        }

        /* Floating Toast Notification */
        .toast-notification {
            position: fixed;
            top: 24px;
            right: 24px;
            background: #0F172A;
            color: #FFFFFF;
            padding: 14px 20px;
            border-radius: 8px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.3), 0 8px 10px -6px rgba(0, 0, 0, 0.2);
            display: flex;
            align-items: center;
            gap: 12px;
            z-index: 99999;
            font-size: 13.5px;
            font-weight: 600;
            border-left: 4px solid #10B981;
            animation: toastSlideIn 0.35s cubic-bezier(0.16, 1, 0.3, 1) forwards;
            transition: all 0.4s ease;
        }
        .toast-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 24px;
            height: 24px;
            background: rgba(16, 185, 129, 0.2);
            color: #10B981;
            border-radius: 50%;
            font-size: 14px;
            font-weight: bold;
        }
        .toast-close {
            background: none;
            border: none;
            color: #94A3B8;
            font-size: 18px;
            cursor: pointer;
            margin-left: 12px;
            padding: 0;
            line-height: 1;
        }
        .toast-close:hover {
            color: #FFFFFF;
        }
        @keyframes toastSlideIn {
            from {
                opacity: 0;
                transform: translateY(-20px) scale(0.95);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }
        .toast-fade-out {
            opacity: 0;
            transform: translateY(-15px) scale(0.95);
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
                <div class="page-header" style="margin-bottom: 25px;">
                    <div>
                        <span class="eyebrow">Administration Système · CDC §5.1</span>
                        <% if ("params".equals(activeTab)) { %>
                            <h1 class="page-title">Paramétrage Institutionnel</h1>
                            <p class="page-sub">
                                Configuration générale, identité officielle du laboratoire (CDC §4.1) et règles applicatives.
                            </p>
                        <% } else if ("maintenance".equals(activeTab)) { %>
                            <h1 class="page-title">Maintenance & Diagnostics</h1>
                            <p class="page-sub">
                                Supervision des ressources JVM, connectivité MySQL et plan de sauvegarde relationnelle.
                            </p>
                        <% } else { %>
                            <h1 class="page-title">Comptes Utilisateurs & Contrôle d'Accès</h1>
                            <p class="page-sub">
                                Gestion centralisée des identités (RBAC), attribution des rôles statutaires et activation des comptes.
                            </p>
                        <% } %>
                    </div>
                    <% if ("users".equals(activeTab)) { %>
                        <button type="button" class="btn btn-primary" onclick="document.getElementById('modalUser').style.display='flex'">
                            + Nouvel Utilisateur
                        </button>
                    <% } else if ("maintenance".equals(activeTab)) { %>
                        <a href="<%= request.getContextPath() %>/admin?action=exportBackup" class="btn btn-primary">
                            ⬇ Télécharger Sauvegarde SQL (.sql)
                        </a>
                    <% } %>
                </div>

                <% if ("updated".equals(msg)) { %>
                    <div id="toastSuccess" class="toast-notification">
                        <span class="toast-icon">✓</span>
                        <span>Opération enregistrée avec succès.</span>
                        <button type="button" class="toast-close" onclick="closeToast()">&times;</button>
                    </div>
                <% } %>

                <!-- ============================================================== -->
                <!-- ONGLET 1 : COMPTES UTILISATEURS (CDC §5.1)                     -->
                <!-- ============================================================== -->
                <% if ("users".equals(activeTab)) { %>
                    <!-- Stat Cards -->
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 16px; margin-bottom: 25px;">
                        <div class="card" style="padding: 18px 22px;">
                            <div style="font-size: 11px; text-transform: uppercase; color: var(--text-muted); font-weight: 700; letter-spacing: 0.5px;">Total Comptes</div>
                            <div style="font-size: 26px; font-weight: 800; color: var(--navy-primary); margin-top: 4px;"><%= totalUsers %></div>
                            <div style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">Identifiants inscrits</div>
                        </div>
                        <div class="card" style="padding: 18px 22px;">
                            <div style="font-size: 11px; text-transform: uppercase; color: var(--text-muted); font-weight: 700; letter-spacing: 0.5px;">Comptes Actifs</div>
                            <div style="font-size: 26px; font-weight: 800; color: #10B981; margin-top: 4px;"><%= activeUsers %></div>
                            <div style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">Accès autorisés</div>
                        </div>
                        <div class="card" style="padding: 18px 22px;">
                            <div style="font-size: 11px; text-transform: uppercase; color: var(--text-muted); font-weight: 700; letter-spacing: 0.5px;">Chercheurs & Direction</div>
                            <div style="font-size: 26px; font-weight: 800; color: var(--gold-accent); margin-top: 4px;"><%= researcherCount %></div>
                            <div style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">Membres du laboratoire</div>
                        </div>
                        <div class="card" style="padding: 18px 22px;">
                            <div style="font-size: 11px; text-transform: uppercase; color: var(--text-muted); font-weight: 700; letter-spacing: 0.5px;">Administrateurs</div>
                            <div style="font-size: 26px; font-weight: 800; color: #EF4444; margin-top: 4px;"><%= adminCount %></div>
                            <div style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">Super-utilisateurs système</div>
                        </div>
                    </div>

                    <!-- Table des Utilisateurs -->
                    <div class="card">
                        <div class="card-header" style="padding: 18px 24px; border-bottom: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center;">
                            <h3 style="font-size: 17px; font-weight: 800; color: var(--navy-primary); margin: 0;">Liste des Utilisateurs & Rôles Applicatifs</h3>
                            <span style="font-size: 12px; color: var(--text-muted);"><%= totalUsers %> comptes</span>
                        </div>
                        <div class="table-container" style="overflow-x: auto;">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Utilisateur & Contact</th>
                                        <th>Rôle Statutaire</th>
                                        <th>Statut du Compte</th>
                                        <th style="text-align: right;">Actions Administrateur</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (users != null && !users.isEmpty()) { 
                                        for (User u : users) { 
                                            boolean isSelf = (currentAdmin != null && u.getId().equals(currentAdmin.getId()));
                                            String roleColor = "#1B365D";
                                            if ("admin".equalsIgnoreCase(u.getRole())) roleColor = "#EF4444";
                                            else if ("directeur".equalsIgnoreCase(u.getRole())) roleColor = "#B89255";
                                            else if ("permanent".equalsIgnoreCase(u.getRole())) roleColor = "#059669";
                                            else if ("doctorant".equalsIgnoreCase(u.getRole())) roleColor = "#7C3AED";
                                    %>
                                        <tr>
                                            <td style="font-family: var(--font-mono); font-size: 12px; color: var(--text-muted);">#<%= u.getId() %></td>
                                            <td>
                                                <div style="font-weight: 700; color: var(--navy-primary); font-size: 13.5px;"><%= u.getPrenom() %> <%= u.getNom() %></div>
                                                <div style="font-size: 12px; color: var(--text-muted);"><%= u.getEmail() %></div>
                                            </td>
                                            <td>
                                                <form action="<%= request.getContextPath() %>/admin" method="POST" style="margin: 0; display: inline-block;">
                                                    <input type="hidden" name="action" value="changeRole">
                                                    <input type="hidden" name="id" value="<%= u.getId() %>">
                                                    <select name="role" onchange="this.form.submit()" <%= isSelf ? "disabled" : "" %> 
                                                            style="font-size: 11.5px; font-weight: 700; padding: 4px 8px; border-radius: 4px; border: 1px solid var(--border-dark); background: #FFF; color: <%= roleColor %>;">
                                                        <option value="visiteur" <%= "visiteur".equalsIgnoreCase(u.getRole()) ? "selected" : "" %>>Visiteur</option>
                                                        <option value="doctorant" <%= "doctorant".equalsIgnoreCase(u.getRole()) ? "selected" : "" %>>Doctorant</option>
                                                        <option value="associe" <%= "associe".equalsIgnoreCase(u.getRole()) ? "selected" : "" %>>Associé</option>
                                                        <option value="permanent" <%= "permanent".equalsIgnoreCase(u.getRole()) ? "selected" : "" %>>Permanent</option>
                                                        <option value="directeur" <%= "directeur".equalsIgnoreCase(u.getRole()) ? "selected" : "" %>>Directeur</option>
                                                        <option value="admin" <%= "admin".equalsIgnoreCase(u.getRole()) ? "selected" : "" %>>Admin Système</option>
                                                    </select>
                                                </form>
                                            </td>
                                            <td>
                                                <% if (u.isActif()) { %>
                                                    <span class="badge" style="background:#ECFDF5; color:#059669; border:1px solid #A7F3D0; font-size:11px; padding:3px 8px;">Actif</span>
                                                <% } else { %>
                                                    <span class="badge" style="background:#FEF2F2; color:#DC2626; border:1px solid #FECACA; font-size:11px; padding:3px 8px;">Gelé / Inactif</span>
                                                <% } %>
                                            </td>
                                            <td style="text-align: right; white-space: nowrap;">
                                                <% if (!isSelf) { %>
                                                    <form action="<%= request.getContextPath() %>/admin" method="POST" style="display: inline-block; margin: 0 4px;">
                                                        <input type="hidden" name="action" value="toggleActif">
                                                        <input type="hidden" name="id" value="<%= u.getId() %>">
                                                        <% if (u.isActif()) { %>
                                                            <button type="button" class="btn btn-secondary" style="font-size: 11.5px; padding: 4px 10px; color: #EF4444; border-color: #FCA5A5;" 
                                                                    onclick="confirmSuspendUser(this.form, '<%= u.getPrenom() %> <%= u.getNom() %>')">
                                                                Suspendre
                                                            </button>
                                                        <% } else { %>
                                                            <button type="submit" class="btn btn-secondary" style="font-size: 11.5px; padding: 4px 10px; color: #10B981; border-color: #A7F3D0;">
                                                                Réactiver
                                                            </button>
                                                        <% } %>
                                                    </form>
                                                    
                                                    <button type="button" class="btn btn-secondary" style="font-size: 11.5px; padding: 4px 10px; color: var(--navy-primary);"
                                                            onclick="openResetModal('<%= u.getId() %>', '<%= u.getPrenom() %> <%= u.getNom() %>')">
                                                        🔑 Reset MDP
                                                    </button>
                                                <% } else { %>
                                                    <span style="font-size: 12px; color: var(--text-muted); font-style: italic;">Votre compte</span>
                                                <% } %>
                                            </td>
                                        </tr>
                                    <%  } 
                                    } else { %>
                                        <tr>
                                            <td colspan="5" style="text-align: center; padding: 40px; color: var(--text-muted);">
                                                Aucun utilisateur trouvé.
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                <% } %>

                <!-- ============================================================== -->
                <!-- ONGLET 2 : PARAMÉTRAGE DU SYSTÈME (CDC §4.1 & §5.1)            -->
                <!-- ============================================================== -->
                <% if ("params".equals(activeTab)) { %>
                    <div style="max-width: 820px; margin: 0 auto;">
                        <div class="card" style="padding: 28px;">
                            <h3 style="font-size: 18px; font-weight: 800; color: var(--navy-primary); margin-bottom: 6px;">
                                🏛️ Identité Institutionnelle du Laboratoire (CDC §4.1)
                            </h3>
                            <p style="font-size: 13px; color: var(--text-muted); margin-bottom: 24px;">
                                Configuration générale et paramètres de la plateforme du laboratoire LIAS.
                            </p>

                            <form action="<%= request.getContextPath() %>/admin" method="POST">
                                <input type="hidden" name="action" value="updateParams">

                                <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 16px; margin-bottom: 16px;">
                                    <div class="form-group">
                                        <label class="form-label" style="font-weight:700; font-size:12px;">Code Labo *</label>
                                        <input type="text" name="code" class="form-control" value="<%= labInfo.getCode() %>" required>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" style="font-weight:700; font-size:12px;">Date de Création Officielle (CDC §4.1) *</label>
                                        <input type="date" name="dateCreation" class="form-control" value="<%= labInfo.getDateCreation() %>" required>
                                    </div>
                                </div>

                                <div class="form-group" style="margin-bottom: 16px;">
                                    <label class="form-label" style="font-weight:700; font-size:12px;">Désignation Complète *</label>
                                    <input type="text" name="nomComplet" class="form-control" value="<%= labInfo.getNomComplet() %>" required>
                                </div>

                                <div class="form-group" style="margin-bottom: 16px;">
                                    <label class="form-label" style="font-weight:700; font-size:12px;">Établissement de Rattachement *</label>
                                    <input type="text" name="etablissement" class="form-control" value="<%= labInfo.getEtablissement() %>" required>
                                </div>

                                <div class="form-group" style="margin-bottom: 24px;">
                                    <label class="form-label" style="font-weight:700; font-size:12px;">Université de Tutelle *</label>
                                    <input type="text" name="universite" class="form-control" value="<%= labInfo.getUniversite() %>" required>
                                </div>

                                <h4 style="font-size: 15px; font-weight: 800; color: var(--navy-primary); margin: 24px 0 14px; border-top: 1px solid var(--border-color); padding-top: 18px;">
                                    ⚙️ Règles des Flux Applicatifs
                                </h4>

                                <div class="form-group" style="margin-bottom: 16px;">
                                    <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; font-size: 13.5px; font-weight: 600;">
                                        <input type="checkbox" name="campagneAdhesion" value="true" <%= labInfo.isCampagneAdhesionOuverte() ? "checked" : "" %> style="width: 18px; height: 18px;">
                                        Campagne d'adhésion ouverte (Autoriser les candidatures en ligne des visiteurs)
                                    </label>
                                    <div style="font-size: 12px; color: var(--text-muted); margin-left: 28px; margin-top: 4px;">
                                        Si désactivé, le formulaire d'adhésion public affichera une notification de clôture temporaire.
                                    </div>
                                </div>

                                <div class="form-group" style="margin-bottom: 28px;">
                                    <label class="form-label" style="font-weight:700; font-size:12px;">Quota de Taille Maximale d'Upload (Mo)</label>
                                    <input type="number" name="maxUploadMB" class="form-control" value="<%= labInfo.getMaxUploadMB() %>" min="1" max="100" style="max-width: 160px;">
                                </div>

                                <div style="display: flex; justify-content: flex-end;">
                                    <button type="submit" class="btn btn-primary" style="padding: 10px 24px; font-size: 14px;">
                                        💾 Enregistrer le Paramétrage
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                <% } %>

                <!-- ============================================================== -->
                <!-- ONGLET 3 : MAINTENANCE & DIAGNOSTICS (CDC §5.1)                -->
                <!-- ============================================================== -->
                <% if ("maintenance".equals(activeTab)) { %>
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin-bottom: 25px;">
                        
                        <!-- État MySQL -->
                        <div class="card" style="padding: 22px;">
                            <div style="display:flex; justify-content:space-between; align-items:center;">
                                <div style="font-size: 11px; text-transform: uppercase; color: var(--text-muted); font-weight: 700;">Connecteur Base de Données</div>
                                <% if (isDbConnected) { %>
                                    <span class="badge" style="background:#ECFDF5; color:#059669; font-size:11px; padding:3px 8px;">Connecté (Online)</span>
                                <% } else { %>
                                    <span class="badge" style="background:#FEF2F2; color:#DC2626; font-size:11px; padding:3px 8px;">Hors Ligne (Offline)</span>
                                <% } %>
                            </div>
                            <div style="font-size: 24px; font-weight: 800; color: var(--navy-primary); margin-top: 8px;">
                                MySQL 8.0 · InnoDB
                            </div>
                            <div style="font-size: 12px; color: var(--text-muted); margin-top: 6px;">
                                Latence du Ping JDBC : <strong><%= dbLatency %> ms</strong>
                            </div>
                            <div style="font-size: 11.5px; color: var(--text-muted); margin-top: 4px; font-family: var(--font-mono);">
                                URL : jdbc:mysql://db:3306/lias_db
                            </div>
                        </div>

                        <!-- État Mémoire JVM -->
                        <div class="card" style="padding: 22px;">
                            <div style="font-size: 11px; text-transform: uppercase; color: var(--text-muted); font-weight: 700;">Mémoire Vive JVM (Java Virtual Machine)</div>
                            <div style="font-size: 24px; font-weight: 800; color: var(--navy-primary); margin-top: 8px;">
                                <%= jvmUsed %> Mo <span style="font-size: 14px; font-weight: 500; color: var(--text-muted);">/ <%= jvmMax %> Mo max</span>
                            </div>
                            <div class="stat-bar-container">
                                <div class="stat-bar-fill" style="width: <%= Math.min(jvmPercent, 100) %>%;"></div>
                            </div>
                            <div style="display:flex; justify-content:space-between; font-size: 11.5px; color: var(--text-muted);">
                                <span>Utilisation : <strong><%= jvmPercent %>%</strong></span>
                                <span>Total Alloué : <%= request.getAttribute("jvmTotalMemory") %> Mo</span>
                            </div>
                        </div>

                        <!-- Environnement d'Exécution -->
                        <div class="card" style="padding: 22px;">
                            <div style="font-size: 11px; text-transform: uppercase; color: var(--text-muted); font-weight: 700;">Conteneur d'Application</div>
                            <div style="font-size: 20px; font-weight: 800; color: var(--navy-primary); margin-top: 8px;">
                                <%= request.getAttribute("serverInfo") %>
                            </div>
                            <div style="font-size: 12px; color: var(--text-muted); margin-top: 6px;">
                                Runtime : <strong>Java <%= request.getAttribute("javaVersion") %></strong>
                            </div>
                            <div style="font-size: 11.5px; color: var(--text-muted); margin-top: 4px;">
                                Système : <%= request.getAttribute("osName") %>
                            </div>
                        </div>

                    </div>

                    <!-- Actions de Maintenance et Sécurité -->
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px;">
                        
                        <!-- Sauvegarde et Export SQL -->
                        <div class="card" style="padding: 24px;">
                            <h3 style="font-size: 17px; font-weight: 800; color: var(--navy-primary); margin-bottom: 6px;">
                                📦 Sauvegarde & Plan de Continuité (DRP)
                            </h3>
                            <p style="font-size: 12.5px; color: var(--text-muted); margin-bottom: 16px;">
                                Génère un instantané complet de la structure du schéma relationnel (3NF) et des jeux de données d'initialisation pour archivage ou migration.
                            </p>
                            <a href="<%= request.getContextPath() %>/admin?action=exportBackup" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px;">
                                <span>⬇ Télécharger le Dump SQL (.sql)</span>
                            </a>
                        </div>

                        <!-- Mode Maintenance Applicatif -->
                        <div class="card" style="padding: 24px; display: flex; flex-direction: column; justify-content: space-between;">
                            <div>
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                                    <h3 style="font-size: 17px; font-weight: 800; color: var(--navy-primary); margin: 0;">
                                        <i class="fa-solid fa-shield-halved" style="margin-right: 6px; color: <%= isMaintenance ? "#DC2626" : "#059669" %>;"></i>
                                        Mode Maintenance & Accès
                                    </h3>
                                    <% if (isMaintenance) { %>
                                        <span class="badge" style="background: #FEF2F2; color: #DC2626; border: 1px solid #FECACA; font-size: 11px; padding: 4px 10px; font-weight: 700;">
                                            ● ACTIF (Restreint)
                                        </span>
                                    <% } else { %>
                                        <span class="badge" style="background: #ECFDF5; color: #059669; border: 1px solid #A7F3D0; font-size: 11px; padding: 4px 10px; font-weight: 700;">
                                            ● EN LIGNE (Normal)
                                        </span>
                                    <% } %>
                                </div>
                                <p style="font-size: 13px; color: var(--text-muted); line-height: 1.5; margin-bottom: 20px;">
                                    <% if (isMaintenance) { %>
                                        La plateforme est actuellement verrouillée. Les usagers non-administrateurs reçoivent une page de coupure programmée (HTTP 503 Service Unavailable).
                                    <% } else { %>
                                        Tous les modules applicatifs et flux documentaires sont opérationnels pour les chercheurs, doctorants et visiteurs.
                                    <% } %>
                                </p>
                            </div>

                            <form action="<%= request.getContextPath() %>/admin" method="POST" style="margin: 0;">
                                <input type="hidden" name="action" value="toggleMaintenance">
                                <% if (isMaintenance) { %>
                                    <button type="submit" class="btn btn-secondary" style="border-color: #10B981; color: #059669; font-weight: 700; width: 100%; justify-content: center; padding: 10px;">
                                        <i class="fa-solid fa-lock-open" style="margin-right: 6px;"></i> Réouvrir la Plateforme au Public
                                    </button>
                                <% } else { %>
                                    <button type="button" class="btn btn-secondary" style="border-color: #FCA5A5; color: #DC2626; font-weight: 700; width: 100%; justify-content: center; padding: 10px;" 
                                            onclick="confirmMaintenanceToggle(this.form)">
                                        <i class="fa-solid fa-triangle-exclamation" style="margin-right: 6px;"></i> Activer le Mode Maintenance
                                    </button>
                                <% } %>
                            </form>
                        </div>

                    </div>
                <% } %>

            </div>
        </main>
    </div>
</div>

<!-- Modal Nouvel Utilisateur -->
<div id="modalUser" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.55); z-index:9999; align-items:center; justify-content:center; backdrop-filter:blur(3px);">
    <div class="card" style="width: 100%; max-width: 520px; padding: 28px; background: #FFF; border-radius: 8px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.2);">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 20px;">
            <h3 style="margin:0; font-size: 18px; font-weight: 800; color: var(--navy-primary);">Créer un Nouveau Compte Utilisateur</h3>
            <button type="button" onclick="document.getElementById('modalUser').style.display='none'" style="background:none; border:none; font-size:22px; cursor:pointer; color:var(--text-muted);">&times;</button>
        </div>

        <form action="<%= request.getContextPath() %>/admin" method="POST">
            <input type="hidden" name="action" value="create">

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 14px;">
                <div class="form-group">
                    <label class="form-label" style="font-weight:700; font-size:12px;">Nom *</label>
                    <input type="text" name="nom" class="form-control" placeholder="ex: Bennani" required>
                </div>
                <div class="form-group">
                    <label class="form-label" style="font-weight:700; font-size:12px;">Prénom *</label>
                    <input type="text" name="prenom" class="form-control" placeholder="ex: Salma" required>
                </div>
            </div>

            <div class="form-group" style="margin-bottom: 14px;">
                <label class="form-label" style="font-weight:700; font-size:12px;">Adresse Email Institutionnelle *</label>
                <input type="email" name="email" class="form-control" placeholder="ex: salma.bennani@lias.ma" required>
            </div>

            <div class="form-group" style="margin-bottom: 14px;">
                <label class="form-label" style="font-weight:700; font-size:12px;">Mot de Passe Initial *</label>
                <input type="password" name="password" class="form-control" placeholder="Mot de passe sécurisé" required>
            </div>

            <div class="form-group" style="margin-bottom: 22px;">
                <label class="form-label" style="font-weight:700; font-size:12px;">Rôle Attribué</label>
                <select name="role" class="form-control">
                    <option value="visiteur">Visiteur</option>
                    <option value="doctorant">Doctorant</option>
                    <option value="associe">Membre Associé</option>
                    <option value="permanent">Membre Permanent</option>
                    <option value="directeur">Directeur</option>
                    <option value="admin">Administrateur Système</option>
                </select>
            </div>

            <div style="display:flex; justify-content:flex-end; gap:10px;">
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('modalUser').style.display='none'">Annuler</button>
                <button type="submit" class="btn btn-primary">Créer l'utilisateur</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Reset Password -->
<div id="modalResetPassword" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.55); z-index:9999; align-items:center; justify-content:center; backdrop-filter:blur(3px);">
    <div class="card" style="width: 100%; max-width: 440px; padding: 26px; background: #FFF; border-radius: 8px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.2);">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 16px;">
            <h3 style="margin:0; font-size: 17px; font-weight: 800; color: var(--navy-primary);">Réinitialiser le Mot de Passe</h3>
            <button type="button" onclick="document.getElementById('modalResetPassword').style.display='none'" style="background:none; border:none; font-size:22px; cursor:pointer; color:var(--text-muted);">&times;</button>
        </div>

        <form action="<%= request.getContextPath() %>/admin" method="POST">
            <input type="hidden" name="action" value="resetPassword">
            <input type="hidden" name="id" id="resetUserId" value="">

            <p style="font-size: 13px; color: var(--text-secondary); margin-bottom: 14px;">
                Utilisateur ciblé : <strong id="resetUserName" style="color: var(--navy-primary);"></strong>
            </p>

            <div class="form-group" style="margin-bottom: 20px;">
                <label class="form-label" style="font-weight:700; font-size:12px;">Nouveau Mot de Passe Temporaire *</label>
                <input type="password" name="newPassword" class="form-control" placeholder="Saisir le nouveau mot de passe" required>
            </div>

            <div style="display:flex; justify-content:flex-end; gap:10px;">
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('modalResetPassword').style.display='none'">Annuler</button>
                <button type="submit" class="btn btn-primary">Valider la réinitialisation</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Confirmation Élégante (Alternative moderne à window.confirm) -->
<div id="modalConfirm" class="confirm-modal-overlay" style="display:none;" onclick="handleConfirmOverlayClick(event)">
    <div class="confirm-modal-box">
        <div class="confirm-modal-icon-wrap warning" id="confirmIconWrap">
            <i class="fa-solid fa-triangle-exclamation" id="confirmIcon"></i>
        </div>
        <div class="confirm-modal-content">
            <h3 class="confirm-modal-title" id="confirmTitle">Confirmation</h3>
            <p class="confirm-modal-desc" id="confirmMessage">Êtes-vous sûr de vouloir continuer ?</p>
        </div>
        <div class="confirm-modal-actions">
            <button type="button" class="btn btn-secondary" onclick="closeConfirmModal()">Annuler</button>
            <button type="button" class="btn btn-warning-confirm" id="confirmBtnAction" onclick="executeConfirmAction()">Confirmer</button>
        </div>
    </div>
</div>

<script>
let pendingConfirmAction = null;

function showConfirmDialog(options) {
    document.getElementById('confirmTitle').innerText = options.title || 'Confirmation';
    document.getElementById('confirmMessage').innerText = options.message || 'Êtes-vous sûr de vouloir continuer ?';
    
    const iconWrap = document.getElementById('confirmIconWrap');
    const icon = document.getElementById('confirmIcon');
    const confirmBtn = document.getElementById('confirmBtnAction');
    
    if (options.type === 'danger') {
        iconWrap.className = 'confirm-modal-icon-wrap';
        icon.className = 'fa-solid fa-circle-exclamation';
        confirmBtn.className = 'btn btn-danger-confirm';
    } else {
        iconWrap.className = 'confirm-modal-icon-wrap warning';
        icon.className = 'fa-solid fa-triangle-exclamation';
        confirmBtn.className = 'btn btn-warning-confirm';
    }
    
    confirmBtn.innerText = options.confirmText || 'Confirmer';
    pendingConfirmAction = options.onConfirm;
    
    document.getElementById('modalConfirm').style.display = 'flex';
}

function closeConfirmModal() {
    const modal = document.getElementById('modalConfirm');
    if (modal) {
        modal.style.display = 'none';
        pendingConfirmAction = null;
    }
}

function handleConfirmOverlayClick(event) {
    if (event.target.id === 'modalConfirm') {
        closeConfirmModal();
    }
}

function executeConfirmAction() {
    if (typeof pendingConfirmAction === 'function') {
        const action = pendingConfirmAction;
        closeConfirmModal();
        action();
    } else {
        closeConfirmModal();
    }
}

function confirmMaintenanceToggle(form) {
    showConfirmDialog({
        title: 'Activer le Mode Maintenance ?',
        message: 'Cette action restreint temporairement l\'accès de la plateforme aux administrateurs pendant vos opérations techniques. Les usagers recevront un écran de coupure (HTTP 503).',
        type: 'warning',
        confirmText: 'Activer la Maintenance',
        onConfirm: function() {
            form.submit();
        }
    });
}

function confirmSuspendUser(form, userName) {
    showConfirmDialog({
        title: 'Suspendre le Compte ?',
        message: 'Voulez-vous vraiment suspendre l\'accès de ' + userName + ' ? Le compte sera gelé et ne pourra plus s\'authentifier sur la plateforme.',
        type: 'danger',
        confirmText: 'Suspendre le Compte',
        onConfirm: function() {
            form.submit();
        }
    });
}

function openResetModal(userId, userName) {
    document.getElementById('resetUserId').value = userId;
    document.getElementById('resetUserName').innerText = userName;
    document.getElementById('modalResetPassword').style.display = 'flex';
}

function closeToast() {
    const toast = document.getElementById('toastSuccess');
    if (toast) {
        toast.classList.add('toast-fade-out');
        setTimeout(() => {
            toast.remove();
        }, 400);
    }
}

// Auto-dismiss après 3 secondes et nettoyage automatique de l'URL
document.addEventListener('DOMContentLoaded', function() {
    const toast = document.getElementById('toastSuccess');
    if (toast) {
        if (window.history && window.history.replaceState) {
            const url = new URL(window.location);
            url.searchParams.delete('success');
            window.history.replaceState({}, document.title, url.toString());
        }
        setTimeout(closeToast, 3000);
    }
});

// Échappement clavier pour fermer les modales
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeConfirmModal();
        const mUser = document.getElementById('modalUser');
        if (mUser) mUser.style.display = 'none';
        const mReset = document.getElementById('modalResetPassword');
        if (mReset) mReset.style.display = 'none';
    }
});
</script>

</body>
</html>
