package com.lias.beans;

import java.io.Serializable;

/**
 * JavaBean représentant un chercheur / membre du laboratoire LIAS.
 */
public class Member implements Serializable {
    private static final long serialVersionUID = 1L;

    private String id;
    private String firstName;
    private String lastName;
    private String email;
    private String status; // permanent, doctorant, associe, retraité
    private String role;   // directeur, chef-equipe, membre
    private String team;   // IA, Big Data, NLP, Sécurité
    private String grade;  // Professeur, Maître de Conférences, Doctorant

    public Member() {
        super();
    }

    public Member(String id, String firstName, String lastName, String email, String status, String role, String team, String grade) {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.status = status;
        this.role = role;
        this.team = team;
        this.grade = grade;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getTeam() {
        return team;
    }

    public void setTeam(String team) {
        this.team = team;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }

    public String getFullName() {
        return firstName + " " + lastName;
    }

    // Alias francophones pour compatibilité totale avec les vues JSP
    public String getNom() {
        return lastName;
    }

    public void setNom(String nom) {
        this.lastName = nom;
    }

    public String getPrenom() {
        return firstName;
    }

    public void setPrenom(String prenom) {
        this.firstName = prenom;
    }

    public String getEquipe() {
        return team;
    }

    public void setEquipe(String equipe) {
        this.team = equipe;
    }

    public String getStatut() {
        return status;
    }

    public void setStatut(String statut) {
        this.status = statut;
    }

    public String getDateAffiliation() {
        return "2021-09-01";
    }
}
