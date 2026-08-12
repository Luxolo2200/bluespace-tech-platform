workspace "BlueSpace Tech Platform" "Architecture documentation for BlueSpace Tech Platform" {

    model {
        user = person "Platform User" "A customer using BlueSpace services."
        admin = person "Platform Admin" "System administrator."

        blueSpaceSystem = softwareSystem "BlueSpace Tech Platform" "Main application platform." {
            webApp = container "Web Application" "Delivers frontend user interface." "React / TypeScript"
            apiGateway = container "API Gateway" "Handles incoming requests and routing." "Spring Boot"
            database = container "Database" "Stores system and user data." "PostgreSQL"
        }

        user -> webApp "Uses" "HTTPS"
        admin -> webApp "Manages via" "HTTPS"
        webApp -> apiGateway "API requests" "JSON/HTTPS"
        apiGateway -> database "Reads/Writes" "JDBC"
    }

    views {
        systemContext blueSpaceSystem "SystemContext" {
            include *
            autoLayout lr
        }

        container blueSpaceSystem "Containers" {
            include *
            autoLayout lr
        }

        theme default
    }
}