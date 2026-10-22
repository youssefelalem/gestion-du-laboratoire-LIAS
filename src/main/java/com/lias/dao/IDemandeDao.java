package com.lias.dao;

import java.util.List;
import com.lias.beans.DemandeAdhesion;
import com.lias.beans.Materiel;

public interface IDemandeDao {
    // Adhésions
    List<DemandeAdhesion> findAllAdhesions();
    boolean saveAdhesion(DemandeAdhesion adhesion);
    /**
     * Enregistre la décision ; si elle est ACCEPTEE, crée le membre et son compte de connexion
     * avec {@code motDePasseInitial} (stocké haché).
     */
    boolean updateDecisionAdhesion(Long id, String decision, String motDePasseInitial);

    // Matériel
    List<Materiel> findAllMateriels();
    boolean saveMateriel(Materiel mat);
    boolean updateStatutMateriel(Long id, String statut, String dateAttribution);
}
