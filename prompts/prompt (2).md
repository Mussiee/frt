# Flutter UI Build Prompt — Focus- Venue Ops App

## CONTEXT — READ EVERYTHING BEFORE TOUCHING ANY FILE

You are building the **Flutter mobile frontend** for **Focus-**, a nightclub / venue operations management app. This is a **mobile-first** application (not desktop, not tablet — think iPhone/Android portrait layout).

The **auth flow is already built** (splash, phone entry, OTP verify, name entry screens). **Do NOT touch** anything in `lib/features/auth/`.

Your job is to build **all remaining screens as pure UI only**. There is **zero backend integration required**. Every screen must use **hardcoded mock data / placeholder data** so the integration team can later wire up real API calls with minimal friction. Think of it as a pixel-perfect, fully navigable prototype that lives inside the real Flutter codebase.

---

## DESIGN LANGUAGE (NON-NEGOTIABLE)

The app design is dark, premium, and operational. Every screen you produce must feel like the reference images — not a generic Material Design app.

### Palette
| Token | Color |
|---|---|
| Background | `#0A0A0A` (near-black) |
| Surface / Card | `#141414` |
| Elevated Card | `#1C1C1C` |
| Primary Accent | `#F0A500` (golden amber) |
| Secondary Accent | `#F5C518` (lighter gold, used sparingly) |
| Text Primary | `#FFFFFF` |
| Text Secondary | `#A0A0A0` |
| Success / Free | `#22C55E` (green) |
| Warning / Reserved | `#F0A500` (amber) |
| Error / Occupied | `#EF4444` (red) |
| Border / Divider | `#2A2A2A` |

### Typography
- Font family: **Inter** (Google Fonts) — already likely in pubspec, add if missing.
- Headings: Bold, white, letter-spacing slight negative.
- Labels / Captions: `#A0A0A0`, uppercase + letter-spacing for column headers.

### Component Rules
- Cards: `BorderRadius.circular(12)`, `Color(0xFF141414)` background, thin `Color(0xFF2A2A2A)` border.
- Primary buttons: `Color(0xFFF0A500)` background, black text, `BorderRadius.circular(8)`.
- Destructive buttons: `Color(0xFFEF4444)` background, white text.
- Ghost/outline buttons: transparent with `Color(0xFF2A2A2A)` border.
- Status chips: small rounded rectangles, color-coded (see palette).
- Table/row tap feedback: `Color(0xFF1C1C1C)` highlight, never pure white splash.
- Avatar initials: golden amber background, black text, `BorderRadius.circular(8)` (square-ish, not circle).

### Navigation
- Bottom navigation bar **is NOT used**. This is a role-based app.
- After login, users are routed to their **role-specific shell** which has a **sidebar (NavigationDrawer or custom left drawer)** matching the design images.
- The sidebar items depend on role (see role section below).

---

## ROLE SYSTEM

After authentication the backend will return a role. For now, mock it. Create a `MockAuthProvider` or `MockSession` that stores the current active role. Provide a **role switcher on the Settings or Profile page** or a debug floating button so the integration team can test different role views easily.

### Roles and their sidebar nav items:

| Role | Sidebar Items |
|---|---|
| OWNER / MANAGER | Dashboard, Reservations, Promoters, CRM, Event Requests, Settings |
| HOST | Dashboard, Reservations, Tables (Floor View), Settings |
| STAFF (Server/Bartender) | My Tables, Settings |
| SECURITY | QR Scanner, Checked-In List, Settings |
| PROMOTER | My Stats, My Link, Settings |

---

## SCREENS TO BUILD — COMPLETE LIST

