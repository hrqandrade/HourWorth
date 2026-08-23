# HourWorth Roadmap

This roadmap combines product delivery with the technical evolution required to keep HourWorth reliable, testable and maintainable. Architectural work is introduced when it protects a business capability or removes a measurable delivery risk.

## Delivery principles

- Keep `main` releasable and integrate work through `develop`.
- Prefer small vertical slices over framework-first rewrites.
- Pair every new business rule with deterministic tests.
- Migrate persistence without changing domain behavior.
- Treat accessibility, localization and data integrity as product requirements.
- Record major architectural decisions in short ADRs.

## 1.0.0 — MVP foundation

Status: in progress

### Product

- Clients and projects
- Fixed-price and hourly billing
- Tasks and progress
- Timestamp-based timer
- Manual work sessions
- Manual payments
- Dashboard metrics
- Project completion result

### Engineering exit criteria

- CI builds the app and executes domain tests
- Repository documentation explains scope and trade-offs
- Public version and changelog are maintained
- Design tokens and centralized copy are used by primary flows

## 1.0.x — Reliability hardening

Goal: protect existing behavior before expanding the product.

### Domain foundations

- Introduce an injectable `Clock` and deterministic `Calendar`
- Replace monetary `Double` values with a `Money` value type backed by `Decimal` or minor units
- Validate project dates, estimates, pricing, payments and session intervals in the domain
- Return typed errors for invalid timer, payment and completion operations
- Remove localized presentation copy from domain result types
- Include payment, delivery and task state in project-completion classification

### Data integrity

- Separate production, preview, demo and test seed configurations
- Distinguish first launch from corrupted or incompatible persisted data
- Stop swallowing persistence failures and expose recoverable errors
- Remove duplicated client and project names from persisted relationships
- Define snapshot/schema versioning and migration behavior

### Test expansion

- Add boundary tests for all profitability classifications
- Cover partial, complete, cancelled and excess payments
- Cover zero values and invalid inputs
- Cover single-active-timer enforcement
- Cover sessions crossing midnight
- Add fixture builders and deterministic clocks

### Exit criteria

- Critical domain behavior contains no direct `Date.now`, `Calendar.current` or floating-point money
- Invalid domain states cannot be created through public APIs
- Persistence errors are visible and do not silently replace user data
- Reliability suites are deterministic across locale and time zone

## 1.1.0 — Architecture and persistence

Goal: establish scalable boundaries while delivering the next product capabilities.

### Architecture

- Define repository protocols in the domain layer
- Introduce focused use cases for create, track, pay and complete workflows
- Add in-memory repository implementations for tests and previews
- Add feature ViewModels isolated to `MainActor`
- Build a composition root for production, preview and test dependencies
- Move destination construction into typed coordinators
- Remove direct concrete-repository access from Views
- Represent screen and form states explicitly

### Persistence

- Implement a SwiftData repository adapter behind existing protocols
- Move file/database operations away from the main actor
- Publish state changes atomically on the main actor
- Add repository contract, migration and corruption-recovery tests

### Product

- Complete scope-request lifecycle
- Improve the activity calendar
- Support editing for clients, projects and work entries

### Exit criteria

- Views render state and forward intents only
- The same repository contract suite passes for in-memory and persistent adapters
- Persistence work does not block the main thread
- Navigation is typed and feature construction is centralized

## 1.2.0 — Localization, accessibility and UI confidence

Goal: make the complete product adaptable and verifiable.

### Localization

- Adopt `Localizable.xcstrings` as the source of localized copy
- Keep `Localizable` as the Swift-facing API; do not introduce an `L10n` namespace
- Localize status, priority, billing and payment labels instead of displaying raw values
- Add Portuguese localization
- Verify currency, number and date formatting across supported locales

### Accessibility

- Audit Dynamic Type, VoiceOver order and minimum touch targets
- Add accessible summaries for metrics and charts
- Verify Reduce Motion and light/dark appearance
- Add stable accessibility identifiers for critical journeys

### UI testing

- Create client and project journey
- Track and stop work journey using a controlled clock
- Record a partial payment journey
- Complete a project and verify its result journey
- Capture screenshots and diagnostics as CI artifacts on failure

### Exit criteria

- Primary flows work in English and Portuguese
- Critical screens pass accessibility review at large content sizes
- Four deterministic UI journeys run in CI

## Continuous engineering tracks

These checks apply to every release rather than a single milestone.

### Memory and performance

- Run Instruments Leaks and Allocations on primary flows
- Add deallocation tests for ViewModels and coordinators with closure ownership
- Ensure inactive tabs do not maintain duplicate timer update loops
- Profile session aggregation as history grows
- Keep synchronous work out of rendering paths

### Code health

- Keep Views and types focused and readable
- Split files by feature responsibility
- Use conventional commits and focused pull requests
- Add ADRs for money, clock, persistence and navigation decisions
- Track technical debt with an owner, rationale and removal condition

### Quality gates

- Build and unit tests on every pull request
- Repository contract tests for persistence changes
- UI smoke tests for release branches
- Clean-clone verification before tagging a release
- No release tag until the corresponding commit is present on `main`

