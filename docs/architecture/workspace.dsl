workspace "BlueSpace Tech Platform" "Architecture documentation for BlueSpace Tech Platform" {

    model {
        # --- People / Roles ---
        publicVisitor = person "Public Visitors" "Unauthenticated users browsing services and requesting quotes."
        customer = person "Customers" "Clients booking repairs, tracking jobs, and paying invoices."
        technician = person "Technicians" "Staff managing workloads, logs, and updating repair status."
        admin = person "Administrators" "Managers overseeing pricing, inventory, and system accounts."

        # --- Primary Software System ---
        blueSpaceSystem = softwareSystem "BlueSpace Tech Platform" "Central operating system for online booking, repairs, and billing." {
            
            cloudflare = container "Cloudflare CDN / WAF" "Edge DNS, DDoS protection & static caching" "Cloudflare Edge"
            nginx = container "NGINX Reverse Proxy" "Internal routing & SSL termination" "NGINX / Docker"
            
            webApp = container "Spring Boot Application" "Modular monolith executing core business logic" "Spring Boot / Java 21" {
                securityAuth = component "Security & Auth" "Filter Chain & JWT Claims" "Spring Security"
                userIdentity = component "User & Identity" "User profiles & client records" "Spring Domain"
                bookingsService = component "Bookings & Service" "Core repair lifecycle orchestrator" "Spring Domain"
                pricingCalc = component "Pricing Calculator" "Estimates & dynamic price quotes" "Spring Service"
                inventoryParts = component "Inventory & Parts" "Stock reservation & parts deduction" "Spring Domain"
                billingInvoicing = component "Billing & Invoicing" "Invoice generation & billing logs" "Spring Domain"
                asyncNotification = component "Async Notification" "Event-driven background messaging" "Spring Event"
            }

            redisCache = container "Redis Cache" "Session storage & Cache-Aside store" "Redis" "Database"
            database = container "PostgreSQL Database" "Primary persistence database" "PostgreSQL" "Database"
        }

        # --- External Software Systems ---
        whatsAppApi = softwareSystem "WhatsApp Cloud API" "Automated status updates & collection alerts"
        paymentGateway = softwareSystem "Payment Gateway API" "Processes online invoice payments"
        smtpService = softwareSystem "SMTP Email Service" "Dispatches booking receipts & PDF invoices"

        # --- Level 1 Relationships ---
        publicVisitor -> blueSpaceSystem "Browses services & requests quotes" "HTTPS"
        customer -> blueSpaceSystem "Books repairs & pays invoices" "HTTPS"
        technician -> blueSpaceSystem "Updates repair stages & logs parts" "HTTPS"
        admin -> blueSpaceSystem "Configures pricing & manages business" "HTTPS"

        blueSpaceSystem -> whatsAppApi "Triggers automated messages" "HTTPS/REST"
        blueSpaceSystem -> paymentGateway "Processes transactions" "HTTPS/REST"
        blueSpaceSystem -> smtpService "Sends receipts & system emails" "SMTP/HTTPS"

        # --- Level 2 Container Relationships ---
        publicVisitor -> cloudflare "Accesses platform via" "HTTPS"
        customer -> cloudflare "Accesses customer portal via" "HTTPS"
        technician -> cloudflare "Accesses technician workspace via" "HTTPS"
        admin -> cloudflare "Accesses management console via" "HTTPS"

        cloudflare -> nginx "Proxies traffic to" "HTTPS"
        nginx -> webApp "Routes requests internally to" "HTTP"
        
        webApp -> redisCache "Caches data via Cache-Aside" "RESP"
        webApp -> database "Reads/Writes data" "JDBC/SQL"

        webApp -> whatsAppApi "Sends real-time updates via" "HTTPS/REST"
        webApp -> paymentGateway "Processes payments via" "HTTPS/REST"
        webApp -> smtpService "Dispatches emails via" "SMTP/HTTPS"

        # --- Level 3 Component Relationships ---
        nginx -> securityAuth "Forwards REST requests to" "HTTP"
        securityAuth -> bookingsService "Enforces Security Context"
        userIdentity -> bookingsService "Validates User Profile"
        
        bookingsService -> pricingCalc "Requests Price Estimate"
        bookingsService -> inventoryParts "Reserves / Deducts Stock"
        bookingsService -> billingInvoicing "Generates Invoice"
        bookingsService -> asyncNotification "Emits Async Event"

        securityAuth -> redisCache "Validates session tokens"
        bookingsService -> database "Persists repair state"
        billingInvoicing -> paymentGateway "Processes invoice payment"
        asyncNotification -> whatsAppApi "Triggers WhatsApp alert"
        asyncNotification -> smtpService "Triggers email receipt"
    }

    views {
        systemContext blueSpaceSystem "SystemContext" {
            include *
            autoLayout tb
        }

        container blueSpaceSystem "Containers" {
            include *
            autoLayout tb
        }

        component webApp "Components" {
            include *
            autoLayout tb
        }

        styles {
            element "Element" {
                color #ffffff
                fontSize 34
            }
            element "Person" {
                background #08427b
                shape Person
            }
            element "Software System" {
                background #1168bd
                fontSize 36
            }
            element "Container" {
                background #2b78c5
                fontSize 34
            }
            element "Component" {
                background #5294d3
                color #ffffff
                fontSize 32
            }
            element "Database" {
                shape Cylinder
                background #1f5183
            }
        }

        theme default
    }
}