# Mr. Black AI Context

## Project Overview
Mr. Black is a premium nightlife management platform designed to automate event discovery, ticket purchasing, VIP table reservations, and real-time check-in. It serves event organizers, promoters, and venue managers by providing an end-to-end flow with opaque tracking links, real-time analytics, secure Stripe bookings, and staff scanning dashboards.

---

## Tech Stack & Versions
### Frontend
- **React**: ^19.0.0
- **Vite**: ^6.2.0
- **Build & UI**: TailwindCSS ^4.1.14, `@base-ui/react` ^1.3.0, Framer Motion ^12.4.10, Recharts ^2.15.4
- **SDKs**: Firebase Client ^11.4.0, Stripe React SDK

### Backend
- **Express**: ^4.21.2
- **TypeScript**: ^5.8.2
- **Database / Auth Libraries**: `pg` ^8.20.0, Firebase Admin ^13.7.0, Supabase (`@supabase/supabase-js`)
- **Integrations**: Stripe ^21.0.1, Resend ^6.10.0 (Emails), Twilio (SMS fallback)

---

## Folder & File Structure
- `backend/`
  - `src/modules/`: Domain-driven module structure encapsulating routes and business logic. Massive refactoring recently split bloated routes files into granular feature directories (e.g. `reservations/core/features/checkin`, `phone`, etc.).
    - Core domains include: `admin`, `analytics`, `auth`, `billing`, `communications`, `dashboard`, `events` (with `guestlist`), `promoter`, `reservations`, `shared`, `venue` (with `tables`, `membership`).
    - `shared/`: Contains authorization `authz/venueAccess.ts`, `services/dashboardCache.ts`, and background jobs.
  - `scripts/`: Utilities for migrations, seeding, and smoke tests.
  - `db_setup.sql`: Comprehensive PostgreSQL schema defining tables, views, and indexes.
- `frontend/`
  - `src/pages/`: React router views governing UI modules (Home, Reports, Booking flows, Staff dashboards).
  - `src/components/`: Reusable components, including customized Shadcn and Base UI components.
  - `src/firebase.ts`: Configuration for client-side Firebase connectivity.

---

