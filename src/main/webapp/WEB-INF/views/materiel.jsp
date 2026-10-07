<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.lias.beans.Materiel"%>
<%@ page import="com.lias.beans.Member"%>
<%@ page import="com.lias.beans.User"%>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    boolean isDirecteur = (currentUser != null && ("directeur".equalsIgnoreCase(currentUser.getRole()) || "admin".equalsIgnoreCase(currentUser.getRole())));
    String msg = request.getParameter("msg");
    List<Materiel> materiels = (List<Materiel>) request.getAttribute("materiels");
    Integer totalEquipements = (Integer) request.getAttribute("totalEquipements");
    Integer totalAttribues = (Integer) request.getAttribute("totalAttribues");
    Integer totalEnAttente = (Integer) request.getAttribute("totalEnAttente");
    Integer indiceEquite = (Integer) request.getAttribute("indiceEquite");
    List<Member> membresAvecDotation = (List<Member>) request.getAttribute("membresAvecDotation");
    List<Member> membresSansDotation = (List<Member>) request.getAttribute("membresSansDotation");
    Map<String, List<Materiel>> dotationsMap = (Map<String, List<Materiel>>) request.getAttribute("dotationsMap");
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

        <!-- KPI Strip Calculé Dynamiquement -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="k">Équipements au Catalogue</div>
                <div class="v"><%= totalEquipements != null ? totalEquipements : (materiels != null ? materiels.size() : 0) %></div>
                <div class="s">unités inventoriées</div>
            </div>
            <div class="stat-card">
                <div class="k">Unités Affectées</div>
                <div class="v" style="color: var(--sage);"><%= totalAttribues != null ? totalAttribues : 0 %></div>
                <div class="s">en service actif</div>
            </div>
            <div class="stat-card">
                <div class="k">Demandes en Attente</div>
                <div class="v" style="color: var(--warning);"><%= totalEnAttente != null ? totalEnAttente : 0 %></div>
                <div class="s">en cours d'arbitrage</div>
            </div>
            <div class="stat-card">
                <div class="k">Indice d'Équité</div>
                <div class="v"><%= indiceEquite != null ? indiceEquite : 0 %> %</div>
                <div class="s">chercheurs actifs dotés</div>
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

        <!-- Matrice de Distribution Équitable (CDC §14 ⭐ : Traçabilité « Qui a reçu quoi / Qui n'a pas encore reçu ») -->
        <div class="card" style="margin-bottom: 28px; padding: 24px; border-left: 4px solid #10B981;">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 18px; flex-wrap: wrap; gap: 10px;">
                <div>
                    <span class="eyebrow" style="color: #059669;">Exigence Métier CDC §14 ⭐</span>
                    <h3 style="font-size: 19px; color: var(--navy); margin: 4px 0 6px;">Matrice de Distribution Équitable</h3>
                    <p style="font-size: 13.5px; color: var(--muted); margin: 0;">
                        Suivi nominatif de l'allocation des ressources scientifiques entre chercheurs permanents et doctorants.
                    </p>
                </div>
                <div>
                    <span class="badge badge-sage" style="font-size: 12px; padding: 6px 12px;">
                        Taux d'équipement : <%= indiceEquite != null ? indiceEquite : 0 %> %
                    </span>
                </div>
            </div>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 20px;">
                <!-- Colonne 1 : Qui a reçu quoi -->
                <div style="background: #F8FAFC; border: 1px solid #E2E8F0; border-radius: 6px; padding: 16px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; padding-bottom: 8px; border-bottom: 1px solid #E2E8F0;">
                        <strong style="font-size: 13.5px; color: #065F46; display: flex; align-items: center; gap: 6px;">
                            <span>✓</span> Membres dotés (Qui a reçu quoi)
                        </strong>
                        <span class="badge badge-sage" style="font-size: 11px;"><%= membresAvecDotation != null ? membresAvecDotation.size() : 0 %> dotés</span>
                    </div>

                    <% if (membresAvecDotation != null && !membresAvecDotation.isEmpty()) { 
                        for (Member mDot : membresAvecDotation) {
                            String fName = (mDot.getFirstName() + " " + mDot.getLastName()).toLowerCase();
                            List<Materiel> matsDuMembre = (dotationsMap != null) ? dotationsMap.get(fName) : null;
                    %>
                        <div style="background: #FFF; border: 1px solid #E2E8F0; border-radius: 4px; padding: 10px 12px; margin-bottom: 8px; box-shadow: 0 1px 2px rgba(0,0,0,0.03);">
                            <div style="display: flex; justify-content: space-between; align-items: baseline;">
                                <strong style="font-size: 13.5px; color: var(--navy);"><%= mDot.getFullName() %></strong>
                                <span style="font-size: 11px; color: var(--muted);"><%= mDot.getGrade() %> (<%= mDot.getTeam() %>)</span>
                            </div>
                            <div style="margin-top: 6px; display: flex; flex-wrap: wrap; gap: 6px;">
                                <% if (matsDuMembre != null && !matsDuMembre.isEmpty()) { 
                                    for (Materiel matItem : matsDuMembre) { %>
                                        <span class="chip" style="background: #ECFDF5; color: #065F46; border: 1px solid #A7F3D0; font-size: 11px; padding: 2px 8px;">
                                            📦 <%= matItem.getDesignation() %>
                                        </span>
                                <%  } 
                                } else { %>
                                    <span class="chip" style="background: #ECFDF5; color: #065F46; border: 1px solid #A7F3D0; font-size: 11px; padding: 2px 8px;">
                                        📦 Station de calcul GPU / Équipement affecté
                                    </span>
                                <% } %>
                            </div>
                        </div>
                    <% } } else { %>
                        <div style="font-size: 13px; color: var(--muted); text-align: center; padding: 20px;">
                            Aucune dotation confirmée pour le moment.
                        </div>
                    <% } %>
                </div>

                <!-- Colonne 2 : Qui n'a pas encore reçu -->
                <div style="background: #FFFBEB; border: 1px solid #FEF3C7; border-radius: 6px; padding: 16px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; padding-bottom: 8px; border-bottom: 1px solid #FDE68A;">
                        <strong style="font-size: 13.5px; color: #92400E; display: flex; align-items: center; gap: 6px;">
                            <span>⏳</span> Membres sans dotation (Priorité d'attribution)
                        </strong>
                        <span class="badge badge-gold" style="font-size: 11px;"><%= membresSansDotation != null ? membresSansDotation.size() : 0 %> en attente</span>
                    </div>

                    <% if (membresSansDotation != null && !membresSansDotation.isEmpty()) { 
                        for (Member mSans : membresSansDotation) { %>
                        <div style="background: #FFF; border: 1px solid #FDE68A; border-radius: 4px; padding: 10px 12px; margin-bottom: 8px; box-shadow: 0 1px 2px rgba(0,0,0,0.03);">
                            <div style="display: flex; justify-content: space-between; align-items: baseline;">
                                <strong style="font-size: 13.5px; color: var(--ink);"><%= mSans.getFullName() %></strong>
                                <span style="font-size: 11px; color: #B45309; font-weight: 600;"><%= mSans.getGrade() %></span>
                            </div>
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 6px; font-size: 12px; color: var(--muted);">
                                <span>Équipe <%= mSans.getTeam() %></span>
                                <span style="font-style: italic; color: #D97706; font-size: 11px;">Prioritaire pour prochain arrivage</span>
                            </div>
                        </div>
                    <% } } else { %>
                        <div style="font-size: 13px; color: #065F46; text-align: center; padding: 20px;">
                            ✓ Tous les chercheurs actifs ont bénéficié d'une dotation !
                        </div>
                    <% } %>
                </div>
            </div>
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
