package com.h315.bookie.sevice;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTVerificationException;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.auth0.jwt.interfaces.JWTVerifier;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
public class JwtService {

    private static final String SECRET = "bookiesecret";  //modicar con variable de entorno
    private static final long EXPIRATION_TIME = 3600000; // 1 hora
    private static final String ISSUER = "bookie";

    private final Algorithm algorithm = Algorithm.HMAC256(SECRET);

    public String generateToken( Long id,String username, String name) {
        return JWT.create()
                .withSubject(username) // Identificador único del usuario
                .withClaim("id", id) // Agrega el ID del usuario
                .withClaim("name", name) // Agrega el nombre del usuario como claim
                .withIssuer(ISSUER) // Emisor del token
                .withIssuedAt(new Date()) // Fecha de emisión
                .withExpiresAt(new Date(System.currentTimeMillis() + EXPIRATION_TIME)) // Fecha de expiración
                .sign(algorithm); // Firma del token
    }
    public boolean validateToken(String token) {
        try {
            JWTVerifier verifier = JWT.require(algorithm).withIssuer(ISSUER).build();
            verifier.verify(token);
            return true;
        } catch (JWTVerificationException e) {
            return false;
        }
    }

    public String extractUsername(String token) {
        DecodedJWT decodedJWT = JWT.require(algorithm).withIssuer(ISSUER).build().verify(token);
        return decodedJWT.getSubject();
    }
}
