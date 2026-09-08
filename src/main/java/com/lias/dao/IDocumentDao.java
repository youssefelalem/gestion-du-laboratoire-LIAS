package com.lias.dao;

import java.util.List;
import com.lias.beans.DocumentLabo;

/**
 * Interface DAO pour la gestion de l'archive documentaire (CDC §10).
 */
public interface IDocumentDao {
    List<DocumentLabo> findAll();
    List<DocumentLabo> findByDossier(String dossier, String sousDossier, String editionRubrique);
    List<DocumentLabo> search(String query);
    DocumentLabo findById(int id);
    boolean save(DocumentLabo document);
    boolean delete(int id);
}
