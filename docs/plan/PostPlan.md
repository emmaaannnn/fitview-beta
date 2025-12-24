# Post Model Plan — FitView V2 📝

> Clear, structured, and visual-first posts for reliable fit discovery.

---

## 1 — Overview

Every post is composed of three pillars: **Who (Anchor)**, **What (Snapshot)**, and **How (Truth)**. This structure keeps data consistent, searchable, and suitable for matching "body-doubles".

---

## 2 — Pillars

### Pillar I — The Anchor (User) 👤

Injected from the user's profile to minimize friction.

- **userId** — UUID (permanent reference to the creator)
- **heightCm** — Integer (cm) — primary filter for Body Doubles
- **weightKg** — Integer (kg)
- **bodyBuild** — Enum-like string (Slim | Athletic | Muscular | Average | Large)

---

### Pillar II — The Snapshot (Product) 🏷️

Pulled from the retail link via a URL scraper to capture canonical metadata.

- **sourceUrl** — String (original retail link)
- **sku** — String (SKU / MPN & canonical identifier)
- **brand** — Normalized string (e.g., "Nike")
- **itemName** — Normalized product title
- **studioImageUrl** — String (retailer product image snapshot)
- **category** — String (Bottoms | Outerwear | Footwear | etc.)
- **region** — String (AU | US | EU | JP | UK) — context for size conversion

---

### Pillar III — The Truth (Review) 📸

This is the user-controlled, observational data that provides the true fit context.

- **heroImageUrl** — High-resolution user photo (mandatory)
- **sizeWorn** — String (the label on the garment: "M", "34", "L/XL")
- **fitCompass** — Object `{ width: -1..1, length: -1..1 }` where -1 = Tight/Cropped, 0 = True, 1 = Baggy/Long
- **materialTags** — { weight: Light|Mid|Heavy, feel: Stiff|Soft|Fluid }
- **notes** — Optional short text (deprioritized)


```json
// Example (simplified)
{
  "userId": "uuid-123",
  "heightCm": 178,
  "weightKg": 72,
  "bodyBuild": "Athletic",
  "region": "AU",
  "sourceUrl": "https://...",
  "sku": "ABC-123",
  "brand": "Acme",
  "heroImageUrl": "https://.../photo.jpg",
  "sizeWorn": "M",
  "fitCompass": { "width": 0.2, "length": -0.4 },
  "materialTags": { "weight": "Mid", "feel": "Soft" }
}
```

---

## 3 — Data Flow (Logic Summary) 🔁

1. **Input** — User pastes a `sourceUrl` and uploads one high-res photo.
2. **Enrichment** — Server scrapes title, `sku`, `brand`, and `studioImageUrl`.
3. **Refinement** — User selects the `fitCompass` position and 1–2 `materialTags`.
4. **Verification** — Post is timestamped and saved as a `VerifiedSpec` when `sku` is resolved; otherwise flagged `Unverified`.

---

## 4 — High-Fidelity Requirements ⚙️

- **Image quality**: Enforce high-res uploads (iOS: PHPicker original). Low-res images are rejected.
- **Metadata integrity**: If scraper fails to resolve `sku`, mark post `Unverified` and exclude from high-trust feeds.
- **International conversion**: Backend service converts sizes across `region` contexts (e.g., “US M” → “AU L”) for consistent discovery.

---

## 5 — Summary Table

| Component | Input Method | Requirement |
|---|---|---:|
| User Stats | Profile auto-fill | **Mandatory** |
| Product Data | URL scraper | **Mandatory (V2)** |
| User Photo | Camera / Gallery | **Mandatory (High-res)** |
| Fit Compass | Single-tap 2D grid | **Mandatory** |
| Material Tags | 2-tap selection | Optional (recommended) |
| Comments | Text field | Optional (secondary)

---

## 6 — V1 vs V2 (Design Rationale) 🔍

### 6.1 Data Structure: Loose vs Snapshotted
- **V1**: Hard enums (size lists) → brittle when retailers use non-standard labels.
- **V2**: Snapshot approach (strings + region mapping) → accepts real-world labels and maps them to a regional context.

### 6.2 Fit Input: Linear vs Dimensional
- **V1**: Single-value dropdown (cognitive friction).
- **V2**: Fit Compass (2D grid) captures width & length simultaneously in one tap.

### 6.3 Summary Comparison

| Feature | V1 (Flutter/Firebase) | V2 (Swift/Vapor) | Rationale |
|---|---|---|---|
| Sizing | Hardcoded enums | Dynamic `sizeLabel` + `region` | Handles global sizing variance
| Input | Manual dropdowns | URL scraping + predictive tray | Faster, fewer taps (~60s → ~15s)
| Fit data | Linear enum | 2D Fit Compass | Richer expression (e.g., "Boxy+Cropped")
| Identity | username | user anchor (UUID + metrics) | Enables accurate Body-Double matching
| Storage | Firestore maps | PostgreSQL relational | Better for complex queries/filters

---

## 7 — Code & Architecture Notes 🧩

- **Deprioritize free-form description**: let photos + structured data convey the signal.
- **Shared Swift Package**: single source of truth for models (keeps server & app in sync).
- **Verification flags**: `VerifiedSpec` vs `Unverified` guides feed inclusion logic.

---

## 8 — Verdict

V1 validated demand and UX direction. V2 professionalizes the product by converting manual inputs into structured, verified, and discoverable posts — shifting from "form-filling" to "moment-capturing." ✅

---

If you'd like, I can also:

- Add example SQL table schemas (Post & PostMeta)
- Create a companion ER diagram for the `shared/` package
- Add UI mockups for the Fit Compass flow

Which would you like next?