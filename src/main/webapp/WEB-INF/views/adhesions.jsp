<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.lias.beans.DemandeAdhesion"%>
<%@ page import="com.lias.beans.User"%>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    boolean isDirecteur = (currentUser != null && "directeur".equalsIgnoreCase(currentUser.getRole()));
    String msg = request.getParameter("msg");
    List<DemandeAdhesion> demandes = (List<DemandeAdhesion>) request.getAttribute("demandes");
    if (demandes == null) {
        demandes = (List<DemandeAdhesion>) request.getAttribute("adhesions");
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS — Demandes d'Adhésion & Recrutement</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=4">
</head>
<body>

<% if (currentUser == null) { %>
    <%@ include file="includes/navbar.jsp" %>
    <div class="container" style="max-width: 1100px; margin: 0 auto; padding: 40px 24px;">
<% } else { %>
<div class="app-shell">
    <%@ include file="includes/app_header.jsp" %>
    <div class="app-body">
        <%@ include file="includes/sidebar.jsp" %>
        <main class="app-main">
            <div class="app-content">
<% } %>


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
            <div class="toast-notification" id="appToast">
                <div class="toast-icon">✓</div>
                <div class="toast-content">
                    <div class="toast-title">Candidature transmise avec succès !</div>
                    <div class="toast-desc">Votre dossier a été enregistré et transmis à la direction du laboratoire LIAS. Un accusé de réception automatique a été généré.</div>
                </div>
                <button type="button" class="toast-close" onclick="closeToast()" title="Fermer">✕</button>
            </div>
        <% } else if ("decision_enregistree".equals(msg)) { %>
            <div class="toast-notification" id="appToast">
                <div class="toast-icon">✓</div>
                <div class="toast-content">
                    <div class="toast-title">Décision enregistrée avec succès !</div>
                    <div class="toast-desc">La décision de la direction sur le dossier a été validée et enregistrée dans les registres officiels du laboratoire.</div>
                </div>
                <button type="button" class="toast-close" onclick="closeToast()" title="Fermer">✕</button>
            </div>
        <% } %>

        <%
            // Compte créé à l'acceptation (CDC §6) : identifiants affichés UNE seule fois au directeur.
            String compteCree = (String) session.getAttribute("flashCompteCree");
            if (isDirecteur && compteCree != null) {
                session.removeAttribute("flashCompteCree");
                String[] cc = compteCree.split("\\|", 2);
                String ccEmail = cc[0].replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
                String ccPass = cc.length > 1 ? cc[1] : "";
        %>
            <div style="margin: 0 0 24px; padding: 18px 22px; background: var(--primary-bg); border: 1px solid var(--primary-border); border-radius: 4px;">
                <div style="font-family: var(--font-mono); font-size: 11px; letter-spacing: 0.12em; text-transform: uppercase; color: var(--navy); margin-bottom: 8px;">Compte de connexion créé</div>
                <div style="font-size: 14px; color: var(--ink); line-height: 1.7;">
                    Identifiant : <code><%= ccEmail %></code><br>
                    Mot de passe temporaire : <code style="font-weight: 700;"><%= ccPass %></code>
                </div>
                <div style="font-size: 12.5px; color: var(--muted); margin-top: 8px;">À communiquer au nouveau membre. Il ne sera plus affiché après cette page.</div>
            </div>
        <% } %>

        <% if (isDirecteur) { 
            int nbAttente = 0;
            int nbAcceptees = 0;
            int nbRefusees = 0;
            if (demandes != null) {
                for (DemandeAdhesion d : demandes) {
                    if ("ACCEPTEE".equalsIgnoreCase(d.getDecision())) nbAcceptees++;
                    else if ("REFUSEE".equalsIgnoreCase(d.getDecision())) nbRefusees++;
                    else nbAttente++;
                }
            }
        %>
            <!-- ESPACE DIRECTEUR : Métriques & Arbitrage des Candidatures -->
            <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 24px;">
                <div class="card" style="padding: 20px; border-left: 4px solid var(--navy);">
                    <span style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.08em; color: var(--muted); font-weight: 600;">Total Dossiers Reçus</span>
                    <div style="font-family: var(--font-serif); font-size: 28px; font-weight: 700; color: var(--navy); margin-top: 6px;"><%= demandes != null ? demandes.size() : 0 %></div>
                </div>
                <div class="card" style="padding: 20px; border-left: 4px solid var(--accent-2);">
                    <span style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.08em; color: var(--muted); font-weight: 600;">En Instance d'Arbitrage</span>
                    <div style="font-family: var(--font-serif); font-size: 28px; font-weight: 700; color: var(--accent-2); margin-top: 6px;"><%= nbAttente %></div>
                </div>
                <div class="card" style="padding: 20px; border-left: 4px solid var(--accent);">
                    <span style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.08em; color: var(--muted); font-weight: 600;">Dossiers Validés & Intégrés</span>
                    <div style="font-family: var(--font-serif); font-size: 28px; font-weight: 700; color: var(--accent); margin-top: 6px;"><%= nbAcceptees %></div>
                </div>
            </div>

            <div class="card" style="border-left: 4px solid var(--accent-2); margin-bottom: 32px;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                    <div>
                        <span class="eyebrow">Dossiers & Registre d'Adhésion</span>
                        <h2 style="font-size: 22px; margin: 4px 0 0;">Arbitrage des Demandes d'Intégration au LIAS</h2>
                    </div>
                    <span class="badge badge-gold"><%= nbAttente %> en attente</span>
                </div>
                <p style="font-size: 13.5px; color: var(--muted); margin-bottom: 24px;">
                    Conformément aux statuts du laboratoire LIAS (CDC §4.2), la validation par le directeur délivre l'accès membre et associe le chercheur à son équipe de rattachement.
                </p>

                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Candidat</th>
                                <th>Contact Email</th>
                                <th>Statut postulé</th>
                                <th>Établissement</th>
                                <th>Décision / Statut</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (demandes != null && !demandes.isEmpty()) {
                                    for (DemandeAdhesion d : demandes) {
                                        boolean isPending = (d.getDecision() == null || "EN_ATTENTE".equalsIgnoreCase(d.getDecision()));
                                        boolean isAccepted = "ACCEPTEE".equalsIgnoreCase(d.getDecision());
                                        boolean isRefused = "REFUSEE".equalsIgnoreCase(d.getDecision());
                            %>
                            <tr>
                                <td style="font-family: var(--font-mono); font-size: 12px;"><%= d.getDateSoumission() %></td>
                                <td><strong style="font-family: var(--font-serif); font-size: 15px;"><%= d.getNom() %> <%= d.getPrenom() %></strong></td>
                                <td style="font-family: var(--font-mono); font-size: 12px; color: var(--navy);"><%= d.getEmail() %></td>
                                <td><span class="badge badge-navy"><%= d.getStatutVise() %></span></td>
                                <td style="font-size: 12.5px; color: var(--muted);"><%= d.getEtablissement() %></td>
                                <td>
                                    <% if (isPending) { %>
                                        <form action="<%= request.getContextPath() %>/adhesions" method="post" style="display: inline-flex; gap: 6px;">
                                            <input type="hidden" name="demandeId" value="<%= d.getId() %>">
                                            <button type="submit" name="action" value="valider" class="btn btn-sm btn-accent" title="Valider le dossier et intégrer le membre">✓ Valider</button>
                                            <button type="submit" name="action" value="refuser" class="btn btn-sm btn-danger" title="Refuser la candidature">✕ Refuser</button>
                                        </form>
                                    <% } else if (isAccepted) { %>
                                        <span class="badge badge-accent" style="display: inline-flex; align-items: center; gap: 4px;">✓ Validée & Intégrée</span>
                                    <% } else if (isRefused) { %>
                                        <span class="badge badge-danger" style="display: inline-flex; align-items: center; gap: 4px;">✕ Candidature rejetée</span>
                                    <% } %>
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

        <% if (currentUser == null) { %>
            <!-- Formulaire de Candidature pour Candidats / Visiteurs Uniquement -->
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
        <% } else if (!isDirecteur) { %>
            <!-- Membre déjà intégré -->
            <div class="card" style="text-align: center; padding: 48px 24px; max-width: 650px; margin: 40px auto;">
                <div style="font-size: 42px; margin-bottom: 16px;">🎓</div>
                <h3 style="font-size: 22px; margin-bottom: 8px;">Vous êtes déjà membre affilié au LIAS</h3>
                <p style="color: var(--muted); font-size: 14px; line-height: 1.6; margin-bottom: 24px;">
                    Votre compte est actif et rattaché à une équipe de recherche du laboratoire. Vous n'avez pas besoin de soumettre une nouvelle candidature.
                </p>
                <a href="<%= request.getContextPath() %>/home" class="btn btn-primary">Retour à mon tableau de bord →</a>
            </div>
        <% } %>

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
