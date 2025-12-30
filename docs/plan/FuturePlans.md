# FitView V2 — Future Roadmap & Design Notes 🚀

---

## 1. Quality Assessment Strategy 🔍

**Current MVP status:** Manual (description-based)

To maintain **low friction** at launch, the app will not include dedicated quality sliders, material tags, or rating scales. Instead we will rely on natural user language in product descriptions to capture perceived quality.

**How it works (MVP):**
- Users will use the 4th line of the Product Footer (Description) to provide subjective feedback about fabric weight, texture, and durability.
- We will observe the phrases and adjectives users choose to describe quality to inform later UX decisions.

**Goal:** Use observed language to design a scalable Quality UI (e.g., *Premium Slider* or *Quality Toggle*) for a future release.

### Future release: The “Hand-Feel” instrument ✋
- **Tactile Slider:** A haptic-enabled control that lets users rate material density (e.g., *Sheer → Heavyweight*).
- **Community consensus:** Aggregate quality scores for a physical SKU once a threshold of reviews is reached to create trustworthy, crowdsourced quality metadata.

---

## 2. The "Body Double" Commerce Layer (Future Feature) 🧍‍♀️🧍‍♂️

This layer leverages the Global Trust Layer to reduce friction in second‑hand shopping (Depop/eBay/Grailed) by connecting buyers to reviewers whose bodies closely match theirs.

### A. The “Mis-Fit” marketplace
- **Problem:** Reviews often show a "Disappointed" fit intent when an item is too small/large for the reviewer’s build.
- **Solution:** Add a **"Buy from Reviewer"** button on posts where the fit failed — enabling sellers to list items directly from their review posts.
- **Logic:** If a user who is 185 cm reports a shirt as too short, the app can notify Body Doubles around 175 cm who are more likely to have a successful fit.

### B. “Pre‑Loved” trust and discovery
- **Automatic matching:** Add a **Marketplace** toggle in product search to surface listings from a user’s high-percentage Body Doubles for that exact SKU.
- **Zero guesswork:** Since sellers have posted Fit-Reviews with measured metrics, buyers gain high confidence about how an item will drape before purchasing.

---

*Notes / next steps:*
- Monitor language patterns in product descriptions and early reviews to draft the initial Quality taxonomy.
- Prototype the Hand-Feel slider and a simple marketplace flow for user testing.

---

