package com.lias.dao;

import java.util.List;
import com.lias.beans.Member;

public interface IMemberDao {
    List<Member> findAll();
    Member findById(String id);
    List<Member> findByTeam(String team);
    List<Member> findByStatus(String status);
    boolean save(Member member);
}
