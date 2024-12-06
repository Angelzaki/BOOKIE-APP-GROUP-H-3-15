package com.h315.bookie.controller;

import com.h315.bookie.dto.LibraryReqDto;
import com.h315.bookie.dto.StoryDto;
import com.h315.bookie.entity.StoryEntity;
import com.h315.bookie.sevice.LibraryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/library")
public class LibraryController {

    @Autowired
    private LibraryService libraryService;

    @GetMapping("/{id}")
    public ResponseEntity<List<StoryDto>>  myLibrary(@PathVariable Long id) {
        try {
            List<StoryDto> storyDTOs = libraryService.libraryByUserId(id);

            if (storyDTOs.isEmpty()) {
                return ResponseEntity.noContent().build(); // Devuelve 204 si no hay historias
            }

            return ResponseEntity.ok(storyDTOs); // Devuelve 200 con la lista de DTOs
        } catch (Exception e) {
            // En caso de error, devolvemos una respuesta 500
            return ResponseEntity.internalServerError().body(null);
        }
    }

    @PostMapping("/add")
    public ResponseEntity<?> addNewHistory(@RequestBody LibraryReqDto libraryReqDto) {
        try {
            libraryService.addStoryToLibrary(libraryReqDto.userId(), libraryReqDto.storyId());
            return ResponseEntity.ok().body("Agregado con exito");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e);

        }

    }
}
