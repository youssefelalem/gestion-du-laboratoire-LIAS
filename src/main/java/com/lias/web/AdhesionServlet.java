package com.lias.web;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.lias.beans.DemandeAdhesion;
import com.lias.beans.NotificationLabo;
import com.lias.dao.DemandeDaoImpl;
import com.lias.dao.IDemandeDao;
import com.lias.dao.INotificationDao;
import com.lias.dao.IUserDao;
import com.lias.dao.NotificationDaoImpl;
import com.lias.dao.UserDaoImpl;
import com.lias.security.PasswordUtil;

/**
 * Contrôleur JEE pour les demandes d'adhésion au laboratoire (CDC §6).
 */
@WebServlet(name = "AdhesionServlet", urlPatterns = {"/adhesions"})
public class AdhesionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IDemandeDao demandeDao;
    private INotificationDao notificationDao;
    private IUserDao userDao;

    @Override
    public void init() throws ServletException {
        super.init();
        this.demandeDao = new DemandeDaoImpl();
        this.notificationDao = new NotificationDaoImpl();
        this.userDao = new UserDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Les dossiers de candidature (identité, motivation) ne sont transmis à la vue que pour la
        // direction (CDC §6 « uniquement par le directeur ») ; le visiteur ne voit que le formulaire.
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        com.lias.beans.User user = null;
        if (session != null) {
            user = (com.lias.beans.User) session.getAttribute("currentUser");
            if (user == null) user = (com.lias.beans.User) session.getAttribute("user");
        }
        boolean isDirection = user != null
                && ("directeur".equalsIgnoreCase(user.getRole()) || "admin".equalsIgnoreCase(user.getRole()));
        List<DemandeAdhesion> adhesions = isDirection ? demandeDao.findAllAdhesions() : new java.util.ArrayList<>();
        request.setAttribute("adhesions", adhesions);
        request.setAttribute("demandes", adhesions);
        request.getRequestDispatcher("/WEB-INF/views/adhesions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("decision".equals(action) || "valider".equals(action) || "refuser".equals(action)) {
            jakarta.servlet.http.HttpSession session = request.getSession(false);
            com.lias.beans.User user = null;
            if (session != null) {
                user = (com.lias.beans.User) session.getAttribute("currentUser");
                if (user == null) user = (com.lias.beans.User) session.getAttribute("user");
            }
            if (user == null || (!"directeur".equalsIgnoreCase(user.getRole()) && !"admin".equalsIgnoreCase(user.getRole()))) {
                response.sendRedirect(request.getContextPath() + "/login?error=auth_requise");
                return;
            }
            // Décision prise par le directeur en mandat actif
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                idStr = request.getParameter("demandeId");
            }
            Long id = Long.parseLong(idStr);
            String decision = request.getParameter("decision"); // ACCEPTEE ou REFUSEE
            if (decision == null || decision.trim().isEmpty()) {
                decision = "valider".equalsIgnoreCase(action) ? "ACCEPTEE" : "REFUSEE";
            }
            // Acceptée → création du compte avec un mot de passe initial aléatoire (plus de mot de passe commun).
            String motDePasseInitial = PasswordUtil.generateTemporary();
            String emailCandidat = null;
            for (DemandeAdhesion d : demandeDao.findAllAdhesions()) {
                if (id.equals(d.getId())) {
                    emailCandidat = d.getEmail();
                    break;
                }
            }
            boolean compteExistant = emailCandidat != null && userDao.findByEmail(emailCandidat) != null;
            demandeDao.updateDecisionAdhesion(id, decision, motDePasseInitial);
            if ("ACCEPTEE".equalsIgnoreCase(decision) && emailCandidat != null && !compteExistant
                    && userDao.findByEmail(emailCandidat) != null) {
                // Affiché une seule fois au directeur, qui le communique au nouveau membre (jamais dans l'URL).
                session.setAttribute("flashCompteCree", emailCandidat + "|" + motDePasseInitial);
            }

            // Notification automatique de la décision (CDC §6 & §19)
            NotificationLabo notif = new NotificationLabo(
                null, "adhesion", "À l'instant", false,
                (user != null && user.getPrenom() != null ? user.getPrenom() + " " + user.getNom() : "Direction"),
                "a statué sur la candidature #" + id + " : décision " + decision + " consignée au registre (CDC §6).",
                "Examiner →", "/adhesions"
            );
            notificationDao.save(notif);

            response.sendRedirect(request.getContextPath() + "/adhesions?msg=decision_enregistree");
            return;
        } else {
            // Nouvelle soumission de candidature (par un visiteur ou candidat externe)
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String statutVise = request.getParameter("statutVise");
            if (statutVise == null || statutVise.trim().isEmpty()) {
                statutVise = request.getParameter("statutPostule");
            }
            String etablissement = request.getParameter("etablissement");
            if (etablissement == null || etablissement.trim().isEmpty()) {
                etablissement = request.getParameter("etablissementOrigine");
            }
            String motivation = request.getParameter("motivation");
            String date = LocalDate.now().toString();

            DemandeAdhesion d = new DemandeAdhesion(null, nom, prenom, email, statutVise, etablissement, motivation, date, "EN_ATTENTE");
            demandeDao.saveAdhesion(d);

            // Notification automatique pour la direction (CDC §6 & §19)
            NotificationLabo notif = new NotificationLabo(
                null, "adhesion", "À l'instant", false,
                (prenom != null ? prenom + " " : "") + (nom != null ? nom : "Candidat"),
                "a soumis une nouvelle candidature d'adhésion au laboratoire (Statut visé : " + statutVise + ").",
                "Examiner le dossier →", "/adhesions"
            );
            notificationDao.save(notif);

            response.sendRedirect(request.getContextPath() + "/adhesions?msg=soumission_reussie");
        }
    }
}
