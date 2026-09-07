<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.Locale"%>
<%@ page import="com.lias.beans.Convention"%>
<%@ page import="com.lias.beans.Mandat"%>
<%@ page import="com.lias.beans.User"%>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) currentUser = (User) session.getAttribute("user");
    boolean canManage = (currentUser != null && ("directeur".equalsIgnoreCase(currentUser.getRole()) || "permanent".equalsIgnoreCase(currentUser.getRole()) || "admin".equalsIgnoreCase(currentUser.getRole())));

    List<Convention> conventions = (List<Convention>) request.getAttribute("conventions");
    Mandat mandatActif = (Mandat) request.getAttribute("mandatActif");
    String msg = request.getParameter("success");

    // Calculs de synthèse
    int totalCount = (conventions != null) ? conventions.size() : 0;
    int activeCount = 0;
    BigDecimal totalBudget = BigDecimal.ZERO;
    if (conventions != null) {
        for (Convention c : conventions) {
            if ("Active".equalsIgnoreCase(c.getStatut())) activeCount++;
            if (c.getBudgetAlloue() != null) {
                totalBudget = totalBudget.add(c.getBudgetAlloue());
            }
        }
    }
    NumberFormat currencyFormat = NumberFormat.getInstance(Locale.FRANCE);
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS — Conventions & Partenariats</title>
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
                        <span class="eyebrow">Coopération Scientifique & Rayonnement</span>
                        <h1 class="page-title">Conventions & Partenariats</h1>
                        <p class="page-sub">
                            Accords-cadres bilatéraux, collaborations de recherche industrielle et conventions académiques internationales conclus sous l'égide du LIAS.
                        </p>
                    </div>
                    <% if (canManage) { %>
                        <button type="button" class="btn btn-primary" onclick="document.getElementById('modalConvention').style.display='flex'">
                            + Nouvelle Convention
                        </button>
                    <% } %>
                </div>

                <% if ("created".equals(msg)) { %>
                    <div class="alert alert-success" style="background:#ECFDF5; border-right:4px solid #059669; padding:12px 18px; border-radius:4px; margin-bottom:20px; color:#065F46; font-size:13.5px;">
                        ✓ La convention de partenariat a été enregistrée avec succès.
                    </div>
                <% } %>

                <!-- Stat Cards -->
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 16px; margin-bottom: 25px;">
                    <div class="card" style="padding: 18px 22px;">
                        <div style="font-size: 11px; text-transform: uppercase; color: var(--text-muted); font-weight: 700; letter-spacing: 0.5px;">Total Conventions</div>
                        <div style="font-size: 26px; font-weight: 800; color: var(--navy-primary); margin-top: 4px;"><%= totalCount %></div>
                        <div style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">Accords institutionnels</div>
                    </div>
                    <div class="card" style="padding: 18px 22px;">
                        <div style="font-size: 11px; text-transform: uppercase; color: var(--text-muted); font-weight: 700; letter-spacing: 0.5px;">Conventions Actives</div>
                        <div style="font-size: 26px; font-weight: 800; color: #10B981; margin-top: 4px;"><%= activeCount %></div>
                        <div style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">En cours d'exécution</div>
                    </div>
                    <div class="card" style="padding: 18px 22px;">
                        <div style="font-size: 11px; text-transform: uppercase; color: var(--text-muted); font-weight: 700; letter-spacing: 0.5px;">Budget Mobilisé</div>
                        <div style="font-size: 24px; font-weight: 800; color: var(--gold-accent); margin-top: 4px;"><%= currencyFormat.format(totalBudget) %> <span style="font-size: 14px;">MAD</span></div>
                        <div style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">Fonds de co-financement R&D</div>
                    </div>
                    <div class="card" style="padding: 18px 22px;">
                        <div style="font-size: 11px; text-transform: uppercase; color: var(--text-muted); font-weight: 700; letter-spacing: 0.5px;">Mandat de Rattachement</div>
                        <div style="font-size: 15px; font-weight: 700; color: var(--navy-primary); margin-top: 8px;">
                            <%= mandatActif != null ? mandatActif.getTitre() : "Aucun mandat actif" %>
                        </div>
                        <div style="font-size: 12px; color: var(--text-muted); margin-top: 4px;">Gouvernance actuelle</div>
                    </div>
                </div>

                <!-- Table des Conventions -->
                <div class="card">
                    <div class="card-header" style="padding: 18px 24px; border-bottom: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center;">
                        <h3 style="font-size: 17px; font-weight: 800; color: var(--navy-primary); margin: 0;">Répertoire Officiel des Partenariats</h3>
                        <span style="font-size: 12px; color: var(--text-muted);"><%= totalCount %> partenaires</span>
                    </div>
                    <div class="table-container" style="overflow-x: auto;">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Organisme Partenaire</th>
                                    <th>Typologie</th>
                                    <th>Objet de la Convention</th>
                                    <th>Date Signature</th>
                                    <th>Échéance</th>
                                    <th>Budget R&D</th>
                                    <th>Statut</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (conventions != null && !conventions.isEmpty()) { 
                                    for (Convention c : conventions) { 
                                        String badgeColor = "#10B981";
                                        if ("En négociation".equalsIgnoreCase(c.getStatut())) badgeColor = "#F59E0B";
                                        else if ("Clôturée".equalsIgnoreCase(c.getStatut()) || "Terminée".equalsIgnoreCase(c.getStatut())) badgeColor = "#64748B";
                                %>
                                    <tr>
                                        <td>
                                            <strong style="color: var(--navy-primary); font-size: 14.5px;"><%= c.getOrganismePartenaire() %></strong>
                                        </td>
                                        <td>
                                            <span class="chip" style="font-size: 11px; font-weight: 600;">
                                                <%= c.getTypePartenaire() != null ? c.getTypePartenaire() : "Général" %>
                                            </span>
                                        </td>
                                        <td style="max-width: 320px; font-size: 13.5px; color: var(--text-color);">
                                            <%= c.getObjet() %>
                                        </td>
                                        <td style="font-family: monospace; font-size: 13px;"><%= c.getDateSignature() %></td>
                                        <td style="font-family: monospace; font-size: 13px;">
                                            <%= c.getDateEcheance() != null ? c.getDateEcheance() : "Indéterminée" %>
                                        </td>
                                        <td style="font-weight: 700; color: var(--navy-primary); font-family: monospace;">
                                            <%= c.getBudgetAlloue() != null && c.getBudgetAlloue().compareTo(BigDecimal.ZERO) > 0 ? currencyFormat.format(c.getBudgetAlloue()) + " MAD" : "Sans flux financier" %>
                                        </td>
                                        <td>
                                            <span class="status-badge" style="background: <%= badgeColor %>; color: #FFF; padding: 4px 10px; border-radius: 4px; font-weight: 600; font-size: 11px;">
                                                <%= c.getStatut() %>
                                            </span>
                                        </td>
                                    </tr>
                                <%  } 
                                } else { %>
                                    <tr>
                                        <td colspan="7" style="text-align: center; padding: 40px; color: var(--text-muted);">
                                            Aucune convention de partenariat enregistrée pour l'instant.
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

<!-- Modal Nouvelle Convention -->
<% if (canManage) { %>
<div id="modalConvention" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.55); z-index:9999; align-items:center; justify-content:center; backdrop-filter:blur(3px);">
    <div class="card" style="width: 100%; max-width: 580px; padding: 28px; background: #FFF; border-radius: 8px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.2);">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 20px;">
            <h3 style="margin:0; font-size: 18px; font-weight: 800; color: var(--navy-primary);">Enregistrer une Convention de Partenariat</h3>
            <button type="button" onclick="document.getElementById('modalConvention').style.display='none'" style="background:none; border:none; font-size:22px; cursor:pointer; color:var(--text-muted);">&times;</button>
        </div>

        <form action="<%= request.getContextPath() %>/conventions" method="POST">
            <div class="form-group" style="margin-bottom: 14px;">
                <label class="form-label" style="font-weight:700; font-size:12px;">Organisme Partenaire *</label>
                <input type="text" name="organismePartenaire" class="form-control" placeholder="ex: OCP Group, CNRS, Siemens Digital..." required>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 14px;">
                <div class="form-group">
                    <label class="form-label" style="font-weight:700; font-size:12px;">Typologie du Partenaire</label>
                    <select name="typePartenaire" class="form-control">
                        <option value="Industrie">Entreprise / Industrie</option>
                        <option value="Académique National">Université / Labo Maroc</option>
                        <option value="Académique International">Université Internationale</option>
                        <option value="Institutionnel">Ministère / Établissement Public</option>
                        <option value="Autre">Autre organisme</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label" style="font-weight:700; font-size:12px;">Statut Juridique</label>
                    <select name="statut" class="form-control">
                        <option value="Active">Active</option>
                        <option value="En négociation">En cours de négociation</option>
                        <option value="Clôturée">Clôturée / Expirée</option>
                    </select>
                </div>
            </div>

            <div class="form-group" style="margin-bottom: 14px;">
                <label class="form-label" style="font-weight:700; font-size:12px;">Objet Scientifique & Technique *</label>
                <textarea name="objet" class="form-control" rows="3" placeholder="Description des objectifs de la convention (axes de recherche, thèses CIFRE, mise à disposition de matériel...)" required></textarea>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 14px;">
                <div class="form-group">
                    <label class="form-label" style="font-weight:700; font-size:12px;">Date de Signature *</label>
                    <input type="date" name="dateSignature" class="form-control" required>
                </div>
                <div class="form-group">
                    <label class="form-label" style="font-weight:700; font-size:12px;">Date d'Échéance</label>
                    <input type="date" name="dateEcheance" class="form-control">
                </div>
            </div>

            <div class="form-group" style="margin-bottom: 22px;">
                <label class="form-label" style="font-weight:700; font-size:12px;">Budget Alloué / Financement (MAD)</label>
                <input type="number" step="1000" name="budgetAlloue" class="form-control" placeholder="ex: 350000">
            </div>

            <div style="display:flex; justify-content:flex-end; gap:10px;">
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('modalConvention').style.display='none'">Annuler</button>
                <button type="submit" class="btn btn-primary">Enregistrer la convention</button>
            </div>
        </form>
    </div>
</div>
<% } %>

</body>
</html>
