package com.h315.bookie.controller;

import com.h315.bookie.dto.StoryRequestDto;
import com.h315.bookie.sevice.StoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import java.net.http.HttpResponse;

@Controller
@CrossOrigin("*")
@RequestMapping("/api/story")
public class StoryController {

    @Autowired
    StoryService storyService;


    @PostMapping("/new")
    public ResponseEntity<?> newStory(@RequestBody StoryRequestDto storyRequestDto) { //Long authorId, String description, String title
        try {
            storyService.CreateStory(storyRequestDto.authorId(), storyRequestDto.description(), storyRequestDto.title());
            return ResponseEntity.ok("Story created successfully!"); // OK
        } catch (Exception e) {
            return ResponseEntity.status(400).body("Error creating story: " + e.getMessage()); // ERROR
        }

    }
}