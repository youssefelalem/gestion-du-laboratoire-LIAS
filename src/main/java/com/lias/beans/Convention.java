package com.lias.beans;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Entité JavaBean représentant une convention de recherche et partenariat institutionnel/industriel.
 */
public class Convention implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long mandatId;
    private String organismePartenaire;
    private String typePartenaire;
    private String objet;
    private LocalDate dateSignature;
    private LocalDate dateEcheance;
    private String statut;
    private BigDecimal budgetAlloue;

    public Convention() {
    }

    public Convention(Long id, Long mandatId, String organismePartenaire, String typePartenaire, String objet, LocalDate dateSignature, LocalDate dateEcheance, String statut, BigDecimal budgetAlloue) {
        this.id = id;
        this.mandatId = mandatId;
        this.organismePartenaire = organismePartenaire;
        this.typePartenaire = typePartenaire;
        this.objet = objet;
        this.dateSignature = dateSignature;
        this.dateEcheance = dateEcheance;
        this.statut = statut;
        this.budgetAlloue = budgetAlloue;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getMandatId() {
        return mandatId;
    }

    public void setMandatId(Long mandatId) {
        this.mandatId = mandatId;
    }

    public String getOrganismePartenaire() {
        return organismePartenaire;
    }

    public void setOrganismePartenaire(String organismePartenaire) {
        this.organismePartenaire = organismePartenaire;
    }

    public String getTypePartenaire() {
        return typePartenaire;
    }

    public void setTypePartenaire(String typePartenaire) {
        this.typePartenaire = typePartenaire;
    }

    public String getObjet() {
        return objet;
    }

    public void setObjet(String objet) {
        this.objet = objet;
    }

    public LocalDate getDateSignature() {
        return dateSignature;
    }

    public void setDateSignature(LocalDate dateSignature) {
        this.dateSignature = dateSignature;
    }

    public LocalDate getDateEcheance() {
        return dateEcheance;
    }

    public void setDateEcheance(LocalDate dateEcheance) {
        this.dateEcheance = dateEcheance;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public BigDecimal getBudgetAlloue() {
        return budgetAlloue;
    }

    public void setBudgetAlloue(BigDecimal budgetAlloue) {
        this.budgetAlloue = budgetAlloue;
    }
}
