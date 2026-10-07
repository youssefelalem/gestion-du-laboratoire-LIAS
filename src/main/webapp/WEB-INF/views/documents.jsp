<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.LinkedHashMap"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.lias.beans.DocumentLabo"%>
<%@ page import="com.lias.beans.User"%>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) currentUser = (User) session.getAttribute("user");
    String userRole = currentUser != null ? currentUser.getRole() : "visiteur";
    boolean canUpload = currentUser != null && !"visiteur".equalsIgnoreCase(userRole);

    List<DocumentLabo> allDocs = (List<DocumentLabo>) request.getAttribute("allDocs");
    if (allDocs == null) allDocs = new ArrayList<>();

    List<DocumentLabo> currentDocs = (List<DocumentLabo>) request.getAttribute("currentDocs");
    if (currentDocs == null) currentDocs = new ArrayList<>();

    List<DocumentLabo> searchResults = (List<DocumentLabo>) request.getAttribute("searchResults");
    String searchQuery = (String) request.getAttribute("searchQuery");

    String selDossier = (String) request.getAttribute("selDossier");
    String selSousDossier = (String) request.getAttribute("selSousDossier");
    String selEdition = (String) request.getAttribute("selEdition");
    if (selDossier == null) selDossier = "Évènements";
    if (selSousDossier == null) selSousDossier = "CASA-DATA";
    if (selEdition == null) selEdition = "2025 — 7e édition";

    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Archive Documentaire — Laboratoire LIAS</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@500;700&family=Inter:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Spectral:ital,wght@0,400;0,600;1,400&display=swap" rel="stylesheet">
    <style>
        .docs-layout {
            display: grid;
            grid-template-columns: 290px 1fr;
            gap: 20px;
            align-items: start;
        }
        @media (max-width: 960px) {
            .docs-layout { grid-template-columns: 1fr; }
        }
        .tree-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 4px;
            overflow: hidden;
        }
        .tree-header {
            padding: 12px 16px;
            border-bottom: 1px solid var(--border);
            font-family: 'JetBrains Mono', monospace;
            font-size: 11px;
            color: var(--muted, #6B7280);
            letter-spacing: 0.12em;
            text-transform: uppercase;
            font-weight: 600;
        }
        .tree-body {
            padding: 8px 6px;
        }
        .tree-row {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 7px 10px;
            width: 100%;
            text-align: left;
            cursor: pointer;
            background: transparent;
            border: none;
            border-left: 2px solid transparent;
            font-family: 'Inter', sans-serif;
            font-size: 13px;
            color: var(--ink, #1F242E);
            border-radius: 2px;
            text-decoration: none;
            box-sizing: border-box;
            transition: all 0.15s ease;
        }
        .tree-row:hover {
            background: rgba(210, 195, 175, 0.25);
            color: var(--navy, #1B2F4A);
        }
        .tree-row.active {
            background: rgba(27, 47, 74, 0.08);
            border-left: 2px solid var(--navy, #1B2F4A);
            font-weight: 600;
            color: var(--navy, #1B2F4A);
        }
        .tree-row.indent-1 {
            padding-left: 24px;
        }
        .tree-row.indent-2 {
            padding-left: 38px;
            font-size: 12.5px;
        }
        .tree-badge {
            margin-left: auto;
            font-family: 'JetBrains Mono', monospace;
            font-size: 10.5px;
            color: var(--muted, #6B7280);
        }
        .upload-dropzone {
            margin-bottom: 16px;
            padding: 18px 20px;
            border: 1px dashed var(--border);
            background: var(--surface-2);
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
        }
        .file-icon-box {
            width: 34px;
            height: 40px;
            position: relative;
            display: inline-flex;
            align-items: flex-end;
            justify-content: center;
            padding-bottom: 4px;
            font-family: 'JetBrains Mono', monospace;
            font-size: 9px;
            font-weight: 700;
            letter-spacing: 0.05em;
            border-radius: 2px;
            flex-shrink: 0;
        }
        .file-icon-box .corner-fold {
            position: absolute;
            top: 0;
            right: 0;
            width: 8px;
            height: 8px;
            background: var(--surface);
            border-left: 1px solid currentColor;
            border-bottom: 1px solid currentColor;
        }
        .type-pdf { background: #FEE2E2; color: #991B1B; border: 1px solid #FCA5A5; }
        .type-docx { background: #E0E7FF; color: #1E3A8A; border: 1px solid #C7D2FE; }
        .type-xlsx { background: #DCFCE7; color: #166534; border: 1px solid #BBF7D0; }
        .type-zip { background: #F1F5F9; color: #475569; border: 1px solid #CBD5E1; }

        .action-icon-btn {
            background: transparent;
            border: 1px solid var(--border);
            color: var(--ink);
            width: 30px;
            height: 30px;
            border-radius: 3px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            text-decoration: none;
            font-size: 13px;
            transition: all 0.15s ease;
        }
        .action-icon-btn:hover {
            background: var(--surface-2);
            border-color: var(--navy);
            color: var(--navy);
        }
    </style>
</head>
<body>
<div class="app-shell">
    <!-- APP HEADER -->
    <%@ include file="includes/app_header.jsp" %>

    <div class="app-body">
        <!-- SIDEBAR -->
        <%@ include file="includes/sidebar.jsp" %>

        <!-- CONTENU PRINCIPAL -->
        <main class="app-main">
            <div class="app-content">
            <!-- NOTIFICATION TOAST -->
            <% if ("uploaded".equals(msg)) { %>
                <div class="toast toast-success" style="display:flex; align-items:center; gap:10px; margin-bottom:16px; padding:12px 18px; background:#E8F5E9; border-left:4px solid #2E7D32; color:#1B5E20; border-radius:3px;">
                    <span style="font-size:18px;">✓</span>
                    <div>
                        <strong>Document archivé avec succès !</strong> Le fichier a été indexé dans le système documentaire du laboratoire.
                    </div>
                </div>
            <% } %>

            <!-- SECTION HEAD -->
            <div class="section-head">
                <div>
                    <div class="section-eyebrow"><%= allDocs.size() %> documents archivés · 4 formats pris en charge · historisation complète (CDC §10)</div>
                    <h1 class="section-title">Archive documentaire</h1>
                    <p class="section-subtitle">
                        Mémoire institutionnelle du laboratoire : programmes, attestations, rapports de synthèse, demandes de financement — tous organisés par évènement et par date.
                    </p>
                </div>
                <div class="section-actions">
                    <% if (canUpload) { %>
                        <button type="button" class="btn btn-primary" onclick="openUploadModal()">
                            ⤒ Téléverser un document
                        </button>
                    <% } %>
                </div>
            </div>

            <!-- SEARCH BAR -->
            <div style="margin-bottom: 18px;">
                <form action="<%= request.getContextPath() %>/documents" method="GET" style="display:flex; gap:10px;">
                    <div class="search-input-wrapper" style="flex:1; position:relative;">
                        <span style="position:absolute; left:14px; top:50%; transform:translateY(-50%); color:var(--muted); font-size:15px;">⌕</span>
                        <input type="text" name="q" value="<%= searchQuery != null ? searchQuery : "" %>"
                               placeholder="Rechercher dans l'ensemble des documents (nom, date, auteur, événement)..." 
                               style="width:100%; padding:10px 14px 10px 38px; border:1px solid var(--border); border-radius:3px; font-family:'Inter', sans-serif; font-size:13.5px; background:var(--surface);">
                    </div>
                    <button type="submit" class="btn btn-secondary">Rechercher</button>
                    <% if (searchQuery != null && !searchQuery.trim().isEmpty()) { %>
                        <a href="<%= request.getContextPath() %>/documents" class="btn btn-ghost">Réinitialiser</a>
                    <% } %>
                </form>
            </div>

            <!-- LAYOUT ARBORESCENCE & LISTE -->
            <div class="docs-layout">
                <!-- ARBORESCENCE GAUCHE -->
                <div class="tree-card">
                    <div class="tree-header">Arborescence</div>
                    <div class="tree-body">
                        <!-- RACINE ÉVÈNEMENTS -->
                        <div style="margin-bottom:4px;">
                            <div class="tree-row" style="font-weight:600; cursor:default;">
                                <span style="font-family:'JetBrains Mono'; font-size:11px; color:var(--muted);">▾</span>
                                <span style="font-size:13px; color:var(--navy);">▦</span>
                                <span>Évènements</span>
                            </div>

                            <!-- SOUS-DOSSIER CASA-DATA -->
                            <div class="tree-row indent-1" style="font-weight:500;">
                                <span style="font-family:'JetBrains Mono'; font-size:10px; color:var(--muted);">▾</span>
                                <span style="font-size:12px; color:var(--muted);">▤</span>
                                <span>CASA-DATA</span>
                                <span class="tree-badge">3 éd.</span>
                            </div>
                            <a href="<%= request.getContextPath() %>/documents?dossier=Évènements&sousDossier=CASA-DATA&edition=<%= java.net.URLEncoder.encode("2025 — 7e édition", "UTF-8") %>" 
                               class="tree-row indent-2 <%= ("Évènements".equals(selDossier) && "CASA-DATA".equals(selSousDossier) && "2025 — 7e édition".equals(selEdition)) ? "active" : "" %>">
                                <span>◦</span>
                                <span>2025 — 7e édition</span>
                                <span class="tree-badge">5</span>
                            </a>
                            <a href="<%= request.getContextPath() %>/documents?dossier=Évènements&sousDossier=CASA-DATA&edition=<%= java.net.URLEncoder.encode("2024 — 6e édition", "UTF-8") %>" 
                               class="tree-row indent-2 <%= ("Évènements".equals(selDossier) && "CASA-DATA".equals(selSousDossier) && "2024 — 6e édition".equals(selEdition)) ? "active" : "" %>">
                                <span>◦</span>
                                <span>2024 — 6e édition</span>
                                <span class="tree-badge">3</span>
                            </a>
                            <a href="<%= request.getContextPath() %>/documents?dossier=Évènements&sousDossier=CASA-DATA&edition=<%= java.net.URLEncoder.encode("2023 — 5e édition", "UTF-8") %>" 
                               class="tree-row indent-2 <%= ("Évènements".equals(selDossier) && "CASA-DATA".equals(selSousDossier) && "2023 — 5e édition".equals(selEdition)) ? "active" : "" %>">
                                <span>◦</span>
                                <span>2023 — 5e édition</span>
                                <span class="tree-badge">2</span>
                            </a>

                            <!-- SOUS-DOSSIER JOURNÉE DOCTORANTS -->
                            <div class="tree-row indent-1" style="font-weight:500; margin-top:2px;">
                                <span style="font-family:'JetBrains Mono'; font-size:10px; color:var(--muted);">▾</span>
                                <span style="font-size:12px; color:var(--muted);">▤</span>
                                <span>Journée Doctorants</span>
                                <span class="tree-badge">2 éd.</span>
                            </div>
                            <a href="<%= request.getContextPath() %>/documents?dossier=Évènements&sousDossier=Journée Doctorants&edition=<%= java.net.URLEncoder.encode("2026 — 4e édition", "UTF-8") %>" 
                               class="tree-row indent-2 <%= ("Évènements".equals(selDossier) && "Journée Doctorants".equals(selSousDossier) && "2026 — 4e édition".equals(selEdition)) ? "active" : "" %>">
                                <span>◦</span>
                                <span>2026 — 4e édition</span>
                                <span class="tree-badge">3</span>
                            </a>
                            <a href="<%= request.getContextPath() %>/documents?dossier=Évènements&sousDossier=Journée Doctorants&edition=<%= java.net.URLEncoder.encode("2025 — 3e édition", "UTF-8") %>" 
                               class="tree-row indent-2 <%= ("Évènements".equals(selDossier) && "Journée Doctorants".equals(selSousDossier) && "2025 — 3e édition".equals(selEdition)) ? "active" : "" %>">
                                <span>◦</span>
                                <span>2025 — 3e édition</span>
                                <span class="tree-badge">2</span>
                            </a>

                            <!-- SOUS-DOSSIER SÉMINAIRES NLP -->
                            <div class="tree-row indent-1" style="font-weight:500; margin-top:2px;">
                                <span style="font-family:'JetBrains Mono'; font-size:10px; color:var(--muted);">▾</span>
                                <span style="font-size:12px; color:var(--muted);">▤</span>
                                <span>Séminaires NLP</span>
                            </div>
                            <a href="<%= request.getContextPath() %>/documents?dossier=Évènements&sousDossier=Séminaires NLP&edition=2025-2026" 
                               class="tree-row indent-2 <%= ("Évènements".equals(selDossier) && "Séminaires NLP".equals(selSousDossier) && "2025-2026".equals(selEdition)) ? "active" : "" %>">
                                <span>◦</span>
                                <span>2025-2026</span>
                                <span class="tree-badge">2</span>
                            </a>
                        </div>

                        <!-- RACINE ADMINISTRATIF -->
                        <div style="margin-top:8px; border-top:1px solid var(--border); padding-top:6px;">
                            <div class="tree-row" style="font-weight:600; cursor:default;">
                                <span style="font-family:'JetBrains Mono'; font-size:11px; color:var(--muted);">▾</span>
                                <span style="font-size:13px; color:var(--navy);">▦</span>
                                <span>Administratif</span>
                            </div>

                            <a href="<%= request.getContextPath() %>/documents?dossier=Administratif&sousDossier=Conventions" 
                               class="tree-row indent-1 <%= ("Administratif".equals(selDossier) && "Conventions".equals(selSousDossier)) ? "active" : "" %>">
                                <span style="font-size:12px; color:var(--muted);">▤</span>
                                <span>Conventions</span>
                                <span class="tree-badge">3</span>
                            </a>

                            <a href="<%= request.getContextPath() %>/documents?dossier=Administratif&sousDossier=Rapports annuels" 
                               class="tree-row indent-1 <%= ("Administratif".equals(selDossier) && "Rapports annuels".equals(selSousDossier)) ? "active" : "" %>">
                                <span style="font-size:12px; color:var(--muted);">▤</span>
                                <span>Rapports annuels</span>
                                <span class="tree-badge">2</span>
                            </a>
                        </div>
                    </div>
                </div>

                <!-- CONTENU FICHIERS -->
                <div>
                    <% if (searchResults != null) { %>
                        <!-- RÉSULTATS DE RECHERCHE -->
                        <div style="margin-bottom:14px; font-family:'Spectral', serif; font-size:16px; color:var(--ink);">
                            <strong><%= searchResults.size() %></strong> document(s) trouvé(s) pour « <em><%= searchQuery %></em> »
                        </div>
                        <div class="card" style="padding:0; overflow:hidden;">
                            <% if (searchResults.isEmpty()) { %>
                                <div style="padding:32px; text-align:center; color:var(--muted);">
                                    Aucun document ne correspond à votre recherche.
                                </div>
                            <% } else { %>
                                <table class="table" style="margin:0;">
                                    <thead>
                                        <tr>
                                            <th>Fichier & Emplacement</th>
                                            <th>Taille</th>
                                            <th>Date</th>
                                            <th>Déposé par</th>
                                            <th style="text-align:right;">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (DocumentLabo d : searchResults) { 
                                            String ext = d.getType() != null ? d.getType().toLowerCase() : "pdf";
                                        %>
                                            <tr>
                                                <td>
                                                    <div style="display:flex; align-items:center; gap:12px;">
                                                        <div class="file-icon-box type-<%= ext %>">
                                                            <span class="corner-fold"></span>
                                                            <%= ext.toUpperCase() %>
                                                        </div>
                                                        <div>
                                                            <div style="font-family:'Spectral', serif; font-size:14.5px; font-weight:600; color:var(--ink);">
                                                                <%= d.getNomFichier() %>
                                                            </div>
                                                            <div style="font-family:'JetBrains Mono', monospace; font-size:11px; color:var(--muted); margin-top:2px;">
                                                                <%= d.getCheminComplet() %>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td style="font-family:'JetBrains Mono', monospace; font-size:12px; color:var(--muted);"><%= d.getTaille() %></td>
                                                <td style="font-family:'JetBrains Mono', monospace; font-size:12px; color:var(--muted);"><%= d.getDateFichier() %></td>
                                                <td style="font-size:13px;"><%= d.getAuteur() %></td>
                                                <td style="text-align:right;">
                                                    <a href="<%= request.getContextPath() %>/documents?download=<%= d.getId() %>" class="action-icon-btn" title="Télécharger">⤓</a>
                                                    <button type="button" class="action-icon-btn" onclick="previewDoc('<%= d.getNomFichier() %>', '<%= d.getCheminComplet() %>', '<%= d.getAuteur() %>', '<%= d.getDateFichier() %>', '<%= d.getTaille() %>', '<%= d.getDescription() != null ? d.getDescription().replace("'", "\\'") : "" %>')" title="Aperçu">◉</button>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            <% } %>
                        </div>
                    <% } else { %>
                        <!-- ARBORESCENCE COURANTE -->
                        <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:14px;">
                            <div style="display:flex; align-items:center; gap:8px; font-family:'Inter', sans-serif; font-size:13.5px;">
                                <span style="color:var(--muted);"><%= selDossier %></span>
                                <span style="color:var(--muted);">/</span>
                                <span style="color:var(--muted);"><%= selSousDossier %></span>
                                <% if (selEdition != null && !selEdition.trim().isEmpty()) { %>
                                    <span style="color:var(--muted);">/</span>
                                    <span style="font-family:'Spectral', serif; font-size:16px; font-weight:600; color:var(--ink);"><%= selEdition %></span>
                                <% } %>
                            </div>
                            <span style="font-family:'JetBrains Mono', monospace; font-size:11.5px; color:var(--muted);"><%= currentDocs.size() %> fichier(s)</span>
                        </div>

                        <!-- UPLOAD DROPZONE -->
                        <% if (canUpload) { %>
                            <div class="upload-dropzone">
                                <div style="display:flex; align-items:center; gap:14px;">
                                    <div style="font-family:'JetBrains Mono', monospace; font-size:26px; color:var(--navy);">⤒</div>
                                    <div>
                                        <div style="font-family:'Spectral', serif; font-size:15px; font-weight:600; color:var(--ink);">
                                            Glissez-déposez un document dans ce dossier
                                        </div>
                                        <div style="font-family:'Inter', sans-serif; font-size:12px; color:var(--muted); margin-top:2px;">
                                            PDF, DOCX, XLSX, ZIP · 50 MB max par fichier · traçabilité & historisation automatiques
                                        </div>
                                    </div>
                                </div>
                                <button type="button" class="btn btn-secondary btn-sm" onclick="openUploadModal()">
                                    Parcourir
                                </button>
                            </div>
                        <% } %>

                        <!-- TABLE DES FICHIERS -->
                        <div class="card" style="padding:0; overflow:hidden;">
                            <% if (currentDocs.isEmpty()) { %>
                                <div style="padding:36px; text-align:center; color:var(--muted);">
                                    Aucun document archivé dans ce sous-dossier pour le moment.
                                </div>
                            <% } else { %>
                                <table class="table" style="margin:0;">
                                    <thead>
                                        <tr style="background:var(--surface-2);">
                                            <th>Nom du fichier</th>
                                            <th>Taille</th>
                                            <th>Date d'archivage</th>
                                            <th>Déposé par</th>
                                            <th style="text-align:right;">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (DocumentLabo doc : currentDocs) { 
                                            String ext = doc.getType() != null ? doc.getType().toLowerCase() : "pdf";
                                        %>
                                            <tr>
                                                <td>
                                                    <div style="display:flex; align-items:center; gap:12px;">
                                                        <div class="file-icon-box type-<%= ext %>">
                                                            <span class="corner-fold"></span>
                                                            <%= ext.toUpperCase() %>
                                                        </div>
                                                        <div>
                                                            <div style="font-family:'Spectral', serif; font-size:14.5px; font-weight:600; color:var(--ink);">
                                                                <%= doc.getNomFichier() %>
                                                            </div>
                                                            <% if (doc.getDescription() != null && !doc.getDescription().trim().isEmpty()) { %>
                                                                <div style="font-size:11.5px; color:var(--muted); margin-top:2px;">
                                                                    <%= doc.getDescription() %>
                                                                </div>
                                                            <% } %>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td style="font-family:'JetBrains Mono', monospace; font-size:12px; color:var(--muted);"><%= doc.getTaille() %></td>
                                                <td style="font-family:'JetBrains Mono', monospace; font-size:12px; color:var(--muted);"><%= doc.getDateFichier() %></td>
                                                <td style="font-size:12.5px;"><%= doc.getAuteur() %></td>
                                                <td style="text-align:right;">
                                                    <div style="display:inline-flex; gap:6px;">
                                                        <a href="<%= request.getContextPath() %>/documents?download=<%= doc.getId() %>" class="action-icon-btn" title="Télécharger">⤓</a>
                                                        <button type="button" class="action-icon-btn" onclick="previewDoc('<%= doc.getNomFichier() %>', '<%= doc.getCheminComplet() %>', '<%= doc.getAuteur() %>', '<%= doc.getDateFichier() %>', '<%= doc.getTaille() %>', '<%= doc.getDescription() != null ? doc.getDescription().replace("'", "\\'") : "" %>')" title="Aperçu">◉</button>
                                                        <button type="button" class="action-icon-btn" onclick="alert('Historique des révisions : Version v1.0 déposée le <%= doc.getDateFichier() %> par <%= doc.getAuteur() %>')" title="Historique">⟲</button>
                                                    </div>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            <% } %>
                        </div>
                    <% } %>
                </div>
            </div>
            </div>
        </main>
    </div>
</div>

    <!-- MODAL TÉLÉVERSEMENT -->
    <div id="uploadModal" class="modal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.6); z-index:9999; align-items:center; justify-content:center;">
        <div class="modal-card" style="background:var(--surface); border:1px solid var(--border); border-radius:6px; width:100%; max-width:540px; padding:24px; box-shadow:0 12px 32px rgba(0,0,0,0.25);">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:18px; border-bottom:1px solid var(--border); padding-bottom:12px;">
                <h3 style="font-family:'Spectral', serif; font-size:18px; margin:0; color:var(--ink);">Archiver un nouveau document</h3>
                <button type="button" onclick="closeUploadModal()" style="background:none; border:none; font-size:20px; cursor:pointer; color:var(--muted);">✕</button>
            </div>
            <form action="<%= request.getContextPath() %>/documents" method="POST">
                <input type="hidden" name="dossier" value="<%= selDossier %>">
                <input type="hidden" name="sousDossier" value="<%= selSousDossier %>">
                <input type="hidden" name="edition" value="<%= selEdition != null ? selEdition : "" %>">

                <div class="form-group" style="margin-bottom:14px;">
                    <label style="display:block; font-size:12px; font-weight:600; text-transform:uppercase; color:var(--muted); margin-bottom:6px;">Dossier de destination</label>
                    <input type="text" readonly value="<%= selDossier %> / <%= selSousDossier %><%= selEdition != null ? " / " + selEdition : "" %>" style="width:100%; padding:8px 12px; background:var(--surface-2); border:1px solid var(--border); border-radius:3px; font-size:13px;">
                </div>

                <div class="form-group" style="margin-bottom:14px;">
                    <label style="display:block; font-size:12px; font-weight:600; text-transform:uppercase; color:var(--muted); margin-bottom:6px;">Nom du fichier *</label>
                    <input type="text" name="nomFichier" required placeholder="Ex: Rapport_Synthese_CASA-DATA_2025.pdf" style="width:100%; padding:8px 12px; border:1px solid var(--border); border-radius:3px; font-size:13.5px;">
                </div>

                <div style="display:grid; grid-template-columns: 1fr 1fr; gap:12px; margin-bottom:14px;">
                    <div class="form-group">
                        <label style="display:block; font-size:12px; font-weight:600; text-transform:uppercase; color:var(--muted); margin-bottom:6px;">Type / Format</label>
                        <select name="type" style="width:100%; padding:8px 12px; border:1px solid var(--border); border-radius:3px; font-size:13px;">
                            <option value="pdf">Document PDF (.pdf)</option>
                            <option value="docx">Document Word (.docx)</option>
                            <option value="xlsx">Feuille Excel (.xlsx)</option>
                            <option value="zip">Archive ZIP (.zip)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label style="display:block; font-size:12px; font-weight:600; text-transform:uppercase; color:var(--muted); margin-bottom:6px;">Fichier source</label>
                        <input type="file" style="font-size:12px; padding:6px 0;">
                    </div>
                </div>

                <div class="form-group" style="margin-bottom:18px;">
                    <label style="display:block; font-size:12px; font-weight:600; text-transform:uppercase; color:var(--muted); margin-bottom:6px;">Description / Contexte</label>
                    <textarea name="description" rows="3" placeholder="Précisez le contenu ou l'usage officiel du document..." style="width:100%; padding:8px 12px; border:1px solid var(--border); border-radius:3px; font-size:13px;"></textarea>
                </div>

                <div style="display:flex; justify-content:flex-end; gap:10px;">
                    <button type="button" class="btn btn-ghost" onclick="closeUploadModal()">Annuler</button>
                    <button type="submit" class="btn btn-primary">⤒ Enregistrer & Archiver</button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL APERÇU -->
    <div id="previewModal" class="modal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.6); z-index:9999; align-items:center; justify-content:center;">
        <div class="modal-card" style="background:var(--surface); border:1px solid var(--border); border-radius:6px; width:100%; max-width:520px; padding:24px; box-shadow:0 12px 32px rgba(0,0,0,0.25);">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px; border-bottom:1px solid var(--border); padding-bottom:10px;">
                <h3 id="prevTitle" style="font-family:'Spectral', serif; font-size:18px; margin:0; color:var(--ink);">Fiche Document</h3>
                <button type="button" onclick="closePreviewModal()" style="background:none; border:none; font-size:20px; cursor:pointer; color:var(--muted);">✕</button>
            </div>
            <div style="display:flex; flex-direction:column; gap:10px; font-size:13.5px; color:var(--ink);">
                <div><strong>Emplacement :</strong> <span id="prevPath" style="font-family:'JetBrains Mono'; font-size:12px; color:var(--muted);"></span></div>
                <div><strong>Auteur :</strong> <span id="prevAuteur"></span></div>
                <div><strong>Date :</strong> <span id="prevDate" style="font-family:'JetBrains Mono'; font-size:12px;"></span> · <strong>Taille :</strong> <span id="prevSize" style="font-family:'JetBrains Mono'; font-size:12px;"></span></div>
                <div style="margin-top:8px; padding:12px; background:var(--surface-2); border-radius:4px; font-size:13px; line-height:1.5;">
                    <strong>Résumé / Description :</strong>
                    <p id="prevDesc" style="margin:6px 0 0 0; color:var(--ink);"></p>
                </div>
            </div>
            <div style="display:flex; justify-content:flex-end; margin-top:18px;">
                <button type="button" class="btn btn-secondary" onclick="closePreviewModal()">Fermer</button>
            </div>
        </div>
    </div>

    <script>
        function openUploadModal() {
            document.getElementById('uploadModal').style.display = 'flex';
        }
        function closeUploadModal() {
            document.getElementById('uploadModal').style.display = 'none';
        }
        function previewDoc(name, path, auteur, date, size, desc) {
            document.getElementById('prevTitle').innerText = name;
            document.getElementById('prevPath').innerText = path;
            document.getElementById('prevAuteur').innerText = auteur;
            document.getElementById('prevDate').innerText = date;
            document.getElementById('prevSize').innerText = size;
            document.getElementById('prevDesc').innerText = desc || 'Document institutionnel archivé.';
            document.getElementById('previewModal').style.display = 'flex';
        }
        function closePreviewModal() {
            document.getElementById('previewModal').style.display = 'none';
        }
    </script>
</body>
</html>
