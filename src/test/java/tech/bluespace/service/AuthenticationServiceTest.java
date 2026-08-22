package tech.bluespace.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import tech.bluespace.domain.User;
import tech.bluespace.dto.AuthenticationRequest;
import tech.bluespace.dto.AuthenticationResponse;
import tech.bluespace.dto.RegisterRequest;
import tech.bluespace.repository.UserRepository;
import tech.bluespace.security.JwtService;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AuthenticationServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private JwtService jwtService;

    @Mock
    private AuthenticationManager authenticationManager;

    @InjectMocks
    private AuthenticationService authenticationService;

    private RegisterRequest registerRequest;
    private AuthenticationRequest authRequest;
    private User testUser;

    @BeforeEach
    void setUp() {
        registerRequest = new RegisterRequest("John Doe", "john@example.com", "password123", User.Role.CUSTOMER);
        authRequest = new AuthenticationRequest("john@example.com", "password123");
        testUser = new User("john@example.com", "encodedPassword", "John Doe", User.Role.CUSTOMER);
    }

    @Test
    @DisplayName("Should successfully register a new user and return a JWT token")
    void register_Success() {
        when(userRepository.existsByEmail(registerRequest.email())).thenReturn(false);
        when(passwordEncoder.encode(registerRequest.password())).thenReturn("encodedPassword");
        when(userRepository.save(any(User.class))).thenReturn(testUser);
        when(jwtService.generateToken(any(User.class))).thenReturn("mock-jwt-token");

        AuthenticationResponse response = authenticationService.register(registerRequest);

        assertThat(response).isNotNull();
        assertThat(response.token()).isEqualTo("mock-jwt-token");
        verify(userRepository, times(1)).save(any(User.class));
    }

    @Test
    @DisplayName("Should throw IllegalArgumentException when registering an already existing email")
    void register_DuplicateEmail_ThrowsException() {
        when(userRepository.existsByEmail(registerRequest.email())).thenReturn(true);

        assertThatThrownBy(() -> authenticationService.register(registerRequest))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Email already registered");

        verify(userRepository, never()).save(any(User.class));
    }

    @Test
    @DisplayName("Should authenticate user and return a JWT token")
    void authenticate_Success() {
        when(userRepository.findByEmail(authRequest.email())).thenReturn(Optional.of(testUser));
        when(jwtService.generateToken(testUser)).thenReturn("mock-jwt-token");

        AuthenticationResponse response = authenticationService.authenticate(authRequest);

        assertThat(response).isNotNull();
        assertThat(response.token()).isEqualTo("mock-jwt-token");
        verify(authenticationManager, times(1)).authenticate(any(UsernamePasswordAuthenticationToken.class));
    }
}