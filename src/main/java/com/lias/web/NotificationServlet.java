package com.lias.web;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.lias.beans.NotificationLabo;
import com.lias.dao.INotificationDao;
import com.lias.dao.NotificationDaoImpl;

/**
 * Contrôleur du Centre de Notifications (CDC §19).
 */
@WebServlet(name = "NotificationServlet", urlPatterns = {"/notifications"})
public class NotificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private INotificationDao notificationDao;

    @Override
    public void init() throws ServletException {
        super.init();
        this.notificationDao = new NotificationDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("markAllRead".equalsIgnoreCase(action) || "mark_all_read".equalsIgnoreCase(action)) {
            notificationDao.markAllAsRead();
            response.sendRedirect(request.getContextPath() + "/notifications?msg=lu");
            return;
        }

        String filter = request.getParameter("filter");
        if (filter == null || filter.trim().isEmpty()) {
            filter = "toutes";
        }

        List<NotificationLabo> notifications;
        if ("non lues".equalsIgnoreCase(filter) || "unread".equalsIgnoreCase(filter)) {
            notifications = notificationDao.findUnread();
        } else if (!"toutes".equalsIgnoreCase(filter)) {
            notifications = notificationDao.findByKind(filter);
        } else {
            notifications = notificationDao.findAll();
        }

        int unreadCount = notificationDao.findUnread().size();
        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadCount", unreadCount);
        request.setAttribute("activeFilter", filter);
        request.setAttribute("activeNav", "notifications");

        request.getRequestDispatcher("/WEB-INF/views/notifications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("markAllRead".equalsIgnoreCase(action)) {
            notificationDao.markAllAsRead();
        } else if ("markRead".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    notificationDao.markAsRead(Integer.parseInt(idStr.trim()));
                } catch (NumberFormatException ignored) {}
            }
        }
        response.sendRedirect(request.getContextPath() + "/notifications?msg=lu");
    }
}
