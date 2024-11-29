package com.h315.bookie.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.util.List;

@Entity
@Data
@Table(name = "users")
public class UserEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false, unique = true)
    private String email;

    //  @Column(name = "password_hash", nullable = false)
    //  private String passwordHash;

    // @ManyToOne(fetch = FetchType.LAZY)
    // @JoinColumn(name = "role_id", nullable = false)
    // private Role role;

    @OneToMany(mappedBy = "author", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<StoryEntity> stories;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<FavoritesEntity> favorites;


}