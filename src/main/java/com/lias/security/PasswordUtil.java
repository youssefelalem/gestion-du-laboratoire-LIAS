package com.lias.security;

import java.nio.charset.StandardCharsets;
import java.security.GeneralSecurityException;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

/**
 * Hachage des mots de passe (PBKDF2-HMAC-SHA256, sel aléatoire), sans dépendance externe.
 * Format stocké : {@code pbkdf2$<itérations>$<sel base64>$<hash base64>}.
 *
 * <p>Les anciens mots de passe en clair restent acceptés à la connexion puis sont
 * re-hachés automatiquement (migration transparente des bases existantes).
 */
public final class PasswordUtil {

    private static final String PREFIX = "pbkdf2$";
    private static final int ITERATIONS = 120_000;
    private static final int SALT_BYTES = 16;
    private static final int HASH_BITS = 256;
    private static final String TEMP_ALPHABET = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789";
    private static final SecureRandom RANDOM = new SecureRandom();

    private PasswordUtil() {
    }

    /** Hache un mot de passe en clair. */
    public static String hash(String plain) {
        byte[] salt = new byte[SALT_BYTES];
        RANDOM.nextBytes(salt);
        byte[] hash = pbkdf2(plain.toCharArray(), salt, ITERATIONS);
        Base64.Encoder b64 = Base64.getEncoder();
        return PREFIX + ITERATIONS + "$" + b64.encodeToString(salt) + "$" + b64.encodeToString(hash);
    }

    /** Vrai si la valeur stockée est déjà un hash (et non un ancien mot de passe en clair). */
    public static boolean isHashed(String stored) {
        return stored != null && stored.startsWith(PREFIX);
    }

    /** Vérifie un mot de passe saisi contre la valeur stockée (hash, ou ancien mot de passe en clair). */
    public static boolean verify(String plain, String stored) {
        if (plain == null || stored == null) {
            return false;
        }
        if (!isHashed(stored)) {
            return MessageDigest.isEqual(plain.getBytes(StandardCharsets.UTF_8), stored.getBytes(StandardCharsets.UTF_8));
        }
        String[] parts = stored.split("\\$");
        if (parts.length != 4) {
            return false;
        }
        try {
            int iterations = Integer.parseInt(parts[1]);
            byte[] salt = Base64.getDecoder().decode(parts[2]);
            byte[] expected = Base64.getDecoder().decode(parts[3]);
            return MessageDigest.isEqual(expected, pbkdf2(plain.toCharArray(), salt, iterations));
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    /** Mot de passe temporaire aléatoire (sans caractères ambigus), à communiquer au nouveau membre. */
    public static String generateTemporary() {
        StringBuilder sb = new StringBuilder(10);
        for (int i = 0; i < 10; i++) {
            sb.append(TEMP_ALPHABET.charAt(RANDOM.nextInt(TEMP_ALPHABET.length())));
        }
        return sb.toString();
    }

    private static byte[] pbkdf2(char[] password, byte[] salt, int iterations) {
        try {
            PBEKeySpec spec = new PBEKeySpec(password, salt, iterations, HASH_BITS);
            return SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256").generateSecret(spec).getEncoded();
        } catch (GeneralSecurityException e) {
            throw new IllegalStateException("PBKDF2 indisponible", e);
        }
    }
}
