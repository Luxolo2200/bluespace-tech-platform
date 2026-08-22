package tech.bluespace.service;

import org.springframework.stereotype.Service;
import tech.bluespace.domain.Booking;
import tech.bluespace.domain.User;
import tech.bluespace.repository.BookingRepository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
public class BookingService {

    private final BookingRepository bookingRepository;

    public BookingService(BookingRepository bookingRepository) {
        this.bookingRepository = bookingRepository;
    }

    public Booking createBooking(User customer, String serviceType, String description, BigDecimal estimatedCost, LocalDateTime scheduledAt) {
        var booking = new Booking(customer, serviceType, description, estimatedCost, scheduledAt);
        return bookingRepository.save(booking);
    }

    public Booking updateStatus(UUID bookingId, Booking.BookingStatus newStatus) {
        var booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new IllegalArgumentException("Booking not found with ID: " + bookingId));
        booking.setStatus(newStatus);
        return bookingRepository.save(booking);
    }

    public List<Booking> getBookingsForCustomer(UUID customerId) {
        return bookingRepository.findByCustomerId(customerId);
    }
}