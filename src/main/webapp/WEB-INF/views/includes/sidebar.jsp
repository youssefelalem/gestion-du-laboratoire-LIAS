<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lias.beans.User"%>
<%
    User sbUser = (User) session.getAttribute("currentUser");
    if (sbUser == null) sbUser = (User) session.getAttribute("user");
    String sbRole = sbUser != null ? sbUser.getRole() : "visiteur";
    boolean sbIsDir = "directeur".equalsIgnoreCase(sbRole) || "admin".equalsIgnoreCase(sbRole);
    String activeNav = (String) request.getAttribute("activeNav");
    if (activeNav == null) {
        String servletPath = request.getServletPath();
        if (servletPath != null) {
            if (servletPath.contains("home")) activeNav = "dashboard";
            else if (servletPath.contains("member") || servletPath.contains("profil")) activeNav = "profils";
            else if (servletPath.contains("publication")) activeNav = "publications";
            else if (servletPath.contains("calendrier")) activeNav = "calendrier";
            else if (servletPath.contains("evenement")) activeNav = "evenements";
            else if (servletPath.contains("document")) activeNav = "documents";
            else if (servletPath.contains("communication")) activeNav = "communication";
            else if (servletPath.contains("adhesion")) activeNav = "adhesions";
            else if (servletPath.contains("materiel")) activeNav = "materiel";
            else if (servletPath.contains("rapport")) activeNav = "rapport";
            else if (servletPath.contains("mandat")) activeNav = "mandats";
            else if (servletPath.contains("convention")) activeNav = "conventions";
            else if (servletPath.contains("pv")) activeNav = "pv";
            else if (servletPath.contains("admin")) activeNav = "admin";
            else if (servletPath.contains("notif")) activeNav = "notifications";
            else if (servletPath.contains("recherche")) activeNav = "recherche";
        }
    }
    String activeAdminTab = (String) request.getAttribute("activeAdminTab");
    if (activeAdminTab == null) {
        activeAdminTab = request.getParameter("tab");
        if (activeAdminTab == null || activeAdminTab.isEmpty()) {
            activeAdminTab = "users";
        }
    }

    boolean isMembresOpen = "profils".equals(activeNav) || "mandats".equals(activeNav) || "adhesions".equals(activeNav);
    boolean isRechercheOpen = "publications".equals(activeNav) || "documents".equals(activeNav) || "evenements".equals(activeNav) || "calendrier".equals(activeNav) || "rapport".equals(activeNav);
    boolean isGestionOpen = "materiel".equals(activeNav) || "conventions".equals(activeNav) || "pv".equals(activeNav) || "communication".equals(activeNav);
    boolean isAdminOpen = "admin".equals(activeNav);
%>
<style>
/* Sidebar Submenu & Dropdowns (Inlined for instant styling & cache-resilience) */
.sidebar-dropdown {
  display: flex;
  flex-direction: column;
}

.sidebar-dropdown-toggle {
  width: 100%;
  background: transparent !important;
  border: none !important;
  border-left: 3px solid transparent !important;
  text-align: left;
  display: flex;
  align-items: center;
  gap: 11px;
  padding: 8.5px 12px;
  font-family: var(--font-sans, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif);
  font-size: 13px;
  color: #334155;
  border-radius: 0 4px 4px 0;
  transition: all 0.15s ease;
  cursor: pointer;
  outline: none;
  box-shadow: none;
}

.sidebar-dropdown-toggle:hover {
  background: #F1F5F9 !important;
  color: #0F172A;
}

