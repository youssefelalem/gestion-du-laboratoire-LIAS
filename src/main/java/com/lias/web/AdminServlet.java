package com.lias.web;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import com.lias.beans.LaboratoireInfo;
import com.lias.beans.User;
import com.lias.dao.DBConnection;
import com.lias.dao.IUserDao;
import com.lias.dao.UserDaoImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Contrôleur d'administration technique (CDC §5.1 : Administrateur Système).
 * Gère les 3 volets fondamentaux :
 *  1. Comptes utilisateurs (RBAC, activation, rôles, mot de passe)
 *  2. Paramétrage (Données institutionnelles, quotas, campagnes)
 *  3. Maintenance (Diagnostics serveur, état MySQL, sauvegarde SQL, mode maintenance)
 */
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IUserDao userDao;

    @Override
    public void init() throws ServletException {
        this.userDao = new UserDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = null;
        if (session != null) {
            user = (User) session.getAttribute("currentUser");
            if (user == null) user = (User) session.getAttribute("user");
        }

        boolean isAuthorized = user != null && ("admin".equalsIgnoreCase(user.getRole()) || "directeur".equalsIgnoreCase(user.getRole()));
        if (!isAuthorized) {
            request.setAttribute("requiredRole", "Directeur du Laboratoire ou Administrateur Système");
            request.setAttribute("deniedUrl", request.getRequestURI());
            request.getRequestDispatcher("/WEB-INF/views/errors/403.jsp").forward(request, response);
            return;
        }

        String action = request.getParameter("action");

        // Action de téléchargement de sauvegarde SQL (Export Backup)
        if ("exportBackup".equalsIgnoreCase(action)) {
            exportBackup(response);
            return;
        }

        // Onglet actif : "users" par défaut, ou "params", ou "maintenance"
        String tab = request.getParameter("tab");
        if (tab == null || tab.trim().isEmpty()) {
            tab = "users";
        }
        request.setAttribute("activeTab", tab);
        request.setAttribute("activeAdminTab", tab);

        // 1. Données pour l'onglet Comptes Utilisateurs
        List<User> users = userDao.findAll();
        request.setAttribute("users", users);

        // 2. Données pour l'onglet Paramétrage
        LaboratoireInfo labInfo = getLaboratoireInfo();
        request.setAttribute("labInfo", labInfo);

        // 3. Données pour l'onglet Maintenance & Diagnostics
        computeDiagnostics(request);

        request.setAttribute("activeMenu", "admin");
        request.setAttribute("activeNav", "admin");

        request.getRequestDispatcher("/WEB-INF/views/admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentAdmin = null;
        if (session != null) {
            currentAdmin = (User) session.getAttribute("currentUser");
            if (currentAdmin == null) currentAdmin = (User) session.getAttribute("user");
        }

        boolean isAuthorized = currentAdmin != null && ("admin".equalsIgnoreCase(currentAdmin.getRole()) || "directeur".equalsIgnoreCase(currentAdmin.getRole()));
        if (!isAuthorized) {
            request.setAttribute("requiredRole", "Directeur du Laboratoire ou Administrateur Système");
            request.setAttribute("deniedUrl", request.getRequestURI());
            request.getRequestDispatcher("/WEB-INF/views/errors/403.jsp").forward(request, response);
            return;
        }

        String action = request.getParameter("action");
        String redirectTab = "users";

        if ("toggleActif".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                Long id = Long.parseLong(idStr);
                User targetUser = userDao.findById(id);
                if (targetUser != null && !targetUser.getId().equals(currentAdmin.getId())) {
                    targetUser.setActif(!targetUser.isActif());
                    userDao.update(targetUser);
                }
            }
            redirectTab = "users";
        } else if ("changeRole".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("id");
            String newRole = request.getParameter("role");
            if (idStr != null && newRole != null) {
                Long id = Long.parseLong(idStr);
                User targetUser = userDao.findById(id);
                if (targetUser != null) {
                    targetUser.setRole(newRole);
                    userDao.update(targetUser);
                }
            }
            redirectTab = "users";
        } else if ("resetPassword".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("id");
            String newPass = request.getParameter("newPassword");
            if (idStr != null && newPass != null && !newPass.trim().isEmpty()) {
                Long id = Long.parseLong(idStr);
                userDao.updatePassword(id, newPass.trim());
            }
            redirectTab = "users";
        } else if ("create".equalsIgnoreCase(action)) {
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            if (nom != null && prenom != null && email != null && password != null) {
                User newUser = new User();
                newUser.setNom(nom.trim());
                newUser.setPrenom(prenom.trim());
                newUser.setEmail(email.trim());
                newUser.setPassword(password.trim());
                newUser.setRole(role != null ? role.trim() : "visiteur");
                newUser.setActif(true);

                userDao.save(newUser);
            }
            redirectTab = "users";
        } else if ("updateParams".equalsIgnoreCase(action)) {
            // Mise à jour des paramètres institutionnels du laboratoire (CDC §4.1 & §5.1)
            LaboratoireInfo info = getLaboratoireInfo();
            String code = request.getParameter("code");
            String nomComplet = request.getParameter("nomComplet");
            String dateCreation = request.getParameter("dateCreation");
            String etablissement = request.getParameter("etablissement");
            String universite = request.getParameter("universite");
            boolean adhésionOuverte = request.getParameter("campagneAdhesion") != null;
            String maxUploadStr = request.getParameter("maxUploadMB");

            if (code != null) info.setCode(code.trim());
            if (nomComplet != null) info.setNomComplet(nomComplet.trim());
            if (dateCreation != null) info.setDateCreation(dateCreation.trim());
            if (etablissement != null) info.setEtablissement(etablissement.trim());
            if (universite != null) info.setUniversite(universite.trim());
            info.setCampagneAdhesionOuverte(adhésionOuverte);
            if (maxUploadStr != null) {
                try {
                    info.setMaxUploadMB(Integer.parseInt(maxUploadStr.trim()));
                } catch (NumberFormatException ignored) {}
            }

            saveLaboratoireInfo(info);
            redirectTab = "params";
        } else if ("toggleMaintenance".equalsIgnoreCase(action)) {
            // Basculer l'état du mode maintenance (CDC §5.1)
            Boolean currentMode = (Boolean) getServletContext().getAttribute("MAINTENANCE_MODE");
            boolean nextMode = (currentMode == null) ? true : !currentMode;
            getServletContext().setAttribute("MAINTENANCE_MODE", nextMode);
            redirectTab = "maintenance";
        }

        response.sendRedirect(request.getContextPath() + "/admin?tab=" + redirectTab + "&success=updated");
    }

    private LaboratoireInfo getLaboratoireInfo() {
        LaboratoireInfo info = new LaboratoireInfo();
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            String sql = "SELECT * FROM laboratoire_info WHERE id = 1";
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    info.setId(rs.getInt("id"));
                    info.setCode(rs.getString("code"));
                    info.setNomComplet(rs.getString("nom_complet"));
                    info.setDateCreation(rs.getString("date_creation"));
                    info.setEtablissement(rs.getString("etablissement"));
                    info.setUniversite(rs.getString("universite"));
                }
            } catch (SQLException e) {
                System.err.println("[AdminServlet] Info laboratoire lue depuis le bean par défaut : " + e.getMessage());
            }
        }
        Boolean ad = (Boolean) getServletContext().getAttribute("CAMPAGNE_ADHESION_OUVERTE");
        if (ad != null) info.setCampagneAdhesionOuverte(ad);
        Integer up = (Integer) getServletContext().getAttribute("MAX_UPLOAD_MB");
        if (up != null) info.setMaxUploadMB(up);
        return info;
    }

    private void saveLaboratoireInfo(LaboratoireInfo info) {
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            String sql = "UPDATE laboratoire_info SET code=?, nom_complet=?, date_creation=?, etablissement=?, universite=? WHERE id = 1";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, info.getCode());
                ps.setString(2, info.getNomComplet());
                ps.setString(3, info.getDateCreation());
                ps.setString(4, info.getEtablissement());
                ps.setString(5, info.getUniversite());
                ps.executeUpdate();
            } catch (SQLException e) {
                System.err.println("[AdminServlet] Erreur mise à jour laboratoire_info : " + e.getMessage());
            }
        }
        getServletContext().setAttribute("CAMPAGNE_ADHESION_OUVERTE", info.isCampagneAdhesionOuverte());
        getServletContext().setAttribute("MAX_UPLOAD_MB", info.getMaxUploadMB());
    }

    private void computeDiagnostics(HttpServletRequest request) {
        // 1. Diagnostic base de données
        long startPing = System.currentTimeMillis();
        boolean dbOk = false;
        String dbError = null;
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null && !conn.isClosed()) {
                dbOk = true;
            }
        } catch (SQLException e) {
            dbError = e.getMessage();
        }
        long dbLatency = System.currentTimeMillis() - startPing;

        request.setAttribute("dbConnected", dbOk);
        request.setAttribute("dbLatency", dbLatency);
        request.setAttribute("dbError", dbError);

        // 2. Diagnostic JVM & Mémoire
        Runtime rt = Runtime.getRuntime();
        long maxMem = rt.maxMemory() / (1024 * 1024);
        long totalMem = rt.totalMemory() / (1024 * 1024);
        long freeMem = rt.freeMemory() / (1024 * 1024);
        long usedMem = totalMem - freeMem;
        int memoryPercent = maxMem > 0 ? (int) ((usedMem * 100) / maxMem) : 0;

        request.setAttribute("jvmUsedMemory", usedMem);
        request.setAttribute("jvmTotalMemory", totalMem);
        request.setAttribute("jvmMaxMemory", maxMem);
        request.setAttribute("jvmPercent", memoryPercent);

        // 3. Diagnostic environnement serveur
        request.setAttribute("javaVersion", System.getProperty("java.version"));
        request.setAttribute("osName", System.getProperty("os.name"));
        request.setAttribute("serverInfo", getServletContext().getServerInfo());

        // 4. État du mode maintenance
        Boolean isMaintenance = (Boolean) getServletContext().getAttribute("MAINTENANCE_MODE");
        request.setAttribute("maintenanceMode", Boolean.TRUE.equals(isMaintenance));
    }

    private void exportBackup(HttpServletResponse response) throws IOException {
        String filename = "lias_backup_" + LocalDate.now() + ".sql";
        response.setContentType("application/sql; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

        try (OutputStream out = response.getOutputStream()) {
            // Essayer de lire le fichier schema.sql du projet
            Path path = Paths.get("schema.sql");
            if (!Files.exists(path)) {
                String realPath = getServletContext().getRealPath("/schema.sql");
                if (realPath != null) path = Paths.get(realPath);
            }

            if (Files.exists(path)) {
                Files.copy(path, out);
            } else {
                String fallbackHeader = "-- =========================================================\n"
                    + "-- SAUVEGARDE DE BASE DE DONNEES — LABORATOIRE LIAS\n"
                    + "-- Date de génération : " + LocalDateTime.now() + "\n"
                    + "-- Projet JEE — Faculté des Sciences Ben M'Sik Casablanca\n"
                    + "-- =========================================================\n\n";
                out.write(fallbackHeader.getBytes(StandardCharsets.UTF_8));
            }
            out.flush();
        }
    }
}