> ### ⚠️ IMPORTANT — SCREENSHOTS vs PLAN-DERIVED SCREENS
>
> You have been provided with **reference screenshots for only 5 screens**. These are desktop-resolution mockups — adapt them to mobile portrait:
>
> | # | Screen | Has Screenshot? |
> |---|---|---|
> | 0 | Root Shell / Role Router | ❌ Infer from design language |
> | 1 | Dashboard (Owner/Manager) | ❌ Infer from plan + design language |
> | 2 | Reservations List | ❌ Infer from plan + design language |
> | 3 | Reservation Detail | ❌ Infer from plan + design language |
> | **4** | **Floor View — Table Map** | ✅ **Screenshot provided (table bottom sheet detail)** |
> | **5** | **Promoters List** | ✅ **Screenshot provided** |
> | **6** | **Promoter Detail** | ✅ **Screenshot provided** |
> | 7 | CRM Customer List | ❌ Infer from design language |
> | **8** | **Customer Detail (CRM Profile)** | ✅ **Screenshot provided** |
> | **9** | **Event Requests** | ✅ **Screenshot provided** |
> | 10 | Event Request Detail | ❌ Infer from plan + design language |
> | 11 | QR Scanner (Security) | ❌ Infer from plan + design language |
> | 12 | Checked-In List (Security) | ❌ Infer from plan + design language |
> | 13 | My Tables (Server/Bartender) | ❌ Infer from plan + design language |
> | 14 | Table Detail (Server View) | ❌ Infer from plan + design language |
> | 15 | Promoter — My Stats | ❌ Mirror Promoter Detail, self-view |
> | 16 | Promoter — My Link | ❌ Infer from plan + design language |
> | 17 | Settings | ❌ Infer from design language |
> | 18 | Notifications | ❌ Infer from design language |
>
> **For all ❌ screens:** design them yourself using the same dark premium design language (colors, cards, typography, chips) defined in the DESIGN LANGUAGE section above. They must feel visually identical to the ✅ screens.
>
> **The 5 screenshots are desktop mockups.** Do NOT copy the layout literally. Adapt every multi-column layout to a single-column mobile scroll. Sidebars become drawers.

---

### 0. Root Shell / Role Router
- After auth → route to correct shell based on `MockSession.role`.
- Each role gets its own shell widget that wraps the sidebar + content area.
- Sidebar shows venue name ("Focus-"), role badge, and nav items.
- Top app bar shows: page title left, notification bell icon + history icon + user avatar right.

---

### 1. DASHBOARD (OWNER / MANAGER)
**Route:** `/dashboard`

**Layout:** Top stats row + recent activity list.

**Mock data:**
- Stats cards: `Pending Requests: 24`, `Today: 08`, `Active Promoters: 142`, `Tonight's Revenue: $4,820`.
- Recent reservations list (4–6 rows): name, phone, date, section badge (MAIN FLOOR / THE VAULT / THE TERRACE / VIP LOUNGE), status chip, Approve + Reject buttons.

**Key UI details from design images:**
- Page title: large, bold, golden/white — "COMMAND CENTER" or section-specific heading.
- Stats in small cards top of page.
- Table/list section below titled "LIVE REQUEST QUEUE" with Export CSV + Filters buttons.
- Each row: avatar initials, name + role subtitle, phone, requested date, section badge (colored), status chip, action buttons.
- Pagination at bottom (Previous / 1 2 3 / Next).

---

### 2. RESERVATIONS LIST
**Route:** `/reservations`

**Layout:** Filter tabs (ALL / PENDING / CONFIRMED / CHECKED IN / COMPLETED / NO SHOW) + scrollable list.

**Mock data:** 8–10 reservation rows with varied statuses.

**Each row shows:**
- Customer name + avatar initials
- Date & time
- Section (colored badge: MAIN FLOOR, THE VAULT, THE TERRACE, VIP LOUNGE, SKY LOUNGE)
- Party size
- Payment status (PAID / DEPOSIT ONLY / UNPAID)
- Status chip
- 3-dot action menu (View, Check In, No Show, Cancel)

**Tapping a row** navigates to the **Reservation Detail** screen.

---

### 3. RESERVATION DETAIL
**Route:** `/reservations/:id`

**Layout:** Full screen detail card.

