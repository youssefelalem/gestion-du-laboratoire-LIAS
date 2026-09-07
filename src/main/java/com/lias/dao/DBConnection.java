package com.lias.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Singleton de gestion de la connexion JDBC vers MySQL.
 * Modèle de conception (Design Pattern) classique dans les projets JEE sous Eclipse.
 */
public class DBConnection {
    private static Connection connection = null;

    private static final String HOST = System.getenv("DB_HOST") != null ? System.getenv("DB_HOST") : "localhost";
    private static final String PORT = System.getenv("DB_PORT") != null ? System.getenv("DB_PORT") : "3306";
    private static final String DB_NAME = "lias_db";
    private static final String URL = "jdbc:mysql://" + HOST + ":" + PORT + "/" + DB_NAME + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "lias_user";
    private static final String PASSWORD = "lias_password";

    private DBConnection() {
        // Empêcher l'instanciation directe
    }

    /**
     * Retourne l'instance unique de connexion JDBC.
     */
    public static Connection getConnection() {
        if (connection == null) {
            try {
                // Chargement du Driver JDBC MySQL
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(URL, USER, PASSWORD);
                System.out.println("[DBConnection] Connexion réussie à MySQL (" + URL + ")");
            } catch (ClassNotFoundException e) {
                System.err.println("[DBConnection] Driver MySQL introuvable : " + e.getMessage());
            } catch (SQLException e) {
                System.err.println("[DBConnection] Erreur de connexion à la base de données : " + e.getMessage());
            }
        }
        return connection;
    }

    /**
     * Ferme la connexion courante.
     */
    public static void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
                connection = null;
                System.out.println("[DBConnection] Connexion fermée.");
            } catch (SQLException e) {
                System.err.println("[DBConnection] Erreur lors de la fermeture : " + e.getMessage());
            }
        }
    }
}
