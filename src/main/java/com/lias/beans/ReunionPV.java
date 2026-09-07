package com.lias.beans;

import java.io.Serializable;
import java.time.LocalDate;

/**
 * Entité JavaBean représentant un procès-verbal (PV) officiel d'assemblée ou de conseil de laboratoire.
 */
public class ReunionPV implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private String titre;
    private LocalDate dateReunion;
    private String ordreDuJour;
    private String cheminFichierPV;
    private String directeurSignataire;

    public ReunionPV() {
    }

    public ReunionPV(Long id, String titre, LocalDate dateReunion, String ordreDuJour, String cheminFichierPV, String directeurSignataire) {
        this.id = id;
        this.titre = titre;
        this.dateReunion = dateReunion;
        this.ordreDuJour = ordreDuJour;
        this.cheminFichierPV = cheminFichierPV;
        this.directeurSignataire = directeurSignataire;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public LocalDate getDateReunion() {
        return dateReunion;
    }

    public void setDateReunion(LocalDate dateReunion) {
        this.dateReunion = dateReunion;
    }

    public String getOrdreDuJour() {
        return ordreDuJour;
    }

    public void setOrdreDuJour(String ordreDuJour) {
        this.ordreDuJour = ordreDuJour;
    }

    public String getCheminFichierPV() {
        return cheminFichierPV;
    }

    public void setCheminFichierPV(String cheminFichierPV) {
        this.cheminFichierPV = cheminFichierPV;
    }

    public String getDirecteurSignataire() {
        return directeurSignataire;
    }

    public void setDirecteurSignataire(String directeurSignataire) {
        this.directeurSignataire = directeurSignataire;
    }
}
