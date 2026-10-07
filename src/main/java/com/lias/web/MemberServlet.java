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

        String selId = request.getParameter("id");
        Member selectedMember = null;
        if (selId != null && !selId.trim().isEmpty()) {
            selectedMember = memberDao.findById(selId.trim());
        } else if (liste != null && !liste.isEmpty()) {
            selectedMember = liste.get(0);
        }

        List<com.lias.beans.AffiliationPeriod> periods = null;
        if (selectedMember != null) {
            periods = memberDao.getAffiliationPeriods(selectedMember.getId());
        }

        request.setAttribute("membres", liste);
        request.setAttribute("selectedMember", selectedMember);
        request.setAttribute("affiliationPeriods", periods);
        request.setAttribute("selectedTeam", team);
        request.setAttribute("selectedStatus", status);
        request.getRequestDispatcher("/WEB-INF/views/profils.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String id = request.getParameter("id");
        if (id != null && !id.trim().isEmpty()) {
            Member m = memberDao.findById(id.trim());
            if (m != null) {
                String firstName = request.getParameter("firstName");
                String lastName = request.getParameter("lastName");
                String grade = request.getParameter("grade");
                String team = request.getParameter("team");
                String status = request.getParameter("status");
                String photo = request.getParameter("photo");
                String etablissement = request.getParameter("etablissementOrigine");
                String labo = request.getParameter("laboratoireOrigine");
                String biographie = request.getParameter("biographie");
                String centresInteret = request.getParameter("centresInteret");

                if (firstName != null && !firstName.trim().isEmpty()) m.setFirstName(firstName.trim());
                if (lastName != null && !lastName.trim().isEmpty()) m.setLastName(lastName.trim());
                if (grade != null && !grade.trim().isEmpty()) m.setGrade(grade.trim());
                if (team != null && !team.trim().isEmpty()) m.setTeam(team.trim());
                if (status != null && !status.trim().isEmpty()) m.setStatus(status.trim());
                if (photo != null && !photo.trim().isEmpty()) m.setPhoto(photo.trim());
                if (etablissement != null) m.setEtablissementOrigine(etablissement.trim());
                if (labo != null) m.setLaboratoireOrigine(labo.trim());
                if (biographie != null) m.setBiographie(biographie.trim());
                if (centresInteret != null) m.setCentresInteret(centresInteret.trim());

                memberDao.update(m);
                response.sendRedirect(request.getContextPath() + "/profils?id=" + m.getId() + "&msg=profil_mis_a_jour");
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/profils");
    }
}
