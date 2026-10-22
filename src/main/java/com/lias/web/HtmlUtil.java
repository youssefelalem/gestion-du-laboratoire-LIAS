package com.lias.web;

/**
 * Échappement HTML des contenus saisis par les utilisateurs avant affichage dans les JSP
 * (protection contre l'injection de script, XSS stocké).
 */
public final class HtmlUtil {

    private HtmlUtil() {
    }

    /** Remplace les caractères spéciaux HTML ; null devient une chaîne vide. */
    public static String escape(String s) {
        if (s == null) {
            return "";
        }
        StringBuilder sb = new StringBuilder(s.length() + 16);
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '&': sb.append("&amp;"); break;
                case '<': sb.append("&lt;"); break;
                case '>': sb.append("&gt;"); break;
                case '"': sb.append("&quot;"); break;
                case '\'': sb.append("&#39;"); break;
                default: sb.append(c);
            }
        }
        return sb.toString();
    }
}
