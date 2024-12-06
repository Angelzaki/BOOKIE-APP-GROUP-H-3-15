package com.h315.bookie.dto;

import java.time.LocalDateTime;

public record LibraryDto(Long id, Long userId, Long storyId, String readingStatus, LocalDateTime addedDate) {}