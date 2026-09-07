package com.lias.web;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import com.lias.beans.Convention;
import com.lias.beans.Mandat;
import com.lias.beans.User;
import com.lias.dao.ConventionDaoImpl;
import com.lias.dao.IConventionDao;
import com.lias.dao.IMandatDao;
import com.lias.dao.MandatDaoImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ConventionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IConventionDao conventionDao;
    private IMandatDao mandatDao;

    @Override
    public void init() throws ServletException {
        this.conventionDao = new ConventionDaoImpl();
        this.mandatDao = new MandatDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Convention> conventions = conventionDao.findAll();
        Mandat actif = mandatDao.findActive();

        request.setAttribute("conventions", conventions);
        request.setAttribute("mandatActif", actif);
        request.setAttribute("activeMenu", "conventions");

        request.getRequestDispatcher("/WEB-INF/views/conventions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = null;
        if (session != null) {
            user = (User) session.getAttribute("currentUser");
            if (user == null) user = (User) session.getAttribute("user");
        }

        if (user == null || (!"directeur".equalsIgnoreCase(user.getRole()) && !"permanent".equalsIgnoreCase(user.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/conventions?error=unauthorized");
            return;
        }

        String organisme = request.getParameter("organismePartenaire");
        String typePartenaire = request.getParameter("typePartenaire");
        String objet = request.getParameter("objet");
        String dateSigStr = request.getParameter("dateSignature");
        String dateEchStr = request.getParameter("dateEcheance");
        String budgetStr = request.getParameter("budgetAlloue");
        String statut = request.getParameter("statut");

        if (organisme != null && !organisme.trim().isEmpty() && objet != null && dateSigStr != null) {
            Convention c = new Convention();
            Mandat actif = mandatDao.findActive();
            if (actif != null) {
                c.setMandatId(actif.getId());
            }
            c.setOrganismePartenaire(organisme.trim());
            c.setTypePartenaire(typePartenaire != null ? typePartenaire : "Industrie");
            c.setObjet(objet.trim());
            c.setDateSignature(LocalDate.parse(dateSigStr));
            if (dateEchStr != null && !dateEchStr.trim().isEmpty()) {
                c.setDateEcheance(LocalDate.parse(dateEchStr));
            }
            c.setStatut(statut != null ? statut : "Active");

            if (budgetStr != null && !budgetStr.trim().isEmpty()) {
                try {
                    c.setBudgetAlloue(new BigDecimal(budgetStr.replaceAll("[^0-9.]", "")));
                } catch (Exception e) {
                    c.setBudgetAlloue(BigDecimal.ZERO);
                }
            } else {
                c.setBudgetAlloue(BigDecimal.ZERO);
            }

            conventionDao.save(c);
        }

        response.sendRedirect(request.getContextPath() + "/conventions?success=created");
    }
}
