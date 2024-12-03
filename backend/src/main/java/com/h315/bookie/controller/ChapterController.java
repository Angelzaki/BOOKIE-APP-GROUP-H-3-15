package com.h315.bookie.controller;

import com.h315.bookie.dto.ChapterDto;
import com.h315.bookie.dto.ChapterResDto;
import com.h315.bookie.dto.CoordinatesDto;
import com.h315.bookie.entity.ChapterEntity;
import com.h315.bookie.repository.ChapterRepository;
import com.h315.bookie.repository.StoryRepository;
import com.h315.bookie.sevice.ChapterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/api/chapter")
public class ChapterController {

    @Autowired
    private ChapterRepository chapterRepository;

    @Autowired
    private StoryRepository storyRepository;

    @Autowired
    ChapterService chapterService;

    @PostMapping("/new")
    public ResponseEntity<?> createChapter(@RequestBody ChapterDto chapterDto) {
        try {
            // Buscar la historia por ID
            var story = storyRepository.findById(chapterDto.storyId())
                    .orElseThrow(() -> new RuntimeException("Historia no encontrada"));

            // Validar que el título no esté repetido
            if (chapterRepository.findByStoryIdAndTitle(story.getId(), chapterDto.title()).isPresent()) {
                return ResponseEntity.status(400).body("El título del capítulo ya existe en esta historia.");
            }
            // Validar que el número del capítulo no esté repetido
            if (chapterRepository.findByStoryIdAndNumberchapter(story.getId(), chapterDto.numberchapter()).isPresent()) {
                return ResponseEntity.status(400).body("El número del capítulo ya existe en esta historia.");
            }
            // Crear el capítulo utilizando el patrón Builder
            ChapterEntity chapterEntity = ChapterEntity.builder()
                    .story(story)
                    .title(chapterDto.title())
                    .content(chapterDto.content())
                    .latitud(chapterDto.latitud())
                    .longitud(chapterDto.longitud())
                    .numberchapter(chapterDto.numberchapter())
                    .build();

            // Guardar el capítulo en la base de datos
            chapterRepository.save(chapterEntity);

            return ResponseEntity.ok("chapter create");
        } catch (Exception e) {
            return ResponseEntity.status(400).body("ERROR " + e);
        }
    }
    @PostMapping("/nearest")
    public ResponseEntity<?> getNearestChapters(@RequestBody CoordinatesDto coordinatesDto) {
        try {
            // Convertir las coordenadas de usuario a radianes
            double userLat = Math.toRadians(coordinatesDto.latitude());
            double userLng = Math.toRadians(coordinatesDto.longitude());

            // Obtener todos los capítulos
            List<ChapterEntity> chapters = chapterRepository.findAll();

            // Ordenar los capítulos según la distancia usando la fórmula de Haversine
            List<ChapterResDto> sortedChapters = chapters.stream()
                    .map(chapter -> new ChapterResDto(
                            chapter.getId(),
                            chapter.getTitle(),
                            chapter.getLatitud(),
                            chapter.getLongitud()
                    ))
                    .sorted(Comparator.comparingDouble(chapter -> calculateDistance(
                            userLat,
                            userLng,
                            Math.toRadians(chapter.latitud()),
                            Math.toRadians(chapter.longitud())
                    )))
                    .distinct()  // Evitar duplicados
                    .collect(Collectors.toList());

            // Retornar la respuesta con los capítulos ordenados
            return ResponseEntity.ok(sortedChapters);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error al calcular distancias: " + e.getMessage());
        }
    }

    private double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
        final double EARTH_RADIUS = 6371; // Radio de la Tierra en kilómetros

        double deltaLat = lat2 - lat1;
        double deltaLng = lng2 - lng1;

        double a = Math.sin(deltaLat / 2) * Math.sin(deltaLat / 2) +
                Math.cos(lat1) * Math.cos(lat2) *
                        Math.sin(deltaLng / 2) * Math.sin(deltaLng / 2);

        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        return EARTH_RADIUS * c; // Distancia en kilómetros
    }

}
