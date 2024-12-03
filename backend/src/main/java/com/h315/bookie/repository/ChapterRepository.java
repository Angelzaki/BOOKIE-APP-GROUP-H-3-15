package com.h315.bookie.repository;


import com.h315.bookie.entity.ChapterEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ChapterRepository extends JpaRepository<ChapterEntity, Long> {

    Optional<ChapterEntity> findByStoryIdAndTitle(Long storyId, String title);

    Optional<ChapterEntity> findByStoryIdAndNumberchapter(Long storyId, Integer numberchapter);

    //recuperar los capítulos
    List<ChapterEntity> findAllByStoryId(Long storyId);

}
