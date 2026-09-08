package com.lias.web;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.lias.beans.Evenement;
import com.lias.dao.EvenementDaoImpl;
import com.lias.dao.IEvenementDao;

/**
 * Contrôleur du Calendrier Scientifique & Navigation Temporelle (CDC §20).
 */
@WebServlet(name = "CalendrierServlet", urlPatterns = {"/calendrier"})
public class CalendrierServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IEvenementDao evenementDao;

    @Override
    public void init() throws ServletException {
        super.init();
        this.evenementDao = new EvenementDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Evenement> evenements = evenementDao.findAll();
        request.setAttribute("evenements", evenements);
        request.setAttribute("activeNav", "calendrier");
        request.getRequestDispatcher("/WEB-INF/views/calendrier.jsp").forward(request, response);
    }
}
