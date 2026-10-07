package com.lias.beans;

import java.io.Serializable;

/**
 * JavaBean représentant les paramètres institutionnels et la configuration du laboratoire (CDC §4.1 & §5.1).
 */
public class LaboratoireInfo implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id = 1;
    private String code = "LIAS";
    private String nomComplet = "Laboratoire d'Informatique et Applications Scientifiques";
    private String dateCreation = "2016-09-01";
    private String etablissement = "Faculté des Sciences Ben M'Sik";
    private String universite = "Université Hassan II de Casablanca";
    private boolean campagneAdhesionOuverte = true;
    private int maxUploadMB = 15;

    public LaboratoireInfo() {
        super();
    }

    public LaboratoireInfo(int id, String code, String nomComplet, String dateCreation, String etablissement, String universite) {
        this.id = id;
        this.code = code;
        this.nomComplet = nomComplet;
        this.dateCreation = dateCreation;
        this.etablissement = etablissement;
        this.universite = universite;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getNomComplet() {
        return nomComplet;
    }

    public void setNomComplet(String nomComplet) {
        this.nomComplet = nomComplet;
    }

    public String getDateCreation() {
        return dateCreation;
    }

    public void setDateCreation(String dateCreation) {
        this.dateCreation = dateCreation;
    }

    public String getEtablissement() {
        return etablissement;
    }

    public void setEtablissement(String etablissement) {
        this.etablissement = etablissement;
    }

    public String getUniversite() {
        return universite;
    }

    public void setUniversite(String universite) {
        this.universite = universite;
    }

    public boolean isCampagneAdhesionOuverte() {
        return campagneAdhesionOuverte;
    }

    public void setCampagneAdhesionOuverte(boolean campagneAdhesionOuverte) {
        this.campagneAdhesionOuverte = campagneAdhesionOuverte;
    }

    public int getMaxUploadMB() {
        return maxUploadMB;
    }

    public void setMaxUploadMB(int maxUploadMB) {
        this.maxUploadMB = maxUploadMB;
    }
}
