<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>LIAS — Connexion à l'Espace Membre</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }

        .login-layout {
            display: grid;
            grid-template-columns: 1.1fr 1fr;
            min-height: 100vh;
        }

        /* Left Editorial Column */
        .login-left {
            background: var(--navy);
            color: var(--cream);
            padding: 56px 64px;
            display: flex;
            flex-direction: column;
            position: relative;
            overflow: hidden;
        }

        .login-left::before {
            content: '';
            position: absolute;
            inset: 0;
            pointer-events: none;
            background-image: radial-gradient(rgba(244,239,230,0.06) 1px, transparent 1px);
            background-size: 4px 4px;
        }

        .login-brand {
            display: flex;
            align-items: center;
            gap: 14px;
            position: relative;
            z-index: 1;
            text-decoration: none !important;
        }

        .login-brand-mark {
            width: 44px;
            height: 44px;
            background: var(--accent-2);
            color: #1A1814;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: var(--font-serif);
            font-size: 24px;
            font-weight: 600;
            letter-spacing: -0.02em;
            border-radius: 2px;
        }

        .login-brand-text {
            font-family: var(--font-serif);
            font-size: 24px;
            font-weight: 500;
            letter-spacing: -0.01em;
            color: var(--cream);
        }

        .login-brand-text .est {
            font-family: var(--font-mono);
            font-size: 11px;
            color: rgba(244,239,230,0.55);
            letter-spacing: 0.12em;
            margin-left: 8px;
        }

        .login-lead {
            margin-top: auto;
            margin-bottom: 56px;
            position: relative;
            z-index: 1;
        }

        .login-eyebrow {
            font-family: var(--font-mono);
            font-size: 11px;
            letter-spacing: 0.18em;
            text-transform: uppercase;
            color: rgba(244,239,230,0.55);
            margin-bottom: 18px;
        }

        .login-lead h1 {
            font-family: var(--font-serif);
            font-size: 54px;
            font-weight: 500;
            line-height: 1.05;
            margin: 0;
            letter-spacing: -0.015em;
            color: var(--cream);
            max-width: 520px;
        }

        .login-lead p {
            font-family: var(--font-serif);
            font-style: italic;
            font-size: 19px;
            color: rgba(244,239,230,0.75);
            margin: 24px 0 0;
            max-width: 460px;
            line-height: 1.55;
        }

        .login-footnote {
            position: relative;
            z-index: 1;
            font-family: var(--font-mono);
            font-size: 11px;
            color: rgba(244,239,230,0.45);
            letter-spacing: 0.1em;
            text-transform: uppercase;
            border-top: 1px solid rgba(244,239,230,0.15);
            padding-top: 18px;
        }

        /* Right Form Column */
        .login-right {
            background: var(--bg);
            padding: 56px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-card {
            width: 100%;
            max-width: 430px;
        }

        .login-card .eyebrow {
            color: var(--muted);
            margin-bottom: 8px;
        }

        .login-card h2 {
            font-family: var(--font-serif);
            font-size: 36px;
            font-weight: 500;
            margin: 0 0 8px;
            letter-spacing: -0.01em;
            color: var(--ink);
        }

        .login-card .sub {
            font-family: var(--font-serif);
            font-style: italic;
            font-size: 15px;
            color: var(--muted);
            margin-bottom: 28px;
            line-height: 1.55;
        }

        .field {
            margin-bottom: 20px;
        }

        .field label {
            display: block;
            font-family: var(--font-mono);
            font-size: 10.5px;
            letter-spacing: 0.15em;
            text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 6px;
        }

        .field input {
            width: 100%;
            padding: 12px 14px;
            background: var(--surface);
            border: 1px solid var(--border);
            font-family: var(--font-sans);
            font-size: 14px;
            color: var(--ink);
            outline: none;
            border-radius: 2px;
            transition: border-color 0.15s, box-shadow 0.15s;
        }

        .field input:focus {
            border-color: var(--navy);
            box-shadow: 0 0 0 2px rgba(27, 47, 74, 0.1);
        }

        .login-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 12px 0 24px;
            font-size: 13px;
        }

        .submit-btn {
            width: 100%;
            padding: 13px;
            background: var(--navy);
            color: var(--cream);
            border: 1px solid var(--navy);
            font-family: var(--font-sans);
            font-size: 14px;
            font-weight: 500;
            letter-spacing: 0.01em;
            cursor: pointer;
            border-radius: 2px;
            transition: background 0.15s, transform 0.15s;
        }

        .submit-btn:hover {
            background: var(--navy-dark);
            transform: translateY(-1px);
        }

        .alert-error {
            background: var(--burgundy-bg);
            border-right: 4px solid var(--burgundy);
            color: var(--burgundy);
            padding: 12px 16px;
            font-size: 13.5px;
            margin-bottom: 20px;
            border-radius: 2px;
        }

        .demo-credentials {
            margin-top: 32px;
            padding: 16px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 2px;
            font-size: 12px;
        }

        .demo-credentials h4 {
            margin: 0 0 8px;
            font-family: var(--font-mono);
            font-size: 10.5px;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            color: var(--navy);
        }

        .demo-tag {
            cursor: pointer;
            display: inline-block;
            background: var(--surface-2);
            padding: 3px 7px;
            border-radius: 2px;
            margin: 2px;
            font-family: var(--font-mono);
            font-size: 11px;
            color: var(--ink);
            border: 1px solid var(--border);
        }

        .demo-tag:hover {
            background: var(--accent-soft);
            border-color: var(--accent-2);
        }

        @media (max-width: 900px) {
            .login-layout { grid-template-columns: 1fr; }
            .login-left { display: none; }
            .login-right { padding: 40px 20px; }
        }
    </style>
