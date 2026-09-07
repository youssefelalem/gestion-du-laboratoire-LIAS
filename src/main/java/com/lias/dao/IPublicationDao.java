package com.lias.dao;

import java.util.List;
import com.lias.beans.Publication;

public interface IPublicationDao {
    List<Publication> findAll();
    List<Publication> findByYear(int year);
    List<Publication> findByTeam(String team);
    List<Publication> findByAuthor(String author);
    boolean save(Publication pub);
}
