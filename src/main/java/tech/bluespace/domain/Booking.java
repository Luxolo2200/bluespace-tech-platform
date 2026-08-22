package tech.bluespace.domain;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "bookings")
public class Booking {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id", nullable = false)
    private User customer;

    @Column(nullable = false)
    private String serviceType;

    @Column(nullable = false)
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private BookingStatus status = BookingStatus.PENDING;

    @Column(precision = 10, scale = 2)
    private BigDecimal estimatedCost;

    @Column(nullable = false)
    private LocalDateTime scheduledAt;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    public enum BookingStatus {
        PENDING, CONFIRMED, IN_PROGRESS, COMPLETED, CANCELLED
    }

    public Booking() {}

    public Booking(User customer, String serviceType, String description, BigDecimal estimatedCost, LocalDateTime scheduledAt) {
        this.customer = customer;
        this.serviceType = serviceType;
        this.description = description;
        this.estimatedCost = estimatedCost;
        this.scheduledAt = scheduledAt;
    }

    public UUID getId() { return id; }
    public User getCustomer() { return customer; }
    public String getServiceType() { return serviceType; }
    public String getDescription() { return description; }
    public BookingStatus getStatus() { return status; }
    public BigDecimal getEstimatedCost() { return estimatedCost; }
    public LocalDateTime getScheduledAt() { return scheduledAt; }
    public LocalDateTime getCreatedAt() { return createdAt; }

    public void setStatus(BookingStatus status) { this.status = status; }
    public void setEstimatedCost(BigDecimal estimatedCost) { this.estimatedCost = estimatedCost; }
}