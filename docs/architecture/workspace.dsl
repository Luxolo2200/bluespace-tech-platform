workspace "BlueSpace Tech Platform" "C4 Architecture Model" {

    model {
        user = person "Platform User" "Uses service bookings and account features."
        admin = person "Platform Admin" "Manages users and system settings."

        blueSpaceSystem = softwareSystem "BlueSpace Tech Platform" "Modular monolith backend." {
            webApp = container "Single Page Application" "React-based web application." "React / JavaScript"
            backendApp = container "Backend Monolith" "Handles business logic and API processing." "Java / Spring Boot" {
                securityComponent = component "Security Module" "Handles JWT auth and permissions." "Spring Security"
                userComponent = component "User Module" "Manages accounts and profiles." "Spring Service"
                bookingComponent = component "Booking Module" "Manages service scheduling." "Spring Service"
            }
            database = container "Database" "Stores system state and records." "PostgreSQL" "Database"
        }

        user -> webApp "Uses" "HTTPS"
        admin -> webApp "Manages via" "HTTPS"
        webApp -> backendApp "API Requests" "JSON / HTTPS"
        backendApp -> database "Reads/Writes" "JDBC"
    }

    views {
        systemContext blueSpaceSystem "SystemContext" {
            include *
            autolayout lr
        }
        container blueSpaceSystem "Containers" {
            include *
            autolayout lr
        }
        component backendApp "Components" {
            include *
            autolayout lr
        }
        theme default
    }
}