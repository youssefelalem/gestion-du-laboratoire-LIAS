package com.lias.dao;

import java.util.List;
import com.lias.beans.Evenement;

public interface IEvenementDao {
    List<Evenement> findAll();
    boolean save(Evenement evt);
}
