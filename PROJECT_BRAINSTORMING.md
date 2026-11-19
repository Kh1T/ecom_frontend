# Project Brainstorming

## 1. Project Goal

Build a single Flutter e-commerce app where customers browse and buy products, and administrators manage the catalog. One codebase, role-based access.

## 2. Current Foundation

| Area | Existing in project |
| --- | --- |
| Authentication | Sign in / sign up, role check after login (admin vs customer) |
| Customer | Home, product list, search, cart (add, change quantity, remove, clear) |
| Admin | Admin panel, route guard (`AdminMiddleware`), admin-only sidebar item |
| Products | Fetch, create, update, delete, status change, image upload/delete, variants |
| Config | Backend URL and keys loaded from `.env` via `flutter_dotenv` |
| Stack | Flutter, GetX (routing, state, DI), Dio (HTTP) |

## 3. Feature Ideas

### Customer side
- Product detail page with image gallery and variant picker (size, colour, etc.)
- Search filters: category, price range, availability, sort by price or newest
- Cart persistence across app restarts (local storage, server sync when signed in)
- Checkout flow: address, delivery method, order summary, payment placeholder
- Order history and order status tracking
- Profile page: edit name, change password, saved addresses
- Wishlist / favourites
- Stock warning when quantity exceeds availability

### Admin side
- Dashboard with real stats: total products, active products, orders, revenue
- Product list with search, filter by status, and bulk status change
- Image reordering (the API already accepts `sortOrder`)
- Variant management screen (stock per variant)
- Order management: view orders, update status (pending, shipped, delivered)
- Simple audit trail: who changed which product and when

### Cross-cutting
- Consistent loading, empty, and error states across screens
- Dark mode support (theme file already exists)
- Offline-friendly cached product list
- Input validation on all forms (sign-up, product create/edit, checkout)
- Unit tests for controllers and the admin middleware; widget test for sign-in

## 4. Scope Options

Pick a level based on time and assignment requirements.

| Level | Includes | Effort |
| --- | --- | --- |
| Minimum | Auth, role routing, product browse, cart, admin product CRUD | Done or nearly done |
| Recommended | Minimum + product detail, checkout, order history, admin dashboard stats | Medium |
| Stretch | Recommended + wishlist, filters, order status management, dark mode, tests | Large |

Suggested target: **Recommended**.

## 5. Technical Considerations

- **Backend dependency:** most features depend on the API contract (`/api/v1/products`, `/api/v1/admin/products`). Agree on endpoints for orders and cart before building checkout.
- **Cart source of truth:** decide whether cart lives locally, on the server, or both. Current cart controller should be checked before adding sync.
- **Secrets:** keep `.env` out of version control; `.env.example` documents required keys.
- **State management:** keep one pattern per feature (controller + binding + view), matching the existing modules.
- **Images:** product images come from the backend; plan for placeholder and loading states.
- **Admin security:** the client guard only improves UX. The backend must enforce admin-only endpoints.

## 6. Risks

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Backend endpoints missing or changing | Blocked features | Confirm API contract early; mock responses locally |
| Scope creep | Unfinished app at deadline | Lock scope to chosen level; park stretch items |
| Client-only admin check | Security gap | Enforce role checks on the server |
| Cart out of sync with server | Wrong totals or stock | Single source of truth; refresh on sign-in |
| Lint and test debt | Harder grading | Run `flutter analyze` and `flutter test` before each milestone |

## 7. Milestones

1. **Stabilise:** confirm sign-in, role routing, product list, and cart work end to end against the backend.
2. **Customer flow:** product detail, checkout, order history.
3. **Admin flow:** dashboard stats, order status management, variant stock.
4. **Polish:** empty and error states, validation, dark mode check.
5. **Quality:** tests for controllers and middleware, README update, demo script.

## 8. Open Questions

- Does the backend already expose order and checkout endpoints?
- Is payment real or a placeholder for the assignment?
- Is cart stored per user on the server, or only on the device?
- Which features are mandatory according to the assignment brief?
- Is the target demo on Android, iOS, web, or all three?
