package com.h315.bookie.dto;

public record ChapterDto (

        Long storyId,
        String title,
        String content,
        Double latitud,
        Double longitud,
        Integer numberchapter
){
}