</head>
<body>

    <div class="login-layout">

        <!-- Colonne Gauche Éditoriale -->
        <div class="login-left">
            <a href="<%= request.getContextPath() %>/public" class="login-brand">
                <div class="login-brand-mark">L</div>
                <div class="login-brand-text">LIAS <span class="est">EST. 2003</span></div>
            </a>

            <div class="login-lead">
                <div class="login-eyebrow">Système d'Information Scientifique · LIAS</div>
                <h1>La mémoire vivante de la recherche.</h1>
                <p>
                    Espace institutionnel réservé aux enseignants-chercheurs, doctorants, personnels administratifs et membres associés du LIAS.
                </p>
            </div>

            <div class="login-footnote">
                Faculté des Sciences Ben M'Sik · Université Hassan II de Casablanca
            </div>
        </div>

        <!-- Colonne Droite Formulaire -->
        <div class="login-right">
            <div class="login-card">
                <span class="eyebrow">Authentification Sécurisée</span>
                <h2>Connexion</h2>
                <div class="sub">
                    Renseignez vos identifiants pour accéder aux données et services du laboratoire.
                </div>

                <% 
                    String error = (String) request.getAttribute("errorMessage");
                    if (error == null) error = (String) request.getAttribute("error");
                    String errParam = request.getParameter("error");
                    if ("auth_requise".equals(errParam)) {
                        error = "Veuillez vous connecter pour accéder à cet espace protégé.";
                    }
                    if (error != null && !error.isEmpty()) { 
                %>
                    <div class="alert-error">
                        <%= error %>
                    </div>
                <% } %>

                <form action="<%= request.getContextPath() %>/login" method="post">
                    <div class="field">
                        <label for="email">Adresse email institutionnelle</label>
                        <input type="email" id="email" name="email" placeholder="prenom.nom@univ-h2c.ma" required autofocus>
                    </div>

                    <div class="field">
                        <label for="password">Mot de passe</label>
                        <input type="password" id="password" name="password" placeholder="••••••••••••" required>
                    </div>

                    <div class="login-row">
                        <label style="display:flex; align-items:center; gap:6px; cursor:pointer;">
                            <input type="checkbox" name="remember" style="accent-color: var(--navy);">
                            <span>Se souvenir de moi</span>
                        </label>
                        <a href="#" onclick="alert('Veuillez contacter le secrétariat du laboratoire : contact@lias.ma'); return false;">Mot de passe oublié ?</a>
                    </div>

                    <button type="submit" class="submit-btn">Accéder à mon espace →</button>
                </form>

                <!-- Comptes de Démonstration pour l'Évaluation Universitaire -->
                <div class="demo-credentials">
                    <h4>Comptes de test pour la soutenance (Cliquez pour remplir) :</h4>
                    <span class="demo-tag" onclick="fillForm('directeur@lias.ma', 'admin123')">Directeur (admin123)</span>
                    <span class="demo-tag" onclick="fillForm('permanent@lias.ma', 'pass123')">Permanent (pass123)</span>
                    <span class="demo-tag" onclick="fillForm('doctorant@lias.ma', 'doc123')">Doctorant (doc123)</span>
                    <span class="demo-tag" onclick="fillForm('admin@lias.ma', 'admin123')">Administrateur (admin123)</span>
                </div>

                <div style="margin-top: 24px; text-align: center; font-size: 13px;">
                    <a href="<%= request.getContextPath() %>/public" style="color: var(--muted);">← Retour au site public</a>
                </div>
            </div>
        </div>

    </div>

    <script>
        function fillForm(email, pass) {
            document.getElementById('email').value = email;
            document.getElementById('password').value = pass;
        }
    </script>
</body>
</html>