## Environment Variables
The following environment variables are referenced in the codebase (no values included):
- `APP_URL`
- `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `VITE_STRIPE_PUBLISHABLE_KEY`
- `PGHOST`, `PGUSER`, `PGPASSWORD`, `PGDATABASE`, `PGPORT`, `DATABASE_URL`
- `RESEND_API_KEY`
- `TWILIO_ACCOUNT_SID`, `TWILIO_AUTH_TOKEN`, `TWILIO_FROM_NUMBER`
- `FIREBASE_API_KEY`, `FIREBASE_SERVICE_ACCOUNT_KEY`, `FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL`, `FIREBASE_PRIVATE_KEY`
- `RESERVATION_PAY_TOKEN_SECRET`, `RESERVATION_OTP_PROVIDER`, `RESERVATION_OTP_SECRET`
- `VITE_IMAGE_UPLOAD_MODE`, `IMAGE_UPLOAD_MODE`
- `VITE_API_BASE_URL`
- Debug/Bypass Toggles: `BYPASS_EXTERNAL_SERVICES`, `BYPASS_STRIPE`

---

## Database Models & Schema Summary
A relational PostgreSQL schema housed in Supabase acts as the primary data stronghold:
- **Core Commerce**: `events`, `venues`, `venues_sections`, `venue_tables`, `tickets`, `reservations`, `payments`, `checkout_locks`.
- **CRM & Tracking**: `guestlists`, `promoters`, `promoter_teams`, `promoter_links`, `customers`, `customer_visits`, `customer_inquiries`, `customer_tags`, `staff_notifications`.
- **Analytics Views**: `promoter_stats`, `event_performance`, `customer_crm_stats`, `table_performance`, `promoter_performance`.
- **Background Jobs**: `webhook_retry_jobs`, `staff_notification_jobs`.

---

## API Endpoints List
The backend Express app serves over 80+ active endpoints, following RESTful `v2` standards grouped by domain:

**Admin/Analytics**
- `GET/POST /api/v2/admin/events`
- `DELETE /api/v2/admin/events/:id`
- `POST /api/v2/admin/events/upload-image`
- `GET /api/v2/admin/customers`
- `GET/POST /api/v2/admin/promoter-teams`
- `GET /api/v2/admin/audit-logs`
- `GET /api/v2/admin/analytics`
- `POST /api/v2/admin/staff`
- `GET /api/v2/analytics/table-performance`
- `GET /api/v2/analytics/promoter-performance`
- `GET /api/v2/analytics/customer-ltv`

**Payments / Stripe Webhooks**
- `POST /api/v2/payments/create-intent`
- `POST /api/v2/payments/:id/reconcile`
- `POST /api/v2/webhooks/stripe`

**Communications / Notifications**
- `POST /api/v2/communications/inquiries`
- `POST /api/v2/communications/inquiries/:id/respond`
- `POST /api/v2/communications/guest-reply`
- `GET /api/v2/staff/notifications`
- `PATCH /api/v2/staff/notifications/:id/read`

**Events / Venus Core**
- `GET /api/v2/events[/:eventId]`
- `GET /api/v2/events/:eventId/booking-layout`
- `GET/POST/PATCH /api/v2/venues[/:venueId]`
- `GET/POST/PATCH/DELETE /api/v2/venues/:venueId/sections[/:sectionId]`
- `POST/PATCH/DELETE /api/v2/venues/:venueId/tables[/:tableId]`

**Reservations / Walk-ins / Flow**
- `POST /api/v2/reservations`
- `GET /api/v2/reservations`
- `PATCH /api/v2/reservations/:id/(confirm|cancel|no-show)`
- `POST /api/v2/reservations/:id/(complete|spend)`
- `POST /api/v2/reservations/phone/(send-otp|verify-otp)`
- `POST /api/v2/walkins`
- `POST /api/v2/checkin/scan`
- `POST /api/v2/checkin/:reservationId`

**Users / Customers / Promoters**
- `GET /api/user/(reservations|bookings|performance|guestlists)`
- `POST /api/guestlist/join`
- `POST /api/v2/promoters[/:venueId]`
- `GET /api/v2/promoters/:venueId/links`
- `GET /api/v2/customers[/:id/profile]`
- `POST /api/v2/customers/:id/(notes|tags)`

---

## Authentication Approach
- **Firebase Auth Module**: OAuth (Google/Apple Sign-In) and Phone Verification (OTP).
- **Backend Authorization Guards**: Express middlewares (e.g., `requireAuth`, `requireRoles(...)`) read decoded Firebase ID JWTs directly to ensure RBAC protections against role flags stored on user records (roles include `'admin'`, `'manager'`, `'promoter'`, `'doorman'`, `'staff'`, etc.).

---

## Current Coding Conventions
1. **Strong Domain-Driven Modules**: API features are meticulously encapsulated in `/src/modules/` with routes, services, and middlewares logically grouped.
2. **PostgreSQL Relational Superiority**: Supabase operates as the data nexus heavily optimized through raw SQL views and Row Level Security.
3. **Transaction Rigidity**: Heavy locks during checkout logic (checkout_locks) prioritizing financial and slot concurrency idempotency.
4. **Typed Strictly**: Vite+React frontend components strongly typed leveraging `lucide-react` for iconography and `clsx/tailwind-merge` for scalable dynamic style applications.

---

## Current Application Progress Status
- [x] **Core Platform Work**: Robust routing structure established. Bloated route files (e.g. reservations) heavily refactored into modular sub-features.
- [x] **Secure Stripe Handshakes**: Webhook idempotency and checkout integrations validated against database locks.
- [x] **Communication/Accounts**: Firebase Auth (Phone/OTP provider, test number overrides present), Twilio, and Resend operational.
- [x] **Analytics & Dashboards**: Deep promoter tracking mechanisms, Dashboard caching service (`dashboardCache.ts`) integrated.
- [ ] **Complex Scaling Features**: Missing frontend capacity validations (tickets < capacity), complete Transient Blocking (basket lockdown timers) fully functionalization.
- [ ] **V2 Admin Dashboards Mapping**: Full backend parity transition with dynamic visualization mappings and refined search features (Phase 3 Roadmap).
