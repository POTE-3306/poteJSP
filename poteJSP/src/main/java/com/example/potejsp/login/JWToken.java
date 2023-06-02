package com.example.potejsp.login;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

import java.util.Date;

public class JWToken {
    private static final String secretKey = "sercretKey";
    private static final long validityInMilliseconds = 1000L * 60 * 60;

    private static String generateToken(String id, String email) {
        return Jwts.builder()
                .setSubject(id)
                .claim("email", email)
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + validityInMilliseconds))
                .signWith(SignatureAlgorithm.HS256, secretKey)
                .compact();
    }

    public static String getToken(User user) {
        return generateToken(String.valueOf(user.getId()), user.getEmail());
    }

    public static boolean isValidToken(String token) {
        try {
            Claims claims = Jwts.parser()
                    .setSigningKey(secretKey)
                    .parseClaimsJws(token)
                    .getBody();
            User user = UserDAO.userSelectByIdAndEmail(Integer.parseInt(claims.getSubject()), claims.get("email").toString());
            if (user == null)
                return false;
        } catch (Exception e) {
            return false;
        }
        return true;
    }
}
