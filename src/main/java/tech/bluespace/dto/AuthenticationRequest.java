package tech.bluespace.dto;

public record AuthenticationRequest(
    String email,
    String password
) {}