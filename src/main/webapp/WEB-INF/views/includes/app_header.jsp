<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.lias.beans.User"%>
<%@ page import="com.lias.beans.NotificationLabo"%>
<%@ page import="com.lias.dao.INotificationDao"%>
<%@ page import="com.lias.dao.NotificationDaoImpl"%>
<%
    User navUser = (User) session.getAttribute("currentUser");
    if (navUser == null) navUser = (User) session.getAttribute("user");
    String userInitials = "LI";
    if (navUser != null && navUser.getPrenom() != null && navUser.getNom() != null && !navUser.getPrenom().isEmpty() && !navUser.getNom().isEmpty()) {
        userInitials = ("" + navUser.getPrenom().charAt(0) + navUser.getNom().charAt(0)).toUpperCase();
    }

    // Dynamic unread notifications calculation (CDC §19)
    Integer reqUnread = (Integer) request.getAttribute("unreadCount");
    int headerUnreadCount = 0;
    List<NotificationLabo> popoverUnreadNotifs = null;
    try {
        INotificationDao notifDaoHelper = new NotificationDaoImpl();
        List<NotificationLabo> unreadList = notifDaoHelper.findUnread();
        headerUnreadCount = unreadList != null ? unreadList.size() : 0;
        popoverUnreadNotifs = unreadList;
        request.setAttribute("unreadCount", headerUnreadCount);
    } catch (Exception e) {
        headerUnreadCount = reqUnread != null ? reqUnread : 0;
    }
%>
<!-- Font Awesome 6 Icons (CDN) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/js/all.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

