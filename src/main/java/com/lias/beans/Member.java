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
    private String photo;  // URL de la photo de profil (CDC §3)
    private String etablissementOrigine; // Faculté des Sciences Ben M'Sik, etc. (CDC §3)
    private String laboratoireOrigine;   // LIAS, etc. (CDC §3)
    private String biographie;          // Biographie scientifique (CDC §3)
    private String centresInteret;      // Centres d'intérêt de recherche (CDC §3)
    private String dateNaissance;       // Date de naissance confidentielle (CDC §4.2)
    private String dateEmbauche;        // Date d'embauche universitaire (CDC §4.2)
    private String dateAffiliation;     // Date d'affiliation au laboratoire LIAS (Clé métier CDC §4.2)

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
        this.etablissementOrigine = "Faculté des Sciences Ben M'Sik";
        this.laboratoireOrigine = "LIAS";
    }

    public Member(String id, String firstName, String lastName, String email, String status, String role, String team, String grade,
                  String photo, String etablissementOrigine, String laboratoireOrigine, String biographie, String centresInteret) {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.status = status;
        this.role = role;
        this.team = team;
        this.grade = grade;
        this.photo = photo;
        this.etablissementOrigine = etablissementOrigine;
        this.laboratoireOrigine = laboratoireOrigine;
        this.biographie = biographie;
        this.centresInteret = centresInteret;
    }

    public Member(String id, String firstName, String lastName, String email, String status, String role, String team, String grade,
                  String photo, String etablissementOrigine, String laboratoireOrigine, 
                  String dateNaissance, String dateEmbauche, String dateAffiliation,
                  String biographie, String centresInteret) {
        this(id, firstName, lastName, email, status, role, team, grade, photo, etablissementOrigine, laboratoireOrigine, biographie, centresInteret);
        this.dateNaissance = dateNaissance;
        this.dateEmbauche = dateEmbauche;
        this.dateAffiliation = dateAffiliation;
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

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public String getEtablissementOrigine() {
        return etablissementOrigine;
    }

    public void setEtablissementOrigine(String etablissementOrigine) {
        this.etablissementOrigine = etablissementOrigine;
    }

    public String getLaboratoireOrigine() {
        return laboratoireOrigine;
    }

    public void setLaboratoireOrigine(String laboratoireOrigine) {
        this.laboratoireOrigine = laboratoireOrigine;
    }

    public String getBiographie() {
        return biographie;
    }

    public void setBiographie(String biographie) {
        this.biographie = biographie;
    }

    public String getCentresInteret() {
        return centresInteret;
    }

    public void setCentresInteret(String centresInteret) {
        this.centresInteret = centresInteret;
    }

    public String getDateNaissance() {
        return dateNaissance;
    }

    public void setDateNaissance(String dateNaissance) {
        this.dateNaissance = dateNaissance;
    }

    public String getDateEmbauche() {
        return dateEmbauche;
    }

    public void setDateEmbauche(String dateEmbauche) {
        this.dateEmbauche = dateEmbauche;
    }

    public String getDateAffiliation() {
        return dateAffiliation;
    }

    public void setDateAffiliation(String dateAffiliation) {
        this.dateAffiliation = dateAffiliation;
    }

    // Alias francophones
    public String getEtablissement() {
        return etablissementOrigine != null ? etablissementOrigine : "Faculté des Sciences Ben M'Sik";
    }

    public String getLaboratoire() {
        return laboratoireOrigine != null ? laboratoireOrigine : "LIAS";
    }
}
