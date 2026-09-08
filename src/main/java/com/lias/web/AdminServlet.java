package com.lias.web;

import java.io.IOException;
import java.util.List;

import com.lias.beans.User;
import com.lias.dao.IUserDao;
import com.lias.dao.UserDaoImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

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

        List<User> users = userDao.findAll();
        request.setAttribute("users", users);
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
        }

        response.sendRedirect(request.getContextPath() + "/admin?success=updated");
    }
}