**Sections:**
- Guest info: avatar, name, phone, tier badge (VIP GOLD / PLATINUM / etc.)
- Booking info: date, time, party size, section, table number if assigned
- Payment: amount, status
- Status chips + action row: Confirm / Check In / No Show / Cancel
- Notes field (editable text area)
- Promoter attribution (if any): promoter name chip

---

### 4. FLOOR VIEW — TABLE MAP (HOST / OWNER / MANAGER)
**Route:** `/tables`  
**⚠️ THIS IS THE MOST CRITICAL SCREEN — READ CAREFULLY**

The venue has **3 floors / zones**. Build a **tab switcher** at the top to switch between zones:
- **MAIN FLOOR**
- **THE VAULT VIP**
- **THE TERRACE**

(Add a 4th tab **SKY LOUNGE / BAR** if spacing permits, or combine with Terrace)

**Table Layout Rules:**
- Each table is a **tappable circular widget**.
- Color indicates status:
  - 🟢 `Color(0xFF22C55E)` → FREE
  - 🟡 `Color(0xFFF0A500)` → RESERVED
  - 🔴 `Color(0xFFEF4444)` → OCCUPIED
- Table labels: "201", "202", "301" etc. inside the circle.
- Arrange tables in a **grid/wrap layout that looks like a real floor plan** — not a perfect uniform grid. Use `Wrap` with irregular positioning or a `Stack` with `Positioned` widgets to mimic a physical floor feel.
- The selected/tapped table gets a gold ring / glow border.

**Mock data for each zone:** 8–12 tables each with random statuses.

**On table tap → show Bottom Sheet (Table Detail Panel):**
```
┌─────────────────────────────────────────────┐
│  🍴  TABLE 201                    RESERVED  │
│─────────────────────────────────────────────│
│  CUSTOMER SECTION    │  SERVER SECTION       │
│  Julian Casablancas  │  Alex R.              │
│  +1 555-0123         │  LEAD SERVER          │
│─────────────────────────────────────────────│
│  📅 DATE             │  👥 PARTY SIZE        │
│  Fri, Oct 27, 2023   │  04 GUESTS            │
│─────────────────────────────────────────────│
│  🔷 AREA             │                       │
│  VIP LOUNGE          │                       │
│─────────────────────────────────────────────│
│  [ ASSIGN CUSTOMER ]  [ ASSIGN SERVER ]      │
│  [ MARK FREE ]        [ VIEW RESERVATION ]   │
└─────────────────────────────────────────────┘
```

- This bottom sheet EXACTLY matches the provided design image.
- For FREE tables: show "ASSIGN CUSTOMER" + "ASSIGN SERVER" buttons only.
- For RESERVED: show all fields + action buttons.
- For OCCUPIED: add "Mark as Free" button.

**Assign Customer flow (mock only):**  
Tapping "ASSIGN CUSTOMER" opens a search bottom sheet with a list of mock pending reservations the host can pick from.

**Assign Server flow (mock only):**  
Tapping "ASSIGN SERVER" opens a bottom sheet with a list of mock staff members to choose from.

---

### 5. PROMOTERS LIST (OWNER / MANAGER)
**Route:** `/promoters`

**Layout matches the design image exactly.**

**Top section:**
- Page title "PROMOTERS" + subtitle "Manage referral networks and performance tracking."
- "+ CREATE PROMOTER" golden button top right.

**Stats row (4 cards):**
- Active Promoters: `142`
- Total Revenue: `$248.5K`
- Total Bookings: `1,829`
- Top Performer: `V. RUSSO`

**Table (the columns from the image):**
| PROMOTER NAME | REFERRAL LINK | TOTAL BOOKINGS | PAID BOOKINGS | REVENUE | ACTIONS |
|---|---|---|---|---|---|

- 5 mock rows matching the image (Valentino Russo, Sarah Jenkins, Marcus Jordan, Elena Meyer, David Hanes).
- Referral link shows truncated URL + copy icon.
- Paid bookings shown in a green pill/chip.
- Revenue in amber text.
- Actions: 3-dot vertical menu (View, Edit, Deactivate).
- Pagination: `SHOWING 5 OF 142 PROMOTERS` + prev/next/page buttons.
- Each row is **tappable** → navigates to Promoter Detail screen.

