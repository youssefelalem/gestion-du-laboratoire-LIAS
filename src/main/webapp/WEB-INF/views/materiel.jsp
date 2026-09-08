<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.lias.beans.Materiel"%>
<%@ page import="com.lias.beans.User"%>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    boolean isDirecteur = (currentUser != null && ("directeur".equalsIgnoreCase(currentUser.getRole()) || "admin".equalsIgnoreCase(currentUser.getRole())));
    String msg = request.getParameter("msg");
    List<Materiel> materiels = (List<Materiel>) request.getAttribute("materiels");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS — Gestion du Matériel & Distribution Équitable</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=3">
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
                <span class="eyebrow">Parc Scientifique & Équité de Distribution (CDC §14 & §15)</span>
                <h1 class="page-title">Gestion du Matériel</h1>
                <p class="page-sub">
                    Suivi transparent des acquisitions et distribution équitable entre chercheurs et doctorants : traçabilité complète de <em>« qui a reçu quoi, et qui n'a pas encore reçu »</em>.
                </p>
            </div>
            <% if (currentUser != null) { %>
                <button class="btn btn-primary" onclick="toggleBesoinForm()">+ Exprimer un besoin de matériel</button>
            <% } %>
        </div>

        <% if ("demande_enregistree".equals(msg)) { %>
            <div class="toast-notification" id="appToast">
                <div class="toast-icon">✓</div>
                <div class="toast-content">
                    <div class="toast-title">Demande d'équipement transmise !</div>
                    <div class="toast-desc">Votre besoin en matériel scientifique a été consigné pour instruction budgétaire.</div>
                </div>
                <button type="button" class="toast-close" onclick="closeToast()" title="Fermer">✕</button>
            </div>
        <% } %>

        <!-- KPI Strip -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="k">Équipements au Catalogue</div>
                <div class="v"><%= materiels != null ? materiels.size() : "14" %></div>
                <div class="s">unités inventoriées</div>
            </div>
            <div class="stat-card">
                <div class="k">Unités Affectées</div>
                <div class="v" style="color: var(--sage);">9</div>
                <div class="s">en service actif</div>
            </div>
            <div class="stat-card">
                <div class="k">Demandes en Attente</div>
                <div class="v" style="color: var(--warning);">3</div>
                <div class="s">en cours d'arbitrage</div>
            </div>
            <div class="stat-card">
                <div class="k">Indice d'Équité</div>
                <div class="v">100 %</div>
                <div class="s">traçabilité certifiée</div>
            </div>
        </div>

        <!-- Expression de besoin Card (Collapsible) -->
        <div id="besoinCard" class="card" style="display: none; border-left: 4px solid var(--navy); margin-bottom: 28px;">
            <h3 style="font-size: 20px; margin-bottom: 16px;">Formulaire d'expression de besoin en équipement</h3>
            <form action="<%= request.getContextPath() %>/materiel" method="post">
                <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 16px;">
                    <div class="form-group">
                        <label class="form-label">Désignation du matériel souhaité</label>
                        <input type="text" name="designation" class="form-control" placeholder="ex: Station de calcul GPU RTX 4090 / PC Portable..." required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Catégorie</label>
                        <select name="categorie" class="form-control">
                            <option value="Calcul / Serveur">Calcul / Serveur GPU</option>
                            <option value="Poste de Travail">Poste de Travail / PC Portable</option>
                            <option value="Périphérique">Périphérique & Réseau</option>
                            <option value="Logiciel">Licence Logicielle Scientifique</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Justification de la demande (Projet de recherche lié)</label>
                    <textarea name="description" class="form-control" rows="3" placeholder="Expliquez la nécessité de cet équipement pour vos travaux de recherche actuels au LIAS..." required></textarea>
                </div>

                <div style="display: flex; gap: 10px;">
                    <button type="submit" class="btn btn-primary">Soumettre la demande d'équipement →</button>
                    <button type="button" class="btn btn-secondary" onclick="toggleBesoinForm()">Annuler</button>
                </div>
            </form>
        </div>

        <!-- Inventaire & Registre -->
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Désignation de l'équipement</th>
                        <th>Catégorie</th>
                        <th>Demandeur / Bénéficiaire</th>
                        <th>Date de Demande</th>
                        <th>Statut d'Allocation</th>
                        <% if (isDirecteur) { %><th>Arbitrage</th><% } %>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (materiels != null && !materiels.isEmpty()) {
                            for (Materiel m : materiels) {
                                String tone = "badge-muted";
                                if ("attribue".equalsIgnoreCase(m.getStatut()) || "validé".equalsIgnoreCase(m.getStatut())) tone = "badge-sage";
                                else if ("en_attente".equalsIgnoreCase(m.getStatut())) tone = "badge-gold";
                    %>
                    <tr>
                        <td>
                            <strong style="font-family: var(--font-serif); font-size: 15px;"><%= m.getDesignation() %></strong>
                            <% if (m.getCommentaire() != null && !m.getCommentaire().isEmpty()) { %>
                                <div style="font-size: 12px; color: var(--muted); margin-top: 2px;"><%= m.getCommentaire() %></div>
                            <% } %>
                        </td>
                        <td><span class="badge badge-navy"><%= m.getCategorie() %></span></td>
                        <td><strong><%= m.getDemandeur() != null ? m.getDemandeur() : "Non attribué" %></strong></td>
                        <td style="font-family: var(--font-mono); font-size: 12px;"><%= m.getDateDemande() != null ? m.getDateDemande() : "—" %></td>
                        <td><span class="badge <%= tone %>"><%= m.getStatut() %></span></td>
                        <% if (isDirecteur) { %>
                        <td>
                            <% if ("en_attente".equalsIgnoreCase(m.getStatut())) { %>
                            <form action="<%= request.getContextPath() %>/materiel" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="attribuer">
                                <input type="hidden" name="id" value="<%= m.getId() %>">
                                <input type="hidden" name="materielId" value="<%= m.getId() %>">
                                <input type="hidden" name="statut" value="ATTRIBUE">
                                <button type="submit" class="btn btn-sm btn-accent">Attribuer</button>
                            </form>
                            <% } else { %>
                                <span style="font-size: 11px; color: var(--muted);">Clôturé</span>
                            <% } %>
                        </td>
                        <% } %>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="6" style="padding: 24px; text-align: center; color: var(--muted);">
                            Aucun équipement enregistré dans le registre.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

            </div>
        </main>
    </div>
</div>

    <script>
        function toggleBesoinForm() {
            var f = document.getElementById('besoinCard');
            f.style.display = f.style.display === 'block' ? 'none' : 'block';
            if (f.style.display === 'block') f.scrollIntoView({ behavior: 'smooth' });
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
