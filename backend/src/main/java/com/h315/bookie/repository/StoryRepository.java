package com.h315.bookie.repository;

import com.h315.bookie.entity.StoryEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StoryRepository extends JpaRepository<StoryEntity,Long> {
}