**Bottom section (2 cards side by side):**
- "PROMOTER ANALYTICS" with download icon.
- "PAYOUT SETTINGS" with settings icon.

---

### 6. PROMOTER DETAIL
**Route:** `/promoters/:id`

**Layout matches the provided design image.**

**Top section:**
- Avatar (square, initials, amber bg): "MR"
- Name: "Marc Russo"
- Badge: "LEAD PROMOTER"
- Join date: "Joined Oct 2023"

**Referral link row:**
- Link text: `nightops.com/ref/mrusso_77`
- "COPY LINK" amber button.

**Stats row (3 cards):**
- Total Bookings: `342` + `+12% from last month`
- Paid Bookings: `289` + `84.6% conversion rate`
- Revenue Generated: `$14,240` + `$2,455 this month`

**Recent Reservations table:**
- "Recent Reservations" heading + FILTER chip + "ALL BOOKINGS" active chip.
- Columns: CUSTOMER | STATUS | PAYMENT | DATE | ACTIONS
- 3 mock rows:
  - Julianne Davis | ARRIVED (green) | $850.00 FULLY PAID | Oct 24, 2023 | 3-dot
  - Soren Miller | CONFIRMED (amber) | $2,400.00 DEPOSIT ONLY | Oct 25, 2023 | 3-dot
  - Kelly Lowman | NO SHOW (red) | $0.00 SUBMITTED | Oct 23, 2023 | 3-dot
- Pagination: Previous / 1 2 3 / Next

---

### 7. CRM — CUSTOMER LIST (OWNER / MANAGER / HOST)
**Route:** `/crm`

**Layout:**
- Page title "CRM" + subtitle.
- Search bar at top.
- Filter chips: ALL / VIP / RETURNING / NEW / NO SHOW.
- Customer list rows: avatar, name, tier badge, phone, total spend, visit count, last visit date, 3-dot menu.
- Each row tappable → Customer Detail.
- FAB (golden `+`) to add new customer (walk-in).

**Mock data:** 6–8 customers with various tiers (VIP GOLD, PLATINUM, MEMBER, NEW).

---

### 8. CUSTOMER DETAIL (CRM Profile)
**Route:** `/crm/:id`

**Layout matches the provided design image.**

**Top section:**
- Customer avatar (photo placeholder or initials): "Alex Rivera"
- Phone: `+1 355-012`
- Email: `a.rivera@example.com`
- Tier badge: "VIP GOLD" (golden)
- Actions: "EDIT PROFILE" ghost button + "CREATE BOOKING" amber button.

**Stats row (2 big cards):**
- Total Visits: `12` Lifetime
- Total Spend: `$3,450` USD

**Tier progress bar:**
- "NEXT TIER PROGRESS" label + "Diamond Member" + progress bar at 40%.

**Reservation History table:**
- "Reservation History" heading + "VIEW ALL" link.
- Columns: DATE | STATUS | PROMOTER | PAYMENT | ACTION
- 4 mock rows matching the image (various statuses and amounts).
- Each row has 3-dot action icon.

**Right section (side panel OR below on mobile — stack vertically):**
- "Booked via Promoters" card:
  - Marcus Vance — Primary Contact, Last 10 days ago → tappable `>`
  - Sarah Lowery — Referral, Last 40 days ago → tappable `>`
  - Direct / No Promoter — 4 bookings total
  - "ASSIGN NEW PROMOTER" button at bottom.

---

### 9. EVENT REQUESTS (OWNER / MANAGER)
**Route:** `/event-requests`

**Layout matches the provided design image.**

**Top section:**
- Page title "EVENT REQUESTS" (large, golden amber).
- Subtitle: "Manage incoming VIP and corporate booking applications".
- 2 stat badges: `Pending: 24` | `Today: 08`.

**Priority spotlight card:**
- Shows the highest priority request: image + "PRIORITY SECTION: The Vault VIP" + "DEMAND LEVEL: HIGH CAPACITY".

