package tech.bluespace.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import tech.bluespace.domain.Booking;
import tech.bluespace.domain.User;
import tech.bluespace.repository.BookingRepository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class BookingServiceTest {

    @Mock
    private BookingRepository bookingRepository;

    @InjectMocks
    private BookingService bookingService;

    private User testCustomer;
    private Booking testBooking;

    @BeforeEach
    void setUp() {
        testCustomer = new User("customer@example.com", "pass", "Jane Smith", User.Role.CUSTOMER);
        testBooking = new Booking(
                testCustomer,
                "AC Maintenance",
                "Regular cleaning service",
                new BigDecimal("150.00"),
                LocalDateTime.now().plusDays(2)
        );
    }

    @Test
    @DisplayName("Should successfully create a booking")
    void createBooking_Success() {
        when(bookingRepository.save(any(Booking.class))).thenReturn(testBooking);

        Booking created = bookingService.createBooking(
                testCustomer,
                "AC Maintenance",
                "Regular cleaning service",
                new BigDecimal("150.00"),
                LocalDateTime.now().plusDays(2)
        );

        assertThat(created).isNotNull();
        assertThat(created.getServiceType()).isEqualTo("AC Maintenance");
        assertThat(created.getStatus()).isEqualTo(Booking.BookingStatus.PENDING);
        verify(bookingRepository, times(1)).save(any(Booking.class));
    }

    @Test
    @DisplayName("Should update booking status successfully")
    void updateStatus_Success() {
        UUID bookingId = UUID.randomUUID();
        when(bookingRepository.findById(bookingId)).thenReturn(Optional.of(testBooking));
        when(bookingRepository.save(any(Booking.class))).thenReturn(testBooking);

        Booking updated = bookingService.updateStatus(bookingId, Booking.BookingStatus.CONFIRMED);

        assertThat(updated.getStatus()).isEqualTo(Booking.BookingStatus.CONFIRMED);
        verify(bookingRepository, times(1)).save(testBooking);
    }

    @Test
    @DisplayName("Should throw exception when updating status for non-existent booking")
    void updateStatus_NotFound_ThrowsException() {
        UUID bookingId = UUID.randomUUID();
        when(bookingRepository.findById(bookingId)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> bookingService.updateStatus(bookingId, Booking.BookingStatus.CONFIRMED))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Booking not found");
    }
}