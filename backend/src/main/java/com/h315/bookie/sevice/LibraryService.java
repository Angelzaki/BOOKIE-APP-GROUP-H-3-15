package com.h315.bookie.sevice;

import com.h315.bookie.dto.StoryDto;
import com.h315.bookie.entity.LibraryEntity;
import com.h315.bookie.entity.StoryEntity;
import com.h315.bookie.entity.UserEntity;
import com.h315.bookie.repository.LibraryRepository;
import com.h315.bookie.repository.StoryRepository;
import com.h315.bookie.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class LibraryService {


    @Autowired
    private LibraryRepository libraryRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private StoryRepository storyRepository;

    public List<StoryDto> libraryByUserId(Long userId) {
        List<StoryEntity> stories = libraryRepository.findStoriesByUserId(userId);

        return stories.stream()
                .map(story -> new StoryDto(story.getId(), story.getTitle())) // Convertir a DTO usando record
                .collect(Collectors.toList());
    }

    public void addStoryToLibrary(Long userId, Long storyId) {
        // Busca al usuario y la historia
        UserEntity userEntity = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        StoryEntity story = storyRepository.findById(storyId)
                .orElseThrow(() -> new IllegalArgumentException("Story not found"));

        LibraryEntity library = LibraryEntity.builder()
                .user(userEntity)
                .story(story)
                .readingStatus("in progress")
                .addedDate(LocalDateTime.now())
                .build();

        // Guarda la entidad en la base de datos
        libraryRepository.save(library);

    }


}
