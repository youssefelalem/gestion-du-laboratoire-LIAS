package com.lias.dao;

import java.util.List;
import com.lias.beans.Convention;

public interface IConventionDao {
    List<Convention> findAll();
    Convention findById(Long id);
    boolean save(Convention convention);
}
