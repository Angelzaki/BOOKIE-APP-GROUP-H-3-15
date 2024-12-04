package com.h315.bookie.sevice;

import com.h315.bookie.entity.StoryEntity;
import com.h315.bookie.entity.UserEntity;
import com.h315.bookie.repository.StoryRepository;
import com.h315.bookie.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class StoryService {

    @Autowired
    StoryRepository storyRepository;
    @Autowired
    UserRepository userRepository;

    public void CreateStory(Long authorP, String titleP, String descriptionP) {
        UserEntity author = userRepository.findById(authorP)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + authorP));

        StoryEntity story = StoryEntity.builder()
                .title(titleP)
                .description(descriptionP)
                .author(author)
                .build();
        storyRepository.save(story);


    }

}