<header class="app-header">
    <div class="header-left">
        <a href="<%= request.getContextPath() %>/home" class="header-brand">
            <span class="lias-logo" role="img" aria-label="LIAS" style="height: 36px;"></span>
        </a>
        <div class="header-divider"></div>
        <div class="header-institution">
            <div class="inst-faculty">Faculté des Sciences Ben M'Sik</div>
            <div class="inst-univ">Casablanca · Université Hassan II</div>
        </div>
    </div>

    <div class="header-center">
        <div class="header-search-box" onclick="openSearchModal()" role="button" tabindex="0" title="Recherche globale (Ctrl+K)">
            <span class="search-glyph"><i class="fa-solid fa-magnifying-glass"></i></span>
            <span class="search-placeholder">Recherche globale…</span>
            <kbd class="search-kbd">⌘K</kbd>
        </div>
    </div>

    <div class="header-right" style="position: relative;">
        <button type="button" class="header-icon-btn" title="Notifications" onclick="toggleNotifications()">
            <span class="bell-glyph"><i class="fa-solid fa-bell"></i></span>
            <% if (headerUnreadCount > 0) { %>
                <span class="bell-badge"><%= headerUnreadCount %></span>
            <% } %>
        </button>

        <!-- Notifications Dropdown Popover (CDC §19) -->
        <div id="notifPopover" class="user-dropdown-popover" style="display: none; width: 340px; right: 200px; top: 56px; text-align: left; padding: 16px 20px; box-shadow: var(--shadow-md); border-radius: 4px; z-index: 1000;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                <strong style="font-size: 13px; color: var(--navy); font-family: var(--font-serif);"><i class="fa-solid fa-bell" style="margin-right: 6px;"></i>Notifications (CDC §19)</strong>
                <% if (headerUnreadCount > 0) { %>
                    <span class="badge badge-gold" style="font-size: 10px;"><%= headerUnreadCount %> nouvelle<%= headerUnreadCount > 1 ? "s" : "" %></span>
                <% } else { %>
                    <span class="badge badge-sage" style="font-size: 10px;">Toutes lues</span>
                <% } %>
            </div>
            <div class="popover-divider" style="margin: 8px 0;"></div>
            <% if (popoverUnreadNotifs != null && !popoverUnreadNotifs.isEmpty()) { 
                int count = 0;
                for (NotificationLabo un : popoverUnreadNotifs) {
                    if (++count > 4) break;
                    String target = un.getTargetUrl() != null && !un.getTargetUrl().isEmpty() ? un.getTargetUrl() : (request.getContextPath() + "/notifications");
            %>
                <a href="<%= target %>" class="popover-item" style="padding: 8px 0; display: block; text-decoration: none; border-bottom: 1px solid var(--border);">
                    <div style="font-weight: 600; font-size: 12px; color: var(--ink);"><%= un.getWho() != null ? un.getWho() : "Notification" %></div>
                    <div style="font-size: 11px; color: var(--muted);"><%= un.getBody() %></div>
                </a>
            <%  } 
               } else { %>
                <div style="padding: 16px 0; font-size: 12px; color: var(--muted); text-align: center;">
                    Aucune notification non lue.
                </div>
            <% } %>
            <div class="popover-divider" style="margin: 8px 0;"></div>
            <a href="<%= request.getContextPath() %>/notifications" style="display:block; text-align:center; font-size:12px; color:var(--primary); font-weight:600; text-decoration:none; padding:6px 0;">
                Voir toutes les notifications (CDC §19) →
            </a>
        </div>


        <div class="header-user-menu">
            <div class="user-avatar"><%= userInitials %></div>
            <div class="user-meta">
                <div class="user-name"><%= navUser != null ? navUser.getPrenom() + " " + navUser.getNom() : "Utilisateur" %></div>
                <div class="user-role-label">VUE : <%= navUser != null ? navUser.getRole().toUpperCase() : "MEMBRE" %></div>
            </div>
            <div class="user-dropdown-icon"><i class="fa-solid fa-angle-down" style="font-size: 11px;"></i></div>
            
            <div class="user-dropdown-popover" id="userPopover" style="display: none;">
                <div class="popover-header">
                    <strong><%= navUser != null ? navUser.getEmail() : "" %></strong>
                    <div style="font-size:11px; color:var(--muted);">Rôle système: <%= navUser != null ? navUser.getRole() : "" %></div>
                </div>
                <div class="popover-divider"></div>
                <a href="<%= request.getContextPath() %>/public" class="popover-item"><i class="fa-solid fa-arrow-up-right-from-square" style="width:16px; margin-right:6px; color:var(--muted);"></i> Site public du LIAS</a>
                <a href="<%= request.getContextPath() %>/profils" class="popover-item"><i class="fa-solid fa-user" style="width:16px; margin-right:6px; color:var(--muted);"></i> Mon profil chercheur</a>
                <a href="<%= request.getContextPath() %>/notifications" class="popover-item"><i class="fa-solid fa-bell" style="width:16px; margin-right:6px; color:var(--muted);"></i> Centre de notifications</a>
                <div class="popover-divider"></div>
                <a href="<%= request.getContextPath() %>/logout" class="popover-item danger"><i class="fa-solid fa-right-from-bracket" style="width:16px; margin-right:6px;"></i> Déconnexion</a>
            </div>
        </div>
    </div>
</header>

