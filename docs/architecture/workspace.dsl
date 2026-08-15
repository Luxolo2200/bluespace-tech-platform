workspace "BlueSpace Tech Platform" "Architecture documentation for BlueSpace Tech Platform" {

    model {
        # --- People / Roles ---
        publicVisitor = person "Public Visitors" "Unauthenticated users browsing services, blog articles, FAQs, using repair price calculator, and submitting quote requests."
        customer = person "Customers" "Registered clients booking repairs, tracking job progress, approving diagnostic quotes, making payments, and viewing repair history."
        technician = person "Technicians" "Staff managing daily workloads, recording diagnostic logs, requesting parts, updating repair stages, and marking jobs complete."
        admin = person "Administrators" "Managers monitoring business performance, configuring pricing rules, overseeing inventory, generating invoices, and managing accounts."

        # --- Primary Software System ---
        blueSpaceSystem = softwareSystem "BlueSpace Tech Platform" "The central operating system for BlueSpace Tech operations. Enables online service booking, instant price calculations, real-time repair tracking, technician workflows, inventory, billing, and business analytics."

        # --- External Software Systems ---
        whatsAppApi = softwareSystem "WhatsApp Cloud API" "Delivers automated real-time status updates, quote approval requests, and collection notifications directly to customers."
        paymentGateway = softwareSystem "Payment Gateway API" "Processes customer online invoice payments securely and returns transaction verifications."
        smtpService = softwareSystem "SMTP Email Service" "Dispatches transactional booking confirmations, digital PDF invoices, receipts, and account verification links."

        # --- User Relationships with BlueSpace ---
        publicVisitor -> blueSpaceSystem "Browses services, calculates estimates, requests quotes" "HTTPS"
        customer -> blueSpaceSystem "Books repairs, tracks progress, approves quotes, pays invoices" "HTTPS"
        technician -> blueSpaceSystem "Logs diagnostics, requests replacement parts, updates status" "HTTPS"
        admin -> blueSpaceSystem "Manages users, sets pricing, generates reports, oversees business" "HTTPS"

        # --- BlueSpace Relationships with External Systems ---
        blueSpaceSystem -> whatsAppApi "Triggers automated message notifications" "HTTPS/REST"
        blueSpaceSystem -> paymentGateway "Initiates payment sessions and verifies transactions" "HTTPS/REST"
        blueSpaceSystem -> smtpService "Sends system emails, invoices, and receipts" "SMTP/HTTPS"
    }

    views {
        systemContext blueSpaceSystem "SystemContext" {
            include *
            autoLayout lr
        }

        theme default
    }
}