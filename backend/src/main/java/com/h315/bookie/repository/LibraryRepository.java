package com.h315.bookie.repository;

import com.h315.bookie.entity.LibraryEntity;
import com.h315.bookie.entity.StoryEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
@Repository
public interface LibraryRepository extends JpaRepository<LibraryEntity,Long> {

    @Query("SELECT l.story FROM LibraryEntity l WHERE l.user.id = :userId")
    List<StoryEntity> findStoriesByUserId(Long userId);
}
