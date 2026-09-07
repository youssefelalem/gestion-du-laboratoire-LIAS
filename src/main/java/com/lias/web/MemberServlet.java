package com.lias.web;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.lias.beans.Member;
import com.lias.dao.IMemberDao;
import com.lias.dao.MemberDaoImpl;

/**
 * Contrôleur JEE pour la gestion et consultation des profils membres (CDC §3).
 */
@WebServlet(name = "MemberServlet", urlPatterns = {"/membres", "/profils"})
public class MemberServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IMemberDao memberDao;

    @Override
    public void init() throws ServletException {
        super.init();
        this.memberDao = new MemberDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String team = request.getParameter("team");
        String status = request.getParameter("status");
        List<Member> liste;

        if (team != null && !team.isEmpty()) {
            liste = memberDao.findByTeam(team);
        } else if (status != null && !status.isEmpty()) {
            liste = memberDao.findByStatus(status);
        } else {
            liste = memberDao.findAll();
        }

        request.setAttribute("membres", liste);
        request.setAttribute("selectedTeam", team);
        request.setAttribute("selectedStatus", status);
        request.getRequestDispatcher("/WEB-INF/views/profils.jsp").forward(request, response);
    }
}