.sidebar-dropdown-toggle:hover .nav-glyph {
  color: var(--primary, #2563EB);
}

.sidebar-dropdown-toggle.active {
  border-left-color: var(--primary, #2563EB) !important;
  background: linear-gradient(90deg, #EFF6FF 0%, rgba(239, 246, 255, 0.35) 100%) !important;
  font-weight: 600;
  color: var(--primary-dark, #1E40AF);
}

.sidebar-dropdown-toggle.active .nav-glyph {
  color: var(--primary, #2563EB);
}

.sidebar-dropdown-toggle .nav-arrow {
  margin-left: auto;
  font-size: 10px;
  color: var(--muted, #64748B);
  transition: transform 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  align-items: center;
}

.sidebar-dropdown.open .sidebar-dropdown-toggle .nav-arrow {
  transform: rotate(90deg);
  color: var(--primary, #2563EB);
}

.sidebar-submenu {
  display: none;
  flex-direction: column;
  gap: 2px;
  padding: 4px 0 4px 14px;
  margin-left: 20px;
  border-left: 1.5px solid #CBD5E1;
  animation: submenuSlideDown 0.2s ease-out forwards;
}

.sidebar-dropdown.open .sidebar-submenu {
  display: flex;
}

@keyframes submenuSlideDown {
  from {
    opacity: 0;
    transform: translateY(-5px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.sidebar-sub-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 6.5px 10px;
  font-family: var(--font-sans, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif);
  font-size: 12.5px;
  color: #64748B;
  text-decoration: none !important;
  border-radius: 4px;
  transition: all 0.15s ease;
}

.sidebar-sub-item:hover {
  color: var(--primary-dark, #1E40AF);
  background: #F8FAFC;
  transform: translateX(2px);
}

.sidebar-sub-item .sub-dot {
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background: #94A3B8;
  transition: all 0.15s ease;
  flex-shrink: 0;
}

.sidebar-sub-item:hover .sub-dot {
  background: var(--primary, #2563EB);
  transform: scale(1.3);
}

.sidebar-sub-item.active {
  color: var(--primary-dark, #1E40AF);
  font-weight: 700;
  background: #EFF6FF;
}

.sidebar-sub-item.active .sub-dot {
  background: var(--primary, #2563EB);
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.2);
}
</style>
<aside class="app-sidebar">
    <div class="sidebar-scroll">
        <!-- PRINCIPAL -->
        <div class="sidebar-section">
            <a href="<%= request.getContextPath() %>/home" class="sidebar-nav-item <%= "dashboard".equals(activeNav) ? "active" : "" %>">
                <span class="nav-glyph"><i class="fa-solid fa-gauge-high"></i></span>
                <span class="nav-label">Tableau de bord</span>
            </a>
        </div>

        <!-- ESPACES DE TRAVAIL GROUPÉS (ACCORDION) -->
        <div class="sidebar-section">
            <div class="sidebar-section-title">Espaces de travail</div>

            <!-- 1. Membres & Direction -->
            <div class="sidebar-dropdown <%= isMembresOpen ? "open" : "" %>">
                <button type="button" class="sidebar-dropdown-toggle <%= isMembresOpen ? "active" : "" %>" onclick="toggleSidebarSubmenu(this)">
                    <span class="nav-glyph"><i class="fa-solid fa-users"></i></span>
                    <span class="nav-label">Membres & Équipe</span>
                    <span class="nav-arrow"><i class="fa-solid fa-chevron-right"></i></span>
                </button>
                <div class="sidebar-submenu">
                    <a href="<%= request.getContextPath() %>/profils" class="sidebar-sub-item <%= "profils".equals(activeNav) ? "active" : "" %>">
                        <span class="sub-dot"></span>
                        <span class="nav-label">Profils & Annuaire</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/mandats" class="sidebar-sub-item <%= "mandats".equals(activeNav) ? "active" : "" %>">
                        <span class="sub-dot"></span>
                        <span class="nav-label">Mandats & Direction</span>
                        <% if (!sbIsDir && !"permanent".equalsIgnoreCase(sbRole)) { %>
                            <span class="nav-lock" title="Module interne (CDC §2.2 C)"><i class="fa-solid fa-lock" style="font-size:9px;"></i></span>
                        <% } %>
                    </a>
                    <a href="<%= request.getContextPath() %>/adhesions" class="sidebar-sub-item <%= "adhesions".equals(activeNav) ? "active" : "" %>">
                        <span class="sub-dot"></span>
                        <span class="nav-label">Demandes d'adhésion</span>
                        <% if (!sbIsDir && !"permanent".equalsIgnoreCase(sbRole)) { %>
                            <span class="nav-lock" title="Réservé à la direction"><i class="fa-solid fa-lock" style="font-size:9px;"></i></span>
                        <% } %>
                    </a>
                </div>
            </div>

            <!-- 2. Recherche Scientifique -->
            <div class="sidebar-dropdown <%= isRechercheOpen ? "open" : "" %>">
                <button type="button" class="sidebar-dropdown-toggle <%= isRechercheOpen ? "active" : "" %>" onclick="toggleSidebarSubmenu(this)">
                    <span class="nav-glyph"><i class="fa-solid fa-flask-vial"></i></span>
                    <span class="nav-label">Recherche & Activités</span>
                    <span class="nav-arrow"><i class="fa-solid fa-chevron-right"></i></span>
                </button>
                <div class="sidebar-submenu">
                    <a href="<%= request.getContextPath() %>/publications" class="sidebar-sub-item <%= "publications".equals(activeNav) ? "active" : "" %>">
                        <span class="sub-dot"></span>
                        <span class="nav-label">Publications</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/documents" class="sidebar-sub-item <%= "documents".equals(activeNav) ? "active" : "" %>">
                        <span class="sub-dot"></span>
                        <span class="nav-label">Archive Documentaire</span>
                        <% if (!sbIsDir && !"permanent".equalsIgnoreCase(sbRole)) { %>
                            <span class="nav-lock" title="Module interne (CDC §2.2 C)"><i class="fa-solid fa-lock" style="font-size:9px;"></i></span>
                        <% } %>
                    </a>
                    <a href="<%= request.getContextPath() %>/evenements" class="sidebar-sub-item <%= "evenements".equals(activeNav) ? "active" : "" %>">
                        <span class="sub-dot"></span>
                        <span class="nav-label">Évènements</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/calendrier" class="sidebar-sub-item <%= "calendrier".equals(activeNav) ? "active" : "" %>">
                        <span class="sub-dot"></span>
                        <span class="nav-label">Calendrier</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/rapport" class="sidebar-sub-item <%= "rapport".equals(activeNav) ? "active" : "" %>">
                        <span class="sub-dot"></span>
                        <span class="nav-label">Rapport annuel</span>
                        <% if (!sbIsDir && !"permanent".equalsIgnoreCase(sbRole)) { %>
                            <span class="nav-lock" title="Réservé aux permanents"><i class="fa-solid fa-lock" style="font-size:9px;"></i></span>
                        <% } %>
                    </a>
                </div>
            </div>

            <!-- 3. Gestion & Logistique -->
            <div class="sidebar-dropdown <%= isGestionOpen ? "open" : "" %>">
                <button type="button" class="sidebar-dropdown-toggle <%= isGestionOpen ? "active" : "" %>" onclick="toggleSidebarSubmenu(this)">
                    <span class="nav-glyph"><i class="fa-solid fa-boxes-stacked"></i></span>
                    <span class="nav-label">Gestion & Ressources</span>
                    <span class="nav-arrow"><i class="fa-solid fa-chevron-right"></i></span>
                </button>
                <div class="sidebar-submenu">
                    <a href="<%= request.getContextPath() %>/materiel" class="sidebar-sub-item <%= "materiel".equals(activeNav) ? "active" : "" %>">
                        <span class="sub-dot"></span>
                        <span class="nav-label">Inventaire Matériel</span>
                        <% if (!sbIsDir && !"permanent".equalsIgnoreCase(sbRole)) { %>
                            <span class="nav-lock" title="Module interne (CDC §2.2 C)"><i class="fa-solid fa-lock" style="font-size:9px;"></i></span>
                        <% } %>
                    </a>
                    <a href="<%= request.getContextPath() %>/conventions" class="sidebar-sub-item <%= "conventions".equals(activeNav) ? "active" : "" %>">
                        <span class="sub-dot"></span>
                        <span class="nav-label">Conventions</span>
                        <% if (!sbIsDir && !"permanent".equalsIgnoreCase(sbRole)) { %>
                            <span class="nav-lock" title="Module interne (CDC §2.2 C)"><i class="fa-solid fa-lock" style="font-size:9px;"></i></span>
                        <% } %>
                    </a>
                    <a href="<%= request.getContextPath() %>/pv" class="sidebar-sub-item <%= "pv".equals(activeNav) ? "active" : "" %>">
                        <span class="sub-dot"></span>
                        <span class="nav-label">Procès-verbaux</span>
                        <% if (!sbIsDir && !"permanent".equalsIgnoreCase(sbRole)) { %>
                            <span class="nav-lock" title="Module interne (CDC §2.2 C)"><i class="fa-solid fa-lock" style="font-size:9px;"></i></span>
                        <% } %>
                    </a>
                    <a href="<%= request.getContextPath() %>/communication" class="sidebar-sub-item <%= "communication".equals(activeNav) ? "active" : "" %>">
                        <span class="sub-dot"></span>
                        <span class="nav-label">Communication</span>
                        <% if (!sbIsDir && !"permanent".equalsIgnoreCase(sbRole)) { %>
                            <span class="nav-lock" title="Module interne (CDC §2.2 C)"><i class="fa-solid fa-lock" style="font-size:9px;"></i></span>
                        <% } %>
                    </a>
                </div>
            </div>

            <!-- 4. Administration Système (Directeur / Admin) -->
            <% if (sbIsDir) { %>
            <div class="sidebar-dropdown <%= isAdminOpen ? "open" : "" %>">
                <button type="button" class="sidebar-dropdown-toggle <%= isAdminOpen ? "active" : "" %>" onclick="toggleSidebarSubmenu(this)">
                    <span class="nav-glyph"><i class="fa-solid fa-shield-halved"></i></span>
                    <span class="nav-label">Administration</span>
                    <span class="nav-arrow"><i class="fa-solid fa-chevron-right"></i></span>
                </button>
                <div class="sidebar-submenu">
                    <a href="<%= request.getContextPath() %>/admin?tab=users" class="sidebar-sub-item <%= (isAdminOpen && "users".equals(activeAdminTab)) ? "active" : "" %>">
                        <span class="sub-dot"></span>
                        <span class="nav-label">Utilisateurs</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/admin?tab=params" class="sidebar-sub-item <%= (isAdminOpen && "params".equals(activeAdminTab)) ? "active" : "" %>">
                        <span class="sub-dot"></span>
                        <span class="nav-label">Paramétrage</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/admin?tab=maintenance" class="sidebar-sub-item <%= (isAdminOpen && "maintenance".equals(activeAdminTab)) ? "active" : "" %>">
                        <span class="sub-dot"></span>
                        <span class="nav-label">Maintenance</span>
                    </a>
                </div>
            </div>
            <% } %>
        </div>
    </div>

    <!-- SIDEBAR FOOTER -->
    <div class="sidebar-footer">
        <a href="<%= request.getContextPath() %>/public" class="sidebar-footer-link"><i class="fa-solid fa-arrow-up-right-from-square" style="font-size:11px; margin-right:4px;"></i> Site public</a>
        <a href="<%= request.getContextPath() %>/logout" class="sidebar-footer-link"><i class="fa-solid fa-right-from-bracket" style="font-size:11px; margin-right:4px;"></i> Déconnexion</a>
        <div class="sidebar-version">v 0.1.0 · projet JEE</div>
    </div>
</aside>

<script>
function toggleSidebarSubmenu(btn) {
    var dropdown = btn.closest('.sidebar-dropdown');
    if (dropdown) {
        dropdown.classList.toggle('open');
    }
}
</script>
