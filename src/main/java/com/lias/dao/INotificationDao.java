package com.lias.dao;

import java.util.List;
import com.lias.beans.NotificationLabo;

/**
 * Interface DAO pour les notifications (CDC §19).
 */
public interface INotificationDao {
    List<NotificationLabo> findAll();
    List<NotificationLabo> findByKind(String kind);
    List<NotificationLabo> findUnread();
    boolean markAsRead(int id);
    boolean markAllAsRead();
    boolean save(NotificationLabo notif);
}