**Live Request Queue table:**
- "LIVE REQUEST QUEUE" heading + "EXPORT CSV" + "FILTERS" buttons.
- Columns: NAME | CONTACT | REQUESTED DATE | SECTION | STATUS | ACTION
- 4 mock rows matching the image (Jonathan Sterling, Elena Rodriguez, Marcus Thorne, Adrian Miller).
- Section badges with colors (MAIN FLOOR VIP amber, THE TERRACE teal, THE VAULT VIP orange, VIP LOUNGE grey).
- Status chips (REVIEWING orange/amber, INCOMING blue, PRIORITY REVIEW red, PENDING INFO grey).
- Action buttons per row: green "APPROVE" + red "REJECT".
- Pagination at bottom.

**Row tap → Event Request Detail screen.**

---

### 10. EVENT REQUEST DETAIL
**Route:** `/event-requests/:id`

**Layout:**
- Requester info (name, company, contact).
- Event details (date, section requested, party size, estimated spend).
- Additional notes / description.
- Status timeline (requested → reviewing → approved/rejected).
- Action buttons: "APPROVE REQUEST" (green) + "REJECT REQUEST" (red) + "REQUEST MORE INFO" (ghost).

---

### 11. QR SCANNER (SECURITY ROLE)
**Route:** `/scanner`

**Layout:**
- Full-screen camera preview with scan frame overlay (golden corner brackets).
- Instructions text: "Point camera at guest ticket QR code".
- Result overlay slides in from bottom on scan:
  - ✅ VALID: green background, guest name, reservation details, "CHECK IN" confirm button.
  - ❌ INVALID / ALREADY USED: red background, error message.

**Mock behavior:** Add a "Simulate Scan" FAB that cycles through valid / invalid / already-used states.

---

### 12. CHECKED-IN LIST (SECURITY)
**Route:** `/checked-in`

**Layout:**
- Page title "CHECKED-IN GUESTS".
- Stats: `Checked In: 47` | `Expected: 120`.
- Searchable list of checked-in guests: name, table, check-in time, section.
- Each row has a "VIEW TICKET" icon.

---

### 13. MY TABLES (SERVER / BARTENDER ROLE)
**Route:** `/my-tables`

**Layout:**
- Page title "MY TABLES" or "MY SECTION".
- Shows only the tables assigned to this staff member.
- Each table card:
  - Table number (large, bold).
  - Customer name + guests count.
  - Section/area.
  - Status chip.
  - Quick action buttons: "ADD NOTE" + "UPDATE SPEND" + "MARK FREE".
- Tapping anywhere on a card → Table Detail for staff.

**Mock data:** 3 assigned tables.

---

### 14. TABLE DETAIL (SERVER VIEW)
**Route:** `/my-tables/:id`

**Layout:**
- Table number heading.
- Customer section: name, phone, party size.
- Current spend tracking: amount input field + "UPDATE" button.
- Notes section: text area + "SAVE NOTE" button.
- "MARK TABLE AS FREE" destructive button at bottom.
- History of notes/updates (3 mock entries with timestamps).

---

### 15. PROMOTER — MY STATS (PROMOTER ROLE)
**Route:** `/my-stats`

**Layout (mirrors Promoter Detail but self-view):**
- Name + avatar + "LEAD PROMOTER" badge.
- Referral link + COPY LINK button.
- Stats: Total Bookings, Paid Bookings, Revenue Generated.
- Recent reservations I brought in (table as in Promoter Detail).

---

### 16. PROMOTER — MY LINK (PROMOTER ROLE)
**Route:** `/my-link`

