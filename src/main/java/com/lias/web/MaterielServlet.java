package com.lias.web;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.lias.beans.Materiel;
import com.lias.beans.Member;
import com.lias.beans.NotificationLabo;
import com.lias.dao.DemandeDaoImpl;
import com.lias.dao.IDemandeDao;
import com.lias.dao.IMemberDao;
import com.lias.dao.INotificationDao;
import com.lias.dao.MemberDaoImpl;
import com.lias.dao.NotificationDaoImpl;

/**
 * Contrôleur JEE pour la gestion et distribution équitable du matériel (CDC §14 & §15).
 */
@WebServlet(name = "MaterielServlet", urlPatterns = {"/materiel"})
public class MaterielServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IDemandeDao demandeDao;
    private IMemberDao memberDao;
    private INotificationDao notificationDao;

    @Override
    public void init() throws ServletException {
        super.init();
        this.demandeDao = new DemandeDaoImpl();
        this.memberDao = new MemberDaoImpl();
        this.notificationDao = new NotificationDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Materiel> materiels = demandeDao.findAllMateriels();
        List<Member> membres = memberDao.findAll();

        int totalEquipements = (materiels != null) ? materiels.size() : 0;
        int totalAttribues = 0;
        int totalEnAttente = 0;

        // Équipements attribués par bénéficiaire (Nom -> List<Materiel>)
        Map<String, List<Materiel>> dotationsMap = new HashMap<>();
        if (materiels != null) {
            for (Materiel m : materiels) {
                if ("ATTRIBUE".equalsIgnoreCase(m.getStatut()) || "LIVRE".equalsIgnoreCase(m.getStatut()) || "ACCORDE".equalsIgnoreCase(m.getStatut()) || "VALIDE".equalsIgnoreCase(m.getStatut())) {
                    totalAttribues++;
                    String dem = m.getDemandeur() != null ? m.getDemandeur().trim() : "Non spécifié";
                    dotationsMap.computeIfAbsent(dem.toLowerCase(), k -> new ArrayList<>()).add(m);
                } else if ("EN_ATTENTE".equalsIgnoreCase(m.getStatut())) {
                    totalEnAttente++;
                }
            }
        }

        // Matrice d'équité (CDC §14 : Qui a reçu quoi / Qui n'a pas reçu)
        List<Member> membresAvecDotation = new ArrayList<>();
        List<Member> membresSansDotation = new ArrayList<>();

        if (membres != null) {
            for (Member mem : membres) {
                if ("retraite".equalsIgnoreCase(mem.getStatus()) || "ancien".equalsIgnoreCase(mem.getStatus())) {
                    continue; // Évaluation sur les membres actifs
                }
                String fullName = (mem.getFirstName() + " " + mem.getLastName()).toLowerCase();
                String invName = (mem.getLastName() + " " + mem.getFirstName()).toLowerCase();
                String email = mem.getEmail() != null ? mem.getEmail().toLowerCase() : "";

                boolean aRecu = false;
                for (String beneficiaire : dotationsMap.keySet()) {
                    if (beneficiaire.contains(fullName) || fullName.contains(beneficiaire) 
                            || beneficiaire.contains(invName) || (email.length() > 3 && beneficiaire.contains(email))) {
                        aRecu = true;
                        break;
                    }
                }

                if (aRecu) {
                    membresAvecDotation.add(mem);
                } else {
                    membresSansDotation.add(mem);
                }
            }
        }

        int totalActifs = membresAvecDotation.size() + membresSansDotation.size();
        int indiceEquite = totalActifs > 0 ? (membresAvecDotation.size() * 100) / totalActifs : 0;

        request.setAttribute("materiels", materiels);
        request.setAttribute("totalEquipements", totalEquipements);
        request.setAttribute("totalAttribues", totalAttribues);
        request.setAttribute("totalEnAttente", totalEnAttente);
        request.setAttribute("indiceEquite", indiceEquite);
        request.setAttribute("membresAvecDotation", membresAvecDotation);
        request.setAttribute("membresSansDotation", membresSansDotation);
        request.setAttribute("dotationsMap", dotationsMap);

        request.getRequestDispatcher("/WEB-INF/views/materiel.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        jakarta.servlet.http.HttpSession session = request.getSession(false);
        com.lias.beans.User user = null;
        if (session != null) {
            user = (com.lias.beans.User) session.getAttribute("currentUser");
            if (user == null) user = (com.lias.beans.User) session.getAttribute("user");
        }

        String action = request.getParameter("action");

        if ("attribuer".equals(action)) {
            if (user == null || (!"directeur".equalsIgnoreCase(user.getRole()) && !"admin".equalsIgnoreCase(user.getRole()))) {
                response.sendRedirect(request.getContextPath() + "/login?error=auth_requise");
                return;
            }

            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                idStr = request.getParameter("materielId");
            }
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    Long id = Long.parseLong(idStr.trim());
                    String statut = request.getParameter("statut"); // ACCORDE, LIVRE, REFUSE, ATTRIBUE
                    if (statut == null || statut.trim().isEmpty()) {
                        statut = "ATTRIBUE";
                    }
                    String dateAttribution = LocalDate.now().toString();
                    demandeDao.updateStatutMateriel(id, statut, dateAttribution);

                    // Notification automatique (CDC §19)
                    NotificationLabo notif = new NotificationLabo(
                        null, "materiel", "À l'instant", false,
                        (user.getPrenom() != null ? user.getPrenom() + " " : "") + (user.getNom() != null ? user.getNom() : "Direction"),
                        "a validé l'attribution d'un équipement scientifique dans le cadre de la distribution équitable (CDC §14).",
                        "Voir dotation →", "/materiel"
                    );
                    notificationDao.save(notif);

                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect(request.getContextPath() + "/materiel?msg=statut_mis_a_jour");
        } else {
            // Nouvelle demande de matériel formulée par un membre
            String designation = request.getParameter("designation");
            String categorie = request.getParameter("categorie");
            String demandeur = request.getParameter("demandeur");
            if (demandeur == null || demandeur.trim().isEmpty()) {
                if (user != null) {
                    demandeur = (user.getPrenom() != null ? user.getPrenom() + " " : "") + (user.getNom() != null ? user.getNom() : user.getEmail());
                } else {
                    demandeur = "Chercheur LIAS";
                }
            }
            String dateDemande = LocalDate.now().toString();
            String commentaire = request.getParameter("commentaire");
            if (commentaire == null || commentaire.trim().isEmpty()) {
                commentaire = request.getParameter("description");
            }

            Materiel mat = new Materiel(null, designation, categorie, demandeur, dateDemande, "EN_ATTENTE", null, commentaire);
            demandeDao.saveMateriel(mat);

            // Notification automatique (CDC §19)
            NotificationLabo notif = new NotificationLabo(
                null, "materiel", "À l'instant", false,
                demandeur,
                "a soumis un besoin en équipement scientifique : « " + designation + " » (" + categorie + ").",
                "Arbitrer →", "/materiel"
            );
            notificationDao.save(notif);

            response.sendRedirect(request.getContextPath() + "/materiel?msg=demande_enregistree");
        }
    }
}