<!-- Quick Search Modal (⌘K / Ctrl+K) -->
<div id="searchModal" class="search-modal-backdrop" style="display: none;" onclick="if(event.target===this) closeSearchModal()">
    <div class="search-modal-card">
        <div class="search-modal-input-row">
            <span style="font-size:14px; color:var(--muted);"><i class="fa-solid fa-magnifying-glass"></i></span>
            <input type="text" id="globalSearchInput" placeholder="Rechercher membre, publication, événement, document… (Entrée pour recherche complète)" oninput="filterQuickSearch(this.value)" onkeydown="if(event.key==='Enter') doGlobalSearch(this.value)">
            <kbd onclick="closeSearchModal()" style="cursor:pointer; font-family:var(--font-mono); font-size:11px; padding:2px 6px; border:1px solid var(--border); border-radius:2px; background:var(--surface);">Échap</kbd>
        </div>
        <div class="search-modal-results" id="searchResults">
            <div class="search-result-group">
                <div class="search-group-title">Raccourcis & Modules</div>
                <a href="<%= request.getContextPath() %>/home" class="search-result-item">
                    <span class="sr-icon"><i class="fa-solid fa-gauge-high"></i></span>
                    <span class="sr-text">Tableau de bord institutionnel</span>
                    <span class="sr-tag">Principal</span>
                </a>
                <a href="<%= request.getContextPath() %>/profils" class="search-result-item">
                    <span class="sr-icon"><i class="fa-solid fa-users"></i></span>
                    <span class="sr-text">Profils des chercheurs & doctorants</span>
                    <span class="sr-tag">Annuaire</span>
                </a>
                <a href="<%= request.getContextPath() %>/calendrier" class="search-result-item">
                    <span class="sr-icon"><i class="fa-solid fa-calendar-days"></i></span>
                    <span class="sr-text">Calendrier scientifique & événements</span>
                    <span class="sr-tag">Agenda</span>
                </a>
                <a href="<%= request.getContextPath() %>/documents" class="search-result-item">
                    <span class="sr-icon"><i class="fa-solid fa-folder-open"></i></span>
                    <span class="sr-text">Archive documentaire institutionnelle</span>
                    <span class="sr-tag">Documents</span>
                </a>
                <a href="<%= request.getContextPath() %>/communication" class="search-result-item">
                    <span class="sr-icon"><i class="fa-solid fa-comments"></i></span>
                    <span class="sr-text">Communication interne & canaux d'équipes</span>
                    <span class="sr-tag">Échanges</span>
                </a>
                <a href="<%= request.getContextPath() %>/publications" class="search-result-item">
                    <span class="sr-icon"><i class="fa-solid fa-book-bookmark"></i></span>
                    <span class="sr-text">Catalogue des publications scientifiques</span>
                    <span class="sr-tag">Recherche</span>
                </a>
                <a href="<%= request.getContextPath() %>/materiel" class="search-result-item">
                    <span class="sr-icon"><i class="fa-solid fa-laptop-code"></i></span>
                    <span class="sr-text">Parc de matériel scientifique & allocations</span>
                    <span class="sr-tag">Équipement</span>
                </a>
                <a href="<%= request.getContextPath() %>/conventions" class="search-result-item">
                    <span class="sr-icon"><i class="fa-solid fa-handshake"></i></span>
                    <span class="sr-text">Conventions & Partenariats institutionnels</span>
                    <span class="sr-tag">Accords</span>
                </a>
                <a href="<%= request.getContextPath() %>/notifications" class="search-result-item">
                    <span class="sr-icon"><i class="fa-solid fa-bell"></i></span>
                    <span class="sr-text">Centre de notifications & alertes</span>
                    <span class="sr-tag">Notifications</span>
                </a>
            </div>
        </div>
    </div>
</div>

<script>
    function doGlobalSearch(val) {
        if (val && val.trim().length > 0) {
            window.location.href = '<%= request.getContextPath() %>/recherche?q=' + encodeURIComponent(val.trim());
        }
    }
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
        var pop = document.getElementById('notifPopover');
        var userPop = document.getElementById('userPopover');
        if (userPop) userPop.style.display = 'none';
        if (pop) {
            pop.style.display = (pop.style.display === 'block') ? 'none' : 'block';
        }
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

    // Toggle user dropdown on click & close on click outside
    document.addEventListener('DOMContentLoaded', function() {
        var userMenu = document.querySelector('.header-user-menu');
        var popover = document.getElementById('userPopover');
        var notifPop = document.getElementById('notifPopover');
        var notifBtn = document.querySelector('.header-icon-btn');

        if (userMenu && popover) {
            userMenu.addEventListener('click', function(e) {
                e.stopPropagation();
                if (notifPop) notifPop.style.display = 'none';
                popover.style.display = (popover.style.display === 'flex') ? 'none' : 'flex';
            });
        }
        if (notifBtn && notifPop) {
            notifBtn.addEventListener('click', function(e) {
                e.stopPropagation();
            });
        }
        document.addEventListener('click', function(e) {
            if (popover) popover.style.display = 'none';
            if (notifPop && !notifPop.contains(e.target)) notifPop.style.display = 'none';
        });
    });
</script>
