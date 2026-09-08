package com.lias.beans;

import java.io.Serializable;

/**
 * JavaBean représentant un document archivé du laboratoire (CDC §10).
 */
public class DocumentLabo implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;
    private String dossier;         // ex: "Évènements", "Administratif"
    private String sousDossier;     // ex: "CASA-DATA", "Journée Doctorants", "Conventions"
    private String editionRubrique; // ex: "2025 — 7e édition", "2026-4e édition", null
    private String nomFichier;      // ex: "Programme_CASA-DATA_2025.pdf"
    private String taille;          // ex: "412 KB", "1.2 MB"
    private String dateFichier;     // ex: "2025-09-01"
    private String type;            // ex: "pdf", "docx", "xlsx", "zip"
    private String auteur;          // ex: "S. Bennani", "Y. El Amrani"
    private String description;

    public DocumentLabo() {
    }

    public DocumentLabo(Integer id, String dossier, String sousDossier, String editionRubrique,
                        String nomFichier, String taille, String dateFichier, String type, String auteur, String description) {
        this.id = id;
        this.dossier = dossier;
        this.sousDossier = sousDossier;
        this.editionRubrique = editionRubrique;
        this.nomFichier = nomFichier;
        this.taille = taille;
        this.dateFichier = dateFichier;
        this.type = type;
        this.auteur = auteur;
        this.description = description;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getDossier() {
        return dossier;
    }

    public void setDossier(String dossier) {
        this.dossier = dossier;
    }

    public String getSousDossier() {
        return sousDossier;
    }

    public void setSousDossier(String sousDossier) {
        this.sousDossier = sousDossier;
    }

    public String getEditionRubrique() {
        return editionRubrique;
    }

    public void setEditionRubrique(String editionRubrique) {
        this.editionRubrique = editionRubrique;
    }

    public String getNomFichier() {
        return nomFichier;
    }

    public void setNomFichier(String nomFichier) {
        this.nomFichier = nomFichier;
    }

    public String getTaille() {
        return taille;
    }

    public void setTaille(String taille) {
        this.taille = taille;
    }

    public String getDateFichier() {
        return dateFichier;
    }

    public void setDateFichier(String dateFichier) {
        this.dateFichier = dateFichier;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getAuteur() {
        return auteur;
    }

    public void setAuteur(String auteur) {
        this.auteur = auteur;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCheminComplet() {
        StringBuilder sb = new StringBuilder();
        if (dossier != null) sb.append(dossier);
        if (sousDossier != null) sb.append(" / ").append(sousDossier);
        if (editionRubrique != null && !editionRubrique.trim().isEmpty()) sb.append(" / ").append(editionRubrique);
        return sb.toString();
    }
}
