package com.h315.bookie.controller;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.h315.bookie.entity.UserEntity;
import com.h315.bookie.repository.UserRepository;
import com.h315.bookie.sevice.JwtService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.Collections;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/auth/google")
public class GoogleAuthController {

    @Autowired
    UserRepository userRepository;

    @Value("${google.clientId}")
    private String CLIENT_ID;

    private final JwtService jwtService;

    public GoogleAuthController(JwtService jwtService) {
        this.jwtService = jwtService;
    }

    @PostMapping("/verify-token")
    public ResponseEntity<?> verifyGoogleToken(@RequestBody TokenRequest tokenRequest) {
        try {
            // Configurar el verificador
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                    new NetHttpTransport(),
                    new JacksonFactory()
            )
                    .setAudience(Collections.singletonList(CLIENT_ID))
                    .build();

            // Verificar el token de Google
            GoogleIdToken idToken = verifier.verify(tokenRequest.getIdToken());

            if (idToken != null) {
                GoogleIdToken.Payload payload = idToken.getPayload();

                // Obtener el email del usuario y name
                String email = payload.getEmail();
                String name = (String) payload.get("name");

                // Verificar si el usuario existe en la base de datos
                UserEntity user = userRepository.findByEmail(email).orElseGet(() -> {
                    // Crear un nuevo usuario si no existe
                    UserEntity newUser = new UserEntity();
                    newUser.setEmail(email);
                    newUser.setName(name);
                    return userRepository.save(newUser);
                });

                // Generar el JWT para tu backend
                String accessToken = jwtService.generateToken( user.getId(),email, name);

                // Respuesta con el access token y el ID del usuario
                return ResponseEntity.ok(new TokenResponse( accessToken));
            } else {
                return ResponseEntity.status(400).body("Invalid ID token.");
            }
        } catch (GeneralSecurityException | IOException e) {
            return ResponseEntity.status(500).body("Error validating token: " + e.getMessage());
        }
    }

    // Clase para representar la petición
    public static class TokenRequest {
        private String idToken;

        public String getIdToken() {
            return idToken;
        }

        public void setIdToken(String idToken) {
            this.idToken = idToken;
        }
    }

    // Clase para la respuesta del token
    public static class TokenResponse {
        private String accessToken;

        public TokenResponse(String accessToken) {
            this.accessToken = accessToken;
        }

        public String getAccessToken() {
            return accessToken;
        }

        public void setAccessToken(String accessToken) {
            this.accessToken = accessToken;
        }
    }
}
