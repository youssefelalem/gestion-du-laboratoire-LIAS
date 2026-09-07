package com.lias.web;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.lias.beans.Publication;
import com.lias.dao.IPublicationDao;
import com.lias.dao.PublicationDaoImpl;

/**
 * Contrôleur JEE pour la gestion des publications scientifiques (CDC §12).
 * Accessible en consultation à tous, et en ajout aux membres et doctorants.
 */
@WebServlet(name = "PublicationServlet", urlPatterns = {"/publications"})
public class PublicationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IPublicationDao pubDao;

    @Override
    public void init() throws ServletException {
        super.init();
        this.pubDao = new PublicationDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String team = request.getParameter("team");
        String yearStr = request.getParameter("year");
        String author = request.getParameter("author");
        List<Publication> liste;

        if (team != null && !team.isEmpty()) {
            liste = pubDao.findByTeam(team);
        } else if (yearStr != null && !yearStr.isEmpty()) {
            try {
                liste = pubDao.findByYear(Integer.parseInt(yearStr));
            } catch (NumberFormatException e) {
                liste = pubDao.findAll();
            }
        } else if (author != null && !author.isEmpty()) {
            liste = pubDao.findByAuthor(author);
        } else {
            liste = pubDao.findAll();
        }

        request.setAttribute("publications", liste);
        request.setAttribute("selectedTeam", team);
        request.setAttribute("selectedYear", yearStr);
        request.setAttribute("selectedAuthor", author);
        request.getRequestDispatcher("/WEB-INF/views/publications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String titre = request.getParameter("titre");
        String auteurs = request.getParameter("auteurs");
        int annee = 2026;
        try {
            annee = Integer.parseInt(request.getParameter("annee"));
        } catch (Exception ignored) {}
        String revue = request.getParameter("revue");
        String doi = request.getParameter("doi");
        String equipe = request.getParameter("equipe");
        String type = request.getParameter("type");

        Publication pub = new Publication(null, titre, auteurs, annee, revue, doi, equipe, type);
        pubDao.save(pub);

        response.sendRedirect(request.getContextPath() + "/publications?msg=ajoute");
    }
}
