<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.lias.beans.User"%>
<%
    User currentAdmin = (User) session.getAttribute("currentUser");
    if (currentAdmin == null) currentAdmin = (User) session.getAttribute("user");

    List<User> users = (List<User>) request.getAttribute("users");
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
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS — Administration & Contrôle d'Accès</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=2">
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
                        <span class="eyebrow">Sécurité & Gouvernance des Accès</span>
                        <h1 class="page-title">Administration des Comptes Utilisateurs</h1>
                        <p class="page-sub">
                            Contrôle d'accès RBAC (Role-Based Access Control), gestion des identifiants, modification des privilèges et verrouillage des accès.
                        </p>
                    </div>
                    <button type="button" class="btn btn-primary" onclick="document.getElementById('modalUser').style.display='flex'">
                        + Nouvel Utilisateur
                    </button>
                </div>

                <% if ("updated".equals(msg)) { %>
                    <div class="alert alert-success" style="background:#ECFDF5; border-right:4px solid #059669; padding:12px 18px; border-radius:4px; margin-bottom:20px; color:#065F46; font-size:13.5px;">
                        ✓ Les modifications du compte utilisateur ont été enregistrées avec succès.
                    </div>
                <% } %>

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
                                        else if ("permanent".equalsIgnoreCase(u.getRole())) roleColor = "#10B981";
                                        else if ("doctorant".equalsIgnoreCase(u.getRole())) roleColor = "#3B82F6";
                                        else if ("associe".equalsIgnoreCase(u.getRole())) roleColor = "#8B5CF6";
                                %>
                                    <tr>
                                        <td style="font-family: monospace; font-size: 12px; color: var(--text-muted);">
                                            #<%= u.getId() %>
                                        </td>
                                        <td>
                                            <div style="font-weight: 700; color: var(--navy-primary); font-size: 14px;">
                                                <%= u.getNom() %> <%= u.getPrenom() %>
                                                <% if (isSelf) { %>
                                                    <span style="font-size: 10px; background: #E0E7FF; color: #3730A3; padding: 2px 6px; border-radius: 3px; font-weight: 700; margin-left: 6px;">VOUS</span>
                                                <% } %>
                                            </div>
                                            <div style="font-size: 12.5px; color: var(--text-muted); font-family: monospace; margin-top: 2px;">
                                                <%= u.getEmail() %>
                                            </div>
                                        </td>
                                        <td>
                                            <form action="<%= request.getContextPath() %>/admin" method="POST" style="margin: 0; display: inline-flex; align-items: center; gap: 6px;">
                                                <input type="hidden" name="action" value="changeRole">
                                                <input type="hidden" name="id" value="<%= u.getId() %>">
                                                <select name="role" onchange="this.form.submit()" style="padding: 4px 8px; font-size: 12px; font-weight: 600; border-radius: 4px; border: 1px solid var(--border-color); background: #FFF; color: <%= roleColor %>;">
                                                    <option value="admin" <%= "admin".equalsIgnoreCase(u.getRole()) ? "selected" : "" %>>Admin</option>
                                                    <option value="directeur" <%= "directeur".equalsIgnoreCase(u.getRole()) ? "selected" : "" %>>Directeur</option>
                                                    <option value="permanent" <%= "permanent".equalsIgnoreCase(u.getRole()) ? "selected" : "" %>>Membre Permanent</option>
                                                    <option value="associe" <%= "associe".equalsIgnoreCase(u.getRole()) ? "selected" : "" %>>Membre Associé</option>
                                                    <option value="doctorant" <%= "doctorant".equalsIgnoreCase(u.getRole()) ? "selected" : "" %>>Doctorant</option>
                                                    <option value="visiteur" <%= "visiteur".equalsIgnoreCase(u.getRole()) ? "selected" : "" %>>Visiteur</option>
                                                </select>
                                            </form>
                                        </td>
                                        <td>
                                            <% if (u.isActif()) { %>
                                                <span class="status-badge" style="background: #10B981; color: #FFF; padding: 3px 8px; border-radius: 4px; font-weight: 700; font-size: 11px;">ACTIF</span>
                                            <% } else { %>
                                                <span class="status-badge" style="background: #EF4444; color: #FFF; padding: 3px 8px; border-radius: 4px; font-weight: 700; font-size: 11px;">SUSPENDU</span>
                                            <% } %>
                                        </td>
                                        <td style="text-align: right;">
                                            <% if (!isSelf) { %>
                                                <form action="<%= request.getContextPath() %>/admin" method="POST" style="display: inline-block; margin: 0;">
                                                    <input type="hidden" name="action" value="toggleActif">
                                                    <input type="hidden" name="id" value="<%= u.getId() %>">
                                                    <% if (u.isActif()) { %>
                                                        <button type="submit" class="btn btn-secondary" style="font-size: 11.5px; padding: 4px 10px; color: #EF4444; border-color: #FCA5A5;" onclick="return confirm('Voulez-vous suspendre l\'accès de cet utilisateur ?');">
                                                            Suspendre
                                                        </button>
                                                    <% } else { %>
                                                        <button type="submit" class="btn btn-secondary" style="font-size: 11.5px; padding: 4px 10px; color: #10B981; border-color: #A7F3D0;">
                                                            Réactiver
                                                        </button>
                                                    <% } %>
                                                </form>
                                            <% } else { %>
                                                <span style="font-size: 12px; color: var(--text-muted); font-style: italic;">Protégé</span>
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
                <input type="email" name="email" class="form-control" placeholder="ex: salma.bennani@univh2c.ma" required>
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

</body>
</html>
