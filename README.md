# HourWorth

> Track your time. Understand your real worth.

HourWorth is a local-first iOS app for freelancers to manage projects, track work and understand what each engagement was really worth.

Current version: **1.0.0**

## Product

The app connects delivery, time and payment. A freelancer can create clients and projects, run a reliable timestamp-based timer, add manual entries, record payments and finish with an honest comparison between estimated effort, actual effort and effective hourly rate.

## Highlights

- Fixed-price and hourly project calculations
- One active timer, derived from persisted timestamps
- Manual work entries and activity history
- Tasks, partial payments and pending-value tracking
- Contextual project completion result
- Local persistence with no account, backend or bank connection
- Dynamic Type, semantic status labels and native iOS navigation

## Architecture

```text
SwiftUI views → feature state/actions → repository → local store
                        ↓
                  domain rules
```

Views render state and forward actions. Domain models own deterministic value and completion calculations. `AppRepository` owns mutations and persistence, keeping storage concerns out of feature views.

## Run

```bash
brew install xcodegen
xcodegen generate
open HourWorth.xcodeproj
```

Requires Xcode 16+ and iOS 18+.

## Test

```bash
xcodebuild test -scheme HourWorth -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

Tests cover fixed-price and hourly calculations, partial payments and completion classification.

## Decisions and trade-offs

- Local-first keeps personal client and payment records on device and removes account setup.
- Timestamps, rather than an in-memory counter, are the timer source of truth.
- Persistence stays behind one repository boundary; the initial store uses a small atomic Codable snapshot.
- The app deliberately excludes invoicing, banking integrations, authentication, CRM automation and external calendar sync.

## Versioning

HourWorth follows Semantic Versioning. The public app version is defined by `MARKETING_VERSION`; the internal build number uses `CURRENT_PROJECT_VERSION`. Release notes are maintained in [CHANGELOG.md](CHANGELOG.md).

## Roadmap

Product delivery and technical evolution are maintained together in [ROADMAP.md](ROADMAP.md). Upcoming work includes domain hardening, deterministic time and money handling, repository boundaries, SwiftData migration, UI journeys and Portuguese localization.

## License

MIT
