package tech.bluespace.dto;

import tech.bluespace.domain.User.Role;

public record RegisterRequest(
    String fullName,
    String email,
    String password,
    Role role
) {}