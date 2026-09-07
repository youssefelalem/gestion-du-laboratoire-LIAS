<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.lias.beans.DemandeAdhesion"%>
<%@ page import="com.lias.beans.User"%>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    boolean isDirecteur = (currentUser != null && ("directeur".equalsIgnoreCase(currentUser.getRole()) || "admin".equalsIgnoreCase(currentUser.getRole())));
    String msg = request.getParameter("msg");
    List<DemandeAdhesion> demandes = (List<DemandeAdhesion>) request.getAttribute("demandes");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS — Demandes d'Adhésion & Recrutement</title>
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
                <span class="eyebrow"><%= isDirecteur ? "Gouvernance & Recrutement · Décisions Directionnelles" : "Rejoindre la Communauté Scientifique" %></span>
                <h1 class="page-title">Demandes d'Adhésion</h1>
                <p class="page-sub">
                    Procédure officielle d'accueil des doctorants, post-doctorants et chercheurs associés au sein du LIAS. Chaque décision est motivée et consignée dans la mémoire du laboratoire.
                </p>
            </div>
            <% if (!isDirecteur) { %>
                <a href="#formulaireCandidature" class="btn btn-primary">Déposer une candidature ↓</a>
            <% } %>
        </div>

        <% if ("soumission_reussie".equals(msg)) { %>
            <div class="callout callout-success">
                ✓ Votre dossier de candidature a été transmis à la direction du laboratoire. Un accusé de réception a été envoyé.
            </div>
        <% } else if ("decision_enregistree".equals(msg)) { %>
            <div class="callout callout-success">
                ✓ La décision sur le dossier a été enregistrée avec succès.
            </div>
        <% } %>

        <% if (isDirecteur) { %>
            <!-- ESPACE DIRECTEUR : Arbitrage des Candidatures -->
            <div class="card" style="border-left: 4px solid var(--accent-2); margin-bottom: 32px;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                    <div>
                        <span class="eyebrow">Dossiers en Instance d'Arbitrage</span>
                        <h2 style="font-size: 24px; margin: 4px 0 0;">Candidatures en Attente d'Instruction</h2>
                    </div>
                    <span class="badge badge-gold"><%= demandes != null ? demandes.size() : "0" %> dossiers</span>
                </div>
                <p style="font-size: 13.5px; color: var(--muted); margin-bottom: 24px;">
                    Conformément aux statuts de l'Université Hassan II, l'acceptation par le directeur génère automatiquement l'identifiant institutionnel et initialise l'historique d'affiliation.
                </p>

                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Candidat</th>
                                <th>Contact Email</th>
                                <th>Statut postulé</th>
                                <th>Établissement d'origine</th>
                                <th>Décision & Visa</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (demandes != null && !demandes.isEmpty()) {
                                    for (DemandeAdhesion d : demandes) {
                            %>
                            <tr>
                                <td style="font-family: var(--font-mono); font-size: 12px;"><%= d.getDateSoumission() %></td>
                                <td><strong style="font-family: var(--font-serif); font-size: 15px;"><%= d.getNom() %> <%= d.getPrenom() %></strong></td>
                                <td style="font-family: var(--font-mono); font-size: 12px; color: var(--navy);"><%= d.getEmail() %></td>
                                <td><span class="badge badge-navy"><%= d.getStatutVise() %></span></td>
                                <td style="font-size: 12.5px; color: var(--muted);"><%= d.getEtablissement() %></td>
                                <td>
                                    <form action="<%= request.getContextPath() %>/adhesions" method="post" style="display: inline-flex; gap: 6px;">
                                        <input type="hidden" name="demandeId" value="<%= d.getId() %>">
                                        <button type="submit" name="action" value="valider" class="btn btn-sm btn-accent">Valider</button>
                                        <button type="submit" name="action" value="refuser" class="btn btn-sm btn-danger">Refuser</button>
                                    </form>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="6" style="padding: 24px; text-align: center; color: var(--muted);">
                                    Aucune demande d'adhésion en attente d'arbitrage.
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        <% } %>

        <!-- Formulaire de Candidature pour Candidats / Visiteurs -->
        <div id="formulaireCandidature" class="card" style="max-width: 800px; margin: 0 auto; padding: 40px;">
            <span class="eyebrow">Dépôt de Dossier Universitaire</span>
            <h2 style="font-size: 28px; margin: 4px 0 8px;">Formulaire de Candidature</h2>
            <p style="font-size: 14px; color: var(--muted); margin-bottom: 28px;">
                Veuillez renseigner ce formulaire avec vos coordonnées institutionnelles exactes. La direction examinera votre profil lors du prochain conseil scientifique.
            </p>

            <form action="<%= request.getContextPath() %>/adhesions" method="post">
                <input type="hidden" name="action" value="soumettre">

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div class="form-group">
                        <label class="form-label">Nom de famille</label>
                        <input type="text" name="nom" class="form-control" placeholder="ex: El Fassi" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Prénom</label>
                        <input type="text" name="prenom" class="form-control" placeholder="ex: Salma" required>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div class="form-group">
                        <label class="form-label">Adresse email académique</label>
                        <input type="email" name="email" class="form-control" placeholder="candidat@univ-h2c.ma" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Statut postulé</label>
                        <select name="statutPostule" class="form-control" required>
                            <option value="doctorant">Doctorant en Thèse</option>
                            <option value="permanent">Enseignant-Chercheur Permanent</option>
                            <option value="associe">Chercheur Associé / Post-Doc</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Établissement ou Université de rattachement</label>
                    <input type="text" name="etablissementOrigine" class="form-control" placeholder="ex: Faculté des Sciences Ben M'Sik / ENSIAS / Autre..." required>
                </div>

                <div class="form-group">
                    <label class="form-label">Lettre de motivation & Sujet de recherche envisagé</label>
                    <textarea name="motivation" class="form-control" rows="5" placeholder="Décrivez succinctement vos motivations, vos axes de recherche et vos éventuelles publications passées..." required></textarea>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 14px; font-size: 15px;">
                    Transmettre mon dossier à la direction du LIAS →
                </button>
            </form>
        </div>

            </div>
        </main>
    </div>
</div>

</body>
</html>
