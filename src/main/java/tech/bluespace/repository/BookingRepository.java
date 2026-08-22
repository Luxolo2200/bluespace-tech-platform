package tech.bluespace.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import tech.bluespace.domain.Booking;

import java.util.List;
import java.util.UUID;

public interface BookingRepository extends JpaRepository<Booking, UUID> {
    List<Booking> findByCustomerId(UUID customerId);
    List<Booking> findByStatus(Booking.BookingStatus status);
}