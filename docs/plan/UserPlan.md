# User & Identity Manifesto — FitView V2 🧭

> The North Star for user architecture: build identity and trust for reliable fit discovery.

---

## Table of Contents

- [Core Philosophy](#core-philosophy)
- [Identity Metrics (Anchor)](#identity-metrics-anchor)
- [Authentication & Security](#authentication--security)
- [Anti-Bot & Trust Verification](#anti-bot--trust-verification)
- [User Life-Cycle (UX Flow)](#user-life-cycle-ux-flow)
- [Technical Requirements](#technical-requirements)
- [V1 → V2: Key Evolutions](#v1--v2-key-evolutions)
- [Code Example: BodyBuild Enum](#code-example-bodybuild-enum)
- [What we remove in V2](#what-we-remove-in-v2)
- [Final Strategy & Next Steps](#final-strategy--next-steps)

---

## Core Philosophy

- **Handle-first identity**: Use a public handle (e.g., `@handle`) as the discoverable identifier while relying on **UUIDs** for internal relationships and data integrity.
- **The Anchor**: Profiles are more than social pages — they anchor body metrics (height, weight, build) that validate every review and power the Body-Double algorithm.
- **Soulful security**: Native, high-performance security (JWT + Keychain) that is unobtrusive but robust (bank-grade practices).

---

## Identity Metrics (Anchor) 👤

To power accurate Body-Double matching, each user should include the following core metrics (immutable-ish):

| Attribute | Type | Purpose |
|---|---|---|
| username | String (unique) | Public handle & deep-linking (fitview.com/@user) |
| heightCm | Int (cm) | Primary Body-Double filter |
| weightKg | Int (kg) | Mass/volume context |
| bodyBuild | Enum-string | Slim, Athletic, Muscular, Average, Curvy, Large |
| region | Enum | Market context for size conversions (AU, US, EU, JP, UK) |

> Note: These fields are intentionally lean — the goal is accurate discovery, not social bio noise.

---

## Authentication & Security 🔒

- **Fuzzy login**: Users can sign in with Email OR Username + Password.
- **Stateless sessions**: JWT issued by Vapor:
  - Access Token: short-lived (15–60 min)
  - Refresh Token: long-lived (30 days)
- **On-device storage**: Store tokens in Keychain only; never in UserDefaults.
- **Password hashing**: Server-side BCrypt with a high cost factor.

---

## Anti-Bot & Trust Verification 🛡️

We use **Progressive Trust** — users can start using the app quickly, but additional privileges require verification.

- **Email verification**: asynchronous sign-up; posting/following disabled until email is verified via a 6-digit code (Shadow Lock).
- **Honeypot**: invisible fields to silently catch bots during sign-up.
- **Rate limiting**: Vapor middleware limits registrations/IP and login attempts.
- **Trust Score**: visible indicators (e.g., subtle checkmark) for users with verified email + consistent, high-quality posts.

---

## User Life-Cycle (UX Flow) 🚦

1. **Onboarding**: minimalist flow asking for `heightCm`, `weightKg`, `bodyBuild`, and `region` — fast and focused.
2. **Post privileges**: new users can browse; posting and social actions are gated until trust checks pass.
3. **Privacy model**: email is private; body metrics are public for discovery (but not personally identifiable beyond measurements).

---

## Technical Requirements ⚙️

- **Backend**: Vapor 4 (Swift) + Fluent + PostgreSQL.
- **Shared Models**: Swift Package with `User` struct and `BodyBuild` enum shared between server and iOS client.
- **Email provider**: SendGrid / AWS SES for verification and transactional emails; templates should be simple and brand-aligned.

---

## V1 → V2: Key Evolutions 🔍

### Body Type: From labels to dimensions
- **V1**: subjective labels (plusSize, petite) — brittle and culturally loaded.
- **V2**: separate numeric `heightCm` and `bodyBuild` for precise matching and less ambiguity.

### Fit Input: From linear to dimensional
- **V1**: single-value fit enums (cognitive friction).
- **V2**: Fit Compass (2D grid) that captures width & length in one interaction.

### Structural Comparison

| Component | V1 (Flutter/Dart) | V2 (Swift/Vapor) | Impact |
|---|---|---|---|
| Height | double (generic) | Int (cm) | Standardized math for Body-Doubles |
| Fit preference | Enum | 2D Fit Compass | More expressive; less friction |
| Identification | email/username | UUID + region | Global awareness for sizing |
| Bio/Name | Free-form | Simplified / removed | Lowers noise; emphasizes proportions |

---

## Code Example: BodyBuild Enum (V2)

```swift
// Swift — no boilerplate, rawValue as display name
public enum BodyBuild: String, Codable, CaseIterable {
    case slim = "Slim"
    case athletic = "Athletic"
    case muscular = "Muscular"
    case average = "Average"
    case large = "Large"
}
```

---

## Model: `User` (shared/Sources/models/User.swift) 🔎

This section documents the `User` model used across the server and iOS client (shared Swift package). The `User` struct is `Codable`, `Identifiable`, and `Equatable` and acts as the "Anchor" for the Body-Double algorithm.

### Overview
- Type: `public struct User: Codable, Identifiable, Equatable`
- Purpose: store identity, anchor metrics (height/weight/body build), region, and profile metadata.
- Shared between backend and frontend to keep validation and presentation consistent.

### Fields

| Field | Type | Notes |
|---|---|---|
| `id` | `UUID` | Global stable identifier (used for relations) |
| `username` | `String` | Public handle (discoverable) |
| `email` | `String` | Private contact, not used for discovery |
| `heightCm` | `Int?` | Height in centimeters (nullable if user skips) |
| `weightKg` | `Int?` | Weight in kilograms (nullable) |
| `bodyBuild` | `BodyBuildType?` | Enum with soulful descriptions (`Slim`, `Athletic`, `Average`, `Muscular`, `Large`) |
| `stylePreference` | `StylePreference?` | Display preference (menswear, womenswear, unisex, fluid) |
| `marketRegion` | `MarketRegion` | Region code (AU, US, UK, EU, JP); drives preferred measurement system |
| `profileImageKey` | `String?` | S3 object key for profile image (store key only — not a full URL) |
| `isVerified` | `Bool` | Trust flag used in feed & privileges |
| `createdAt` | `Date` | Creation timestamp (default: now)

### Supporting enums
- `BodyBuildType` — provides display labels and a `definition` helper for UI copy.
- `MarketRegion` — values: `au`, `us`, `uk`, `eu`, `jp` and a `preferredSystem` helper returning `MeasurementSystem` (`metric` or `imperial`).
- `MeasurementSystem` — `metric` / `imperial` used for UI conversions.
- `StylePreference` — `menswear` / `womenswear` / `unisex` / `fluid`.

### Notes & best practices
- The `profileImageKey` is an S3 object key; clients should construct delivery URLs using the CDN base URL + key (or request signed URLs for private content).
- The struct initializer provides sensible defaults (e.g., `id` defaulting to `UUID()`, `createdAt` defaulting to `Date()`).
- Keep validation consistent in the shared package (e.g., username uniqueness should be enforced server-side; basic format checks can live in shared code).
- Store numeric metrics (`heightCm`, `weightKg`) as integers to simplify Body-Double math and queries.

### Example Postgres migration (users table)

```sql
CREATE TABLE users (
  id UUID PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  email TEXT NOT NULL,
  height_cm INT,
  weight_kg INT,
  body_build TEXT,
  style_preference TEXT,
  market_region TEXT NOT NULL,
  profile_image_key TEXT,
  is_verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

### Example JSON (serialized `User`)

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "username": "@jane",
  "email": "jane@example.com",
  "heightCm": 170,
  "weightKg": 60,
  "bodyBuild": "Athletic",
  "stylePreference": "Unisex",
  "marketRegion": "AU",
  "profileImageKey": "users/550e8400/avatar.jpg",
  "isVerified": false,
  "createdAt": "2025-12-28T00:00:00Z"
}
```

---

## What we remove in V2 ✂️

- **Name & Bio**: removed to reduce social bloat and focus on fit signal.
- **Fixed fit enums**: replaced by the Fit Compass coordinates (x, y).

---

## Final Strategy & Next Steps ✅

- Move from labels to dimensions: capture precise numeric metrics and 2D fit coordinates.
- Implement shared Swift models (`shared/` package) to keep server & clients in sync.
- Add verification flags and trust-scoring to control feed inclusion and user privileges.

If you'd like, I can also:

- Draft the `User` SQL schema (Postgres) and migration file,
- Add API contract examples for authentication and verification flows, or
- Prepare short onboarding UI copy and wireframes.

Which of these would you like me to do next?