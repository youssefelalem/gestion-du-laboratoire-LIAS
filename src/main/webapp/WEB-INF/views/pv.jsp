<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.lias.beans.ReunionPV"%>
<%@ page import="com.lias.beans.User"%>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) currentUser = (User) session.getAttribute("user");
    boolean canManage = (currentUser != null && ("directeur".equalsIgnoreCase(currentUser.getRole()) || "permanent".equalsIgnoreCase(currentUser.getRole()) || "admin".equalsIgnoreCase(currentUser.getRole())));

    List<ReunionPV> pvs = (List<ReunionPV>) request.getAttribute("pvs");
    String msg = request.getParameter("success");

    int totalCount = (pvs != null) ? pvs.size() : 0;
    ReunionPV latestPV = (pvs != null && !pvs.isEmpty()) ? pvs.get(0) : null;
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS — Procès-Verbaux de Réunions</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=4">
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
                        <span class="eyebrow">Documentation & Mémoire Institutionnelle</span>
                        <h1 class="page-title">Procès-Verbaux de Réunions (PV)</h1>
                        <p class="page-sub">
                            Registre officiel des procès-verbaux, délibérations statutaires et décisions prises lors des conseils de laboratoire et assemblées générales du LIAS.
                        </p>
                    </div>
                    <% if (canManage) { %>
                        <button type="button" class="btn btn-primary" onclick="document.getElementById('modalPV').style.display='flex'">
                            + Consigner un PV
                        </button>
                    <% } %>
                </div>

                <% if ("created".equals(msg)) { %>
                    <div class="alert alert-success" style="background:#ECFDF5; border-right:4px solid #059669; padding:12px 18px; border-radius:4px; margin-bottom:20px; color:#065F46; font-size:13.5px;">
                        ✓ Le procès-verbal de réunion a été archivé avec succès dans le registre officiel.
                    </div>
                <% } %>

                <!-- Stat Cards -->
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 16px; margin-bottom: 25px;">
                    <div class="card" style="padding: 18px 22px;">
                        <div style="font-size: 11px; text-transform: uppercase; color: var(--text-muted); font-weight: 700; letter-spacing: 0.5px;">Total Délibérations</div>
                        <div style="font-size: 26px; font-weight: 800; color: var(--navy-primary); margin-top: 4px;"><%= totalCount %></div>
                        <div style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">PVs consignés au registre</div>
                    </div>
                    <div class="card" style="padding: 18px 22px;">
                        <div style="font-size: 11px; text-transform: uppercase; color: var(--text-muted); font-weight: 700; letter-spacing: 0.5px;">Dernier Conseil</div>
                        <div style="font-size: 20px; font-weight: 800; color: #10B981; margin-top: 8px; font-family: monospace;">
                            <%= latestPV != null ? latestPV.getDateReunion() : "Aucune date" %>
                        </div>
                        <div style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">Dernière session tenue</div>
                    </div>
                    <div class="card" style="padding: 18px 22px;">
                        <div style="font-size: 11px; text-transform: uppercase; color: var(--text-muted); font-weight: 700; letter-spacing: 0.5px;">Garantie Institutionnelle</div>
                        <div style="font-size: 15px; font-weight: 700; color: var(--navy-primary); margin-top: 8px;">
                            Signatures validées
                        </div>
                        <div style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">Approbation Direction du Laboratoire</div>
                    </div>
                    <div class="card" style="padding: 18px 22px;">
                        <div style="font-size: 11px; text-transform: uppercase; color: var(--text-muted); font-weight: 700; letter-spacing: 0.5px;">Format d'Archivage</div>
                        <div style="font-size: 15px; font-weight: 700; color: var(--gold-accent); margin-top: 8px;">
                            Numérique & Certifié
                        </div>
                        <div style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">Conforme aux normes FSBM</div>
                    </div>
                </div>

                <!-- Table des PV -->
                <div class="card">
                    <div class="card-header" style="padding: 18px 24px; border-bottom: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center;">
                        <h3 style="font-size: 17px; font-weight: 800; color: var(--navy-primary); margin: 0;">Registre des Procès-Verbaux Officiels</h3>
                        <span style="font-size: 12px; color: var(--text-muted);"><%= totalCount %> séances documentées</span>
                    </div>
                    <div class="table-container" style="overflow-x: auto;">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Titre de la Séance</th>
                                    <th>Date de Réunion</th>
                                    <th>Ordre du Jour & Décisions</th>
                                    <th>Directeur Signataire</th>
                                    <th>Document PDF</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (pvs != null && !pvs.isEmpty()) { 
                                    for (ReunionPV pv : pvs) { %>
                                    <tr>
                                        <td>
                                            <strong style="color: var(--navy-primary); font-size: 14.5px;"><%= pv.getTitre() %></strong>
                                        </td>
                                        <td style="font-family: monospace; font-size: 13.5px; white-space: nowrap;">
                                            <%= pv.getDateReunion() %>
                                        </td>
                                        <td style="max-width: 380px; font-size: 13px; color: var(--text-color); line-height: 1.5;">
                                            <%= pv.getOrdreDuJour() != null ? pv.getOrdreDuJour() : "—" %>
                                        </td>
                                        <td style="font-weight: 600; font-size: 13.5px; color: var(--navy-primary);">
                                            <%= pv.getDirecteurSignataire() != null ? pv.getDirecteurSignataire() : "Direction LIAS" %>
                                        </td>
                                        <td>
                                            <a href="<%= request.getContextPath() %>/<%= pv.getCheminFichierPV() %>" target="_blank" class="chip" style="background: rgba(184,146,85,0.15); color: var(--navy-primary); border: 1px solid var(--gold-accent); text-decoration: none; font-weight: 700; font-size: 11px; display: inline-flex; align-items: center; gap: 6px;">
                                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                                                Consulter PDF
                                            </a>
                                        </td>
                                    </tr>
                                <%  } 
                                } else { %>
                                    <tr>
                                        <td colspan="5" style="text-align: center; padding: 40px; color: var(--text-muted);">
                                            Aucun procès-verbal archivé pour l'instant.
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

<!-- Modal Consigner PV -->
<% if (canManage) { %>
<div id="modalPV" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.55); z-index:9999; align-items:center; justify-content:center; backdrop-filter:blur(3px);">
    <div class="card" style="width: 100%; max-width: 580px; padding: 28px; background: #FFF; border-radius: 8px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.2);">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 20px;">
            <h3 style="margin:0; font-size: 18px; font-weight: 800; color: var(--navy-primary);">Consigner un Procès-Verbal de Réunion</h3>
            <button type="button" onclick="document.getElementById('modalPV').style.display='none'" style="background:none; border:none; font-size:22px; cursor:pointer; color:var(--text-muted);">&times;</button>
        </div>

        <form action="<%= request.getContextPath() %>/pv" method="POST">
            <div class="form-group" style="margin-bottom: 14px;">
                <label class="form-label" style="font-weight:700; font-size:12px;">Titre de la Séance / Réunion *</label>
                <input type="text" name="titre" class="form-control" placeholder="ex: Conseil de Laboratoire - Session Ordinaire Mars 2026" required>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 14px;">
                <div class="form-group">
                    <label class="form-label" style="font-weight:700; font-size:12px;">Date de la Réunion *</label>
                    <input type="date" name="dateReunion" class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label" style="font-weight:700; font-size:12px;">Directeur Signataire</label>
                    <input type="text" name="directeurSignataire" class="form-control" value="Prof. Youssef El Alem" required>
                </div>
            </div>

            <div class="form-group" style="margin-bottom: 14px;">
                <label class="form-label" style="font-weight:700; font-size:12px;">Ordre du Jour & Décisions Validées</label>
                <textarea name="ordreDuJour" class="form-control" rows="4" placeholder="Points abordés, résolutions votées, calendrier scientifique arrêté..."></textarea>
            </div>

            <div class="form-group" style="margin-bottom: 22px;">
                <label class="form-label" style="font-weight:700; font-size:12px;">Chemin / Référence Document Numérique</label>
                <input type="text" name="cheminFichierPV" class="form-control" value="archives/pv_session_mars2026.pdf" placeholder="ex: archives/pv_document.pdf">
            </div>

            <div style="display:flex; justify-content:flex-end; gap:10px;">
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('modalPV').style.display='none'">Annuler</button>
                <button type="submit" class="btn btn-primary">Enregistrer le PV</button>
            </div>
        </form>
    </div>
</div>
<% } %>

</body>
</html>
