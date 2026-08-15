workspace "BlueSpace Tech Platform" "Architecture documentation for BlueSpace Tech Platform" {

    model {
        # --- People / Roles ---
        publicVisitor = person "Public Visitors" "Unauthenticated users browsing services, blog articles, FAQs, using repair price calculator, and submitting quote requests."
        customer = person "Customers" "Registered clients booking repairs, tracking job progress, approving diagnostic quotes, making payments, and viewing repair history."
        technician = person "Technicians" "Staff managing daily workloads, recording diagnostic logs, requesting parts, updating repair stages, and marking jobs complete."
        admin = person "Administrators" "Managers monitoring business performance, configuring pricing rules, overseeing inventory, generating invoices, and managing accounts."

        # --- Primary Software System ---
        blueSpaceSystem = softwareSystem "BlueSpace Tech Platform" "The central operating system for BlueSpace Tech operations. Enables online service booking, instant price calculations, real-time repair tracking, technician workflows, inventory, billing, and business analytics." {
            
            cloudflare = container "Cloudflare CDN / WAF" "Provides global DNS, DDoS protection, WAF security, free SSL, and static asset caching." "Cloudflare Edge"
            nginx = container "NGINX Reverse Proxy" "Handles internal routing, request forwarding, and SSL termination within the Docker host." "NGINX / Docker"
            webApp = container "Spring Boot Application" "Modular monolith executing business logic, booking engine, price calculations, billing, and system APIs." "Spring Boot / Java"
            redisCache = container "Redis Cache" "In-memory key-value cache used for session storage, query caching, and rate limiting via the Cache-Aside pattern." "Redis" "Database"
            database = container "PostgreSQL Database" "Primary relational database storing system entities, user profiles, inventory, repair logs, and billing data." "PostgreSQL" "Database"
        }

        # --- External Software Systems ---
        whatsAppApi = softwareSystem "WhatsApp Cloud API" "Delivers automated real-time status updates, quote approval requests, and collection notifications directly to customers."
        paymentGateway = softwareSystem "Payment Gateway API" "Processes customer online invoice payments securely and returns transaction verifications."
        smtpService = softwareSystem "SMTP Email Service" "Dispatches transactional booking confirmations, digital PDF invoices, receipts, and account verification links."

        # --- System Context Level Relationships ---
        publicVisitor -> blueSpaceSystem "Browses services, calculates estimates, requests quotes" "HTTPS"
        customer -> blueSpaceSystem "Books repairs, tracks progress, approves quotes, pays invoices" "HTTPS"
        technician -> blueSpaceSystem "Logs diagnostics, requests replacement parts, updates status" "HTTPS"
        admin -> blueSpaceSystem "Manages users, sets pricing, generates reports, oversees business" "HTTPS"

        blueSpaceSystem -> whatsAppApi "Triggers automated message notifications" "HTTPS/REST"
        blueSpaceSystem -> paymentGateway "Initiates payment sessions and verifies transactions" "HTTPS/REST"
        blueSpaceSystem -> smtpService "Sends system emails, invoices, and receipts" "SMTP/HTTPS"

        # --- Container Level Internal Relationships ---
        publicVisitor -> cloudflare "Accesses platform services via" "HTTPS"
        customer -> cloudflare "Accesses customer portal via" "HTTPS"
        technician -> cloudflare "Accesses technician workspace via" "HTTPS"
        admin -> cloudflare "Accesses admin management console via" "HTTPS"

        cloudflare -> nginx "Proxies verified traffic to" "HTTPS"
        nginx -> webApp "Routes requests internally to" "HTTP"
        
        webApp -> redisCache "Caches and reads frequent data using Cache-Aside pattern" "RESP Protocol"
        webApp -> database "Reads and writes persistence data" "JDBC / SQL"

        webApp -> whatsAppApi "Sends real-time updates via" "HTTPS/REST"
        webApp -> paymentGateway "Processes transactions via" "HTTPS/REST"
        webApp -> smtpService "Dispatches emails via" "SMTP/HTTPS"
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

        styles {
            element "Element" {
                color #ffffff
                fontSize 24
            }
            element "Person" {
                background #08427b
                shape Person
            }
            element "Software System" {
                background #1168bd
            }
            element "Container" {
                background #438dd5
            }
            element "Database" {
                shape Cylinder
                background #2a629a
            }
        }

        theme default
    }
}