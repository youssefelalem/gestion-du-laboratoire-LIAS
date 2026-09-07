package com.lias.dao;

import java.util.List;
import com.lias.beans.ReunionPV;

public interface IPVDao {
    List<ReunionPV> findAll();
    ReunionPV findById(Long id);
    boolean save(ReunionPV pv);
}
