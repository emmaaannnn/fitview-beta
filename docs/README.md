# FitView — The Architecture of Fit ✨

> High fidelity. Low friction. Digital craft. Analogue soul.

FitView is a visual-first platform bridging digital discovery and physical reality. We combine body-metric data with cinematic fit reviews to create a trust layer for the fashion industry.

---

## Table of Contents

- [Overview](#overview)
- [Why FitView](#why-fitview)
- [Tech Snapshot](#tech-snapshot)
- [Quick start](#quick-start)
- [Project layout](#project-layout)
- [Key features](#key-features)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License & Contact](#license--contact)

---

## Overview

FitView is evolving from a rapid MVP (V1) into a native, performance-focused V2. Where V1 proved the concept (Flutter + Firebase), V2 adopts a unified Swift stack that prioritizes **type-safety**, **native UX**, and **high-fidelity visual reviews**.

## Why FitView 💡

- Reduce friction in online apparel discovery by standardizing how people document fit.
- Replace subjective text-only notes with structured, visual-first fit data.
- Help users find their "body-double" — others with similar metrics and fits.

---

## Tech Snapshot 🔧

| Area | Version 1 | Version 2 |
|---|---:|---|
| Frontend | Flutter | **Native SwiftUI**
| Backend | Firebase | **Swift (Vapor) API**
| Database | Firestore (NoSQL) | **PostgreSQL (Relational)**
| Language | Dart | **Swift (Unified Stack)**
| UX | Standard MVP | **High-Fidelity / Cinematic**

---

## Quick start ▶️

> These are high-level steps to get FitView running locally.

### Backend (recommended: Docker)

1. Open a terminal and run:

```bash
cd backend
docker-compose up --build
```

This boots the Vapor API using the project's `Dockerfile` / `docker-compose.yml`.

> To run natively (macOS): open `backend/` in Xcode or run `swift run` inside the backend directory.

### iOS App

1. Open the Xcode project: `open ios/FitView-IOS/FitView-IOS.xcodeproj`
2. Select a simulator or device, then build & run.

### Android

- The Android/Flutter codebase exists for historical reference; V1 is being deprecated in favor of the native Swift approach.
- Kotlin app will be made in future stages of development.

---

## Project layout 🗂️

```
fitview-V2/
├── ios/              # Native SwiftUI app
├── android/          # Native Kotlin app (Will be made in the next stage of development)
├── backend/          # Vapor (Swift) server + Docker files
├── shared/           # Shared Swift package (models & logic)
├── design/           # Design assets & brand
└── docs/             # Documentation & technical specs
```

---

## Key features ✨

- **Visual-first Fit Reviews** — Photos + structured body metrics per review
- **Unified Swift Logic** — Shared models/DTOs between backend & frontend
- **Relational Fit Schema** — Queryable structure to find matching body-doubles
- **Soulful UX** — Film-inspired visual language for reviews and feeds

---

## Roadmap 🛠️

- Stable V2 API and schema (current priority)
- Expand filters to match body-doubles by shape/measurements
- Improved UIs for review composition and discovery
- Analytics & anonymized fit patterns to inform sizing standards

---

## Contributing 🤝

- Issues & PRs: please open issues for bugs or feature requests, and submit PRs against a feature branch.
- Style: prefer small, focused PRs with descriptive commit messages.
- Tests: add unit tests to `shared/` where applicable (`swift test`).


---

Thanks for checking out FitView — we're building the future of fit discovery, one review at a time. ✅