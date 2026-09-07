<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lias.beans.User"%>
<%
    User navUser = (User) session.getAttribute("currentUser");
    if (navUser == null) navUser = (User) session.getAttribute("user");
    String userInitials = "LI";
    if (navUser != null && navUser.getPrenom() != null && navUser.getNom() != null && !navUser.getPrenom().isEmpty() && !navUser.getNom().isEmpty()) {
        userInitials = ("" + navUser.getPrenom().charAt(0) + navUser.getNom().charAt(0)).toUpperCase();
    }
%>
<header class="app-header">
    <div class="header-left">
        <a href="<%= request.getContextPath() %>/home" class="header-brand">
            <div class="brand-mark">L</div>
            <div class="brand-name">LIAS <span class="est">EST. 2003</span></div>
        </a>
        <div class="header-divider"></div>
        <div class="header-institution">
            <div class="inst-faculty">Faculté des Sciences Ben M'Sik</div>
            <div class="inst-univ">Casablanca · Université Hassan II</div>
        </div>
    </div>

    <div class="header-center">
        <div class="header-search-box" onclick="openSearchModal()" role="button" tabindex="0" title="Recherche globale (Ctrl+K)">
            <span class="search-glyph">⌕</span>
            <span class="search-placeholder">Recherche globale…</span>
            <kbd class="search-kbd">⌘K</kbd>
        </div>
    </div>

    <div class="header-right">
        <button type="button" class="header-icon-btn" title="Notifications" onclick="toggleNotifications()">
            <span class="bell-glyph">◉</span>
            <span class="bell-badge">3</span>
        </button>

        <div class="header-user-menu">
            <div class="user-avatar"><%= userInitials %></div>
            <div class="user-meta">
                <div class="user-name"><%= navUser != null ? navUser.getPrenom() + " " + navUser.getNom() : "Utilisateur" %></div>
                <div class="user-role-label">VUE : <%= navUser != null ? navUser.getRole().toUpperCase() : "MEMBRE" %></div>
            </div>
            <div class="user-dropdown-icon">▾</div>
            
            <div class="user-dropdown-popover" id="userPopover" style="display: none;">
                <div class="popover-header">
                    <strong><%= navUser != null ? navUser.getEmail() : "" %></strong>
                    <div style="font-size:11px; color:var(--muted);">Rôle système: <%= navUser != null ? navUser.getRole() : "" %></div>
                </div>
                <div class="popover-divider"></div>
                <a href="<%= request.getContextPath() %>/public" class="popover-item">↗ Site public du LIAS</a>
                <a href="<%= request.getContextPath() %>/profils" class="popover-item">Mon profil chercheur</a>
                <div class="popover-divider"></div>
                <a href="<%= request.getContextPath() %>/logout" class="popover-item danger">Déconnexion</a>
            </div>
        </div>
    </div>
</header>

<!-- Quick Search Modal (⌘K / Ctrl+K) -->
<div id="searchModal" class="search-modal-backdrop" style="display: none;" onclick="if(event.target===this) closeSearchModal()">
    <div class="search-modal-card">
        <div class="search-modal-input-row">
            <span style="font-size:16px; color:var(--muted); font-family:var(--font-mono);">⌕</span>
            <input type="text" id="globalSearchInput" placeholder="Rechercher membre, publication, événement, matériel…" oninput="filterQuickSearch(this.value)">
            <kbd onclick="closeSearchModal()" style="cursor:pointer; font-family:var(--font-mono); font-size:11px; padding:2px 6px; border:1px solid var(--border); border-radius:2px; background:var(--surface);">Échap</kbd>
        </div>
        <div class="search-modal-results" id="searchResults">
            <div class="search-result-group">
                <div class="search-group-title">Raccourcis rapides</div>
                <a href="<%= request.getContextPath() %>/home" class="search-result-item">
                    <span class="sr-icon">⊟</span>
                    <span class="sr-text">Tableau de bord institutionnel</span>
                    <span class="sr-tag">Principal</span>
                </a>
                <a href="<%= request.getContextPath() %>/profils" class="search-result-item">
                    <span class="sr-icon">⊙</span>
                    <span class="sr-text">Profils des chercheurs & doctorants</span>
                    <span class="sr-tag">Annuaire</span>
                </a>
                <a href="<%= request.getContextPath() %>/publications" class="search-result-item">
                    <span class="sr-icon">¶</span>
                    <span class="sr-text">Catalogue des publications scientifiques (Scopus / DBLP)</span>
                    <span class="sr-tag">Recherche</span>
                </a>
                <a href="<%= request.getContextPath() %>/evenements" class="search-result-item">
                    <span class="sr-icon">◇</span>
                    <span class="sr-text">Agenda & Conférences scientifiques</span>
                    <span class="sr-tag">Évènements</span>
                </a>
                <a href="<%= request.getContextPath() %>/rapport" class="search-result-item">
                    <span class="sr-icon">§</span>
                    <span class="sr-text">Rapport annuel d'exercice 2025–2026 (78%)</span>
                    <span class="sr-tag">Gouvernance</span>
                </a>
            </div>
        </div>
    </div>
</div>

<script>
    function openSearchModal() {
        var modal = document.getElementById('searchModal');
        if (modal) {
            modal.style.display = 'flex';
            setTimeout(function() {
                var inp = document.getElementById('globalSearchInput');
                if (inp) inp.focus();
            }, 50);
        }
    }
    function closeSearchModal() {
        var modal = document.getElementById('searchModal');
        if (modal) modal.style.display = 'none';
    }
    document.addEventListener('keydown', function(e) {
        if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
            e.preventDefault();
            var modal = document.getElementById('searchModal');
            if (modal && modal.style.display === 'flex') closeSearchModal();
            else openSearchModal();
        }
        if (e.key === 'Escape') closeSearchModal();
    });

    function toggleNotifications() {
        alert('🔔 Notifications LIAS :\n\n1. 4 demandes d\'adhésion en attente de décision de la direction.\n2. Rapport annuel 2025–2026 complété à 78 %.\n3. Prochain séminaire : Federated Learning sur Edge le 14 juin.');
    }

    function filterQuickSearch(query) {
        query = query.toLowerCase().trim();
        var items = document.querySelectorAll('.search-result-item');
        items.forEach(function(item) {
            var text = item.innerText.toLowerCase();
            if (!query || text.indexOf(query) !== -1) {
                item.style.display = 'flex';
            } else {
                item.style.display = 'none';
            }
        });
    }

    // Toggle user dropdown on click
    document.addEventListener('DOMContentLoaded', function() {
        var userMenu = document.querySelector('.header-user-menu');
        var popover = document.getElementById('userPopover');
        if (userMenu && popover) {
            userMenu.addEventListener('click', function(e) {
                e.stopPropagation();
                if (popover.style.display === 'none' || !popover.style.display) {
                    popover.style.display = 'flex';
                } else {
                    popover.style.display = 'none';
                }
            });
            document.addEventListener('click', function() {
                popover.style.display = 'none';
            });
        }
    });
</script>