**Layout:**
- Big display of referral link.
- QR code image of the link (use a placeholder QR widget or the `qr_flutter` package).
- COPY LINK button.
- SHARE button (uses Flutter's share_plus or mock).
- Stats: clicks, conversions this week.

---

### 17. SETTINGS
**Route:** `/settings`

**Layout:**
- Profile section: avatar, name, phone, role badge.
- **ROLE SWITCHER (CRITICAL FOR INTEGRATION TEAM):** A dropdown or list of roles — when switched, the app re-routes to the correct shell. This is a developer/debug tool and should be clearly labeled "DEV: Switch Role".
- Appearance section (dark mode toggle — always dark for now, just placeholder).
- Logout button (navigates back to splash/phone entry).
- App version info.

---

### 18. NOTIFICATIONS
**Route:** `/notifications`

**Layout:**
- List of notification items: icon, title, subtitle, timestamp.
- Mock data: 5–8 notifications (new booking, payment received, event request, check-in alert).
- Three-dot menu per item (Mark Read / Delete).
- "MARK ALL READ" button at top.

---

## FOLDER STRUCTURE TO CREATE

```
lib/
  features/
    auth/               ← ALREADY EXISTS, DO NOT TOUCH
    dashboard/
      presentation/
        screens/
          dashboard_screen.dart
    reservations/
      data/
        mock_reservations.dart
      presentation/
        screens/
          reservations_screen.dart
          reservation_detail_screen.dart
    tables/
      data/
        mock_tables.dart
      presentation/
        screens/
          floor_view_screen.dart
          table_detail_server_screen.dart
        widgets/
          table_circle_widget.dart
          table_bottom_sheet.dart
          floor_zone_tab.dart
    promoters/
      data/
        mock_promoters.dart
      presentation/
        screens/
          promoters_screen.dart
          promoter_detail_screen.dart
    crm/
      data/
        mock_customers.dart
      presentation/
        screens/
          crm_screen.dart
          customer_detail_screen.dart
    event_requests/
      data/
        mock_event_requests.dart
      presentation/
        screens/
          event_requests_screen.dart
          event_request_detail_screen.dart
    security/
      presentation/
        screens/
          qr_scanner_screen.dart
          checked_in_screen.dart
    staff/
      presentation/
        screens/
          my_tables_screen.dart
          table_detail_server_screen.dart
    promoter_role/
      presentation/
        screens/
          my_stats_screen.dart
          my_link_screen.dart
    notifications/
      presentation/
        screens/
          notifications_screen.dart
    settings/
      presentation/
        screens/
          settings_screen.dart
  shared/
    widgets/             ← REUSE AND ADD TO THIS
      app_sidebar.dart
      status_chip.dart
      section_badge.dart
      avatar_widget.dart
      data_table_row.dart
      pagination_widget.dart
      stats_card.dart
      table_circle.dart
    mock_session.dart    ← Role state + switcher
  utils/
    router/
      app_router.dart    ← ADD ALL NEW ROUTES HERE
    theme/               ← ALREADY EXISTS
```

---

## MOCK DATA GUIDELINES

Each feature folder has a `data/mock_*.dart` file. Structure mock data as plain Dart classes (no freezed, no json_serializable needed — just simple classes or maps) so the integrator team can easily drop in real API calls.

Example structure:
```dart
// mock_reservations.dart
class MockReservation {
  final String id;
  final String customerName;
  final String phone;
  final String section;
  final String status; // 'requested' | 'confirmed' | 'paid' | 'checked_in' | 'completed' | 'no_show'
  final String paymentStatus; // 'unpaid' | 'deposit' | 'paid'
  final DateTime date;
  final int partySize;
  final String? promoterName;
  final String? tableNumber;
  // ... etc
}

final List<MockReservation> mockReservations = [ /* hardcoded data */ ];
```

Keep naming consistent with the plan's entity model (reservation, table, promoter, customer, etc.) so integration is straightforward.

---

## ROUTING

Use `go_router` (check pubspec — already installed, or add it). Define all routes in `utils/router/app_router.dart`.

The initial route after auth success routes to `/dashboard` or the correct role-based home screen based on `MockSession.role`.

Named routes to define:
```
/dashboard
/reservations
/reservations/:id
/tables
/promoters
/promoters/:id
/crm
/crm/:id
/event-requests
/event-requests/:id
/scanner
/checked-in
/my-tables
/my-tables/:id
/my-stats
/my-link
/notifications
/settings
```

---

## WHAT TO KEEP IN MIND — CRITICAL RULES

1. **NO BACKEND CALLS. ZERO.** No `http`, no `dio` calls. Not even a single `Future.delayed` to fake loading unless it improves UX. Pure synchronous mock data only.

2. **MOBILE PORTRAIT LAYOUT.** Every screen must look correct on a standard phone (375–430px wide). The reference images are desktop-like but you are building a **mobile app**. Adapt the layouts responsively — tables/lists scroll horizontally if needed, sidebars are drawers, multi-column layouts stack vertically.

3. **THE TABLE/FLOOR VIEW IS THE MOST CRITICAL SCREEN.** It MUST be pixel-perfect in terms of interaction: 3 zone tabs, colored tables, tap-to-open bottom sheet with the exact fields from the design image. Do not simplify this.

4. **ALL TABLES AND LISTS MUST BE TAPPABLE** with correct navigation or bottom sheet action.

5. **STATUS CHIPS** must be color-coded consistently across ALL screens:
   - REQUESTED / REVIEWING / PENDING → amber `#F0A500`
   - CONFIRMED / PAID / ARRIVED / VALID → green `#22C55E`
   - NO SHOW / REJECTED / OCCUPIED / INVALID → red `#EF4444`
   - INCOMING / INFO → blue `#3B82F6`
   - DEPOSIT ONLY / PRIORITY → orange `#F97316`

6. **SECTION BADGES** (MAIN FLOOR, THE VAULT VIP, THE TERRACE, VIP LOUNGE, SKY LOUNGE) should each have a distinct color. Suggest:
   - MAIN FLOOR VIP: amber
   - THE VAULT VIP: orange/dark
   - THE TERRACE: teal/green
   - VIP LOUNGE: purple
   - SKY LOUNGE: blue

7. **PAGINATION WIDGET** must be a shared reusable widget used on ALL list/table screens.

8. **SIDEBAR NAV** is a shared `AppSidebar` widget used across role shells. It must show the correct items per role. Use `MockSession.role` to determine what to show.

9. **SETTINGS SCREEN MUST INCLUDE THE ROLE SWITCHER.** This is how the integration team tests different role UIs. Label it clearly as a developer tool.

10. **DO NOT modify** `lib/features/auth/`, `lib/utils/theme/`, or any existing files unless you need to add routes to `app_router.dart` or add packages to `pubspec.yaml`.

11. **ALL SCREENS** must have proper `Scaffold`, `AppBar` (or custom top bar), and be wrapped in the role shell. No bare widget trees.

12. **Use `SafeArea`** everywhere. This is a mobile app.

---

## PACKAGES YOU MAY ADD (if not already in pubspec)

- `google_fonts` — Inter typeface
- `go_router` — routing
- `qr_flutter` — QR code display (My Link screen, Ticket screen)
- `mobile_scanner` — QR scanner (Security QR screen) — use a mock fallback if camera not available in simulator

Do NOT add state management packages (bloc, riverpod, provider) beyond what already exists. This is UI only — use `StatefulWidget` and `setState` where local state is needed.

---

## PRIORITY ORDER

If you need to work in stages, prioritize in this order:

1. AppSidebar + MockSession + Role Shell scaffolding
2. Floor View / Table Map (CRITICAL)
3. Reservations List + Detail
4. Event Requests
5. Promoters List + Detail
6. CRM Customer List + Detail
7. Dashboard
8. QR Scanner (Security)
9. My Tables (Server)
10. Promoter Role Screens
11. Notifications + Settings

---

## SUMMARY

Build a **beautiful, dark, premium mobile Flutter UI** for a nightclub operations app. Use the reference images (desktop mockups) as the design source for layout, colors, and content — then adapt them to mobile portrait. All data is hardcoded mock data. The floor view with 3-zone tabs and interactive tappable colored tables is the most important feature. Every list must be tappable. Do not touch the auth screens. Make it easy for an integration team to swap mock data for real API calls.
