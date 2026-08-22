# --- Stage 1: Build Application ---
FROM maven:3.9.6-eclipse-temurin-21-alpine AS builder
WORKDIR /app

# Copy dependency definitions and source code
COPY pom.xml .
COPY src ./src

# Package application without running unit tests during image build
RUN mvn clean package -DskipTests

# --- Stage 2: Minimal Runtime Environment ---
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Run as a non-root user for container security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Copy built JAR artifact from builder stage
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]