package com.lias.web;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.lias.beans.Evenement;
import com.lias.beans.Member;
import com.lias.beans.Publication;
import com.lias.dao.EvenementDaoImpl;
import com.lias.dao.IEvenementDao;
import com.lias.dao.IMemberDao;
import com.lias.dao.IPublicationDao;
import com.lias.dao.MemberDaoImpl;
import com.lias.dao.PublicationDaoImpl;

/**
 * Contrôleur JEE pour la production automatisée du rapport annuel d'activité (CDC §11).
 */
@WebServlet(name = "RapportServlet", urlPatterns = {"/rapport"})
public class RapportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IMemberDao memberDao;
    private IPublicationDao pubDao;
    private IEvenementDao evtDao;

    @Override
    public void init() throws ServletException {
        super.init();
        this.memberDao = new MemberDaoImpl();
        this.pubDao = new PublicationDaoImpl();
        this.evtDao = new EvenementDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String anneeStr = request.getParameter("annee");
        int annee = 2025;
        if (anneeStr != null && !anneeStr.trim().isEmpty()) {
            try {
                annee = Integer.parseInt(anneeStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        List<Member> membres = memberDao.findAll();
        List<Publication> pubs = pubDao.findAll();
        List<Evenement> evts = evtDao.findAll();

        request.setAttribute("anneeRapport", annee);
        request.setAttribute("totalMembres", membres.size());
        request.setAttribute("totalPublications", pubs.size());
        request.setAttribute("totalEvenements", evts.size());
        request.setAttribute("publications", pubs);
        request.setAttribute("evenements", evts);
        request.setAttribute("activeNav", "rapport");

        request.getRequestDispatcher("/WEB-INF/views/rapport.jsp").forward(request, response);
    }
}
