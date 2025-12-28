# Storage Plan — RDS, S3 & CDN

**Purpose:** Migrate from Firebase (Firestore + Storage) to a decoupled, production-ready stack: PostgreSQL (Aurora Serverless v2 on RDS) for relational queries and AWS S3 + CloudFront for binary assets.

---

## 1. Database: AWS RDS (Aurora Serverless v2)

Why PostgreSQL (RDS):
- Relational model allows accurate, fast "body-double" math and joins for discovery filters.
- Aurora Serverless v2 scales compute to demand and reduces idle costs.
- Keep DB inside a VPC and restrict access to the Vapor backend only.

Key details:
- Instance: Aurora Serverless v2
- Networking: Private VPC, no public access
- Auth: Prefer IAM-based authentication where possible, rotate secrets when not using IAM
- Backups/HA: Use automated snapshots and multi-AZ for resilience

---

## 2. Binary Assets: AWS S3 + CloudFront

Storage philosophy:
- Store bytes in S3; keep only references (object keys) in Postgres.
- Use CloudFront for global low-latency delivery and to apply format/size transforms if needed.
- Enable versioning and lifecycle rules for cost control.

Recommended bucket layout:

```text
fitview-assets/
├── users/
│   └── [user_uuid]/
│       └── avatar.jpg           # compressed profile image
├── reviews/
│   └── [post_uuid]/
│       ├── hero_high.heic       # original upload
│       ├── hero_webp.webp       # derived serving asset
│       └── hero_thumb.jpg
└── products/
    └── [product_uuid]/ref.jpg
```

Notes:
- Keep originals and generate derived assets (WebP, thumbnails) asynchronously.
- Use prefixes and consistent naming to make lifecycle and permission policies simple.

---

## 3. Vapor: connection & configuration

Vapor will be the gatekeeper for DB access and will issue presigned S3 URLs for direct uploads. Use FluentPostgresDriver for DB access and a supported AWS SDK (Soto/AWS SDK for Swift) for S3 interactions.

Example `configure.swift` (trimmed):

```swift
import Fluent
import FluentPostgresDriver
import Vapor

public func configure(_ app: Application) throws {
  // AWS client (Soto or AWS SDK)
  app.aws.client = AWSClient(httpClientProvider: .createNew)

  // Postgres configuration (RDS)
  let config = PostgresConfiguration(
    hostname: Environment.get("DATABASE_HOST") ?? "",
    port: 5432,
    username: Environment.get("DATABASE_USERNAME") ?? "vapor_user",
    password: Environment.get("DATABASE_PASSWORD") ?? "",
    database: Environment.get("DATABASE_NAME") ?? "fitview_db",
    tlsConfiguration: .makeClientConfiguration()
  )
  app.databases.use(.postgres(configuration: config), as: .psql)

  // Register migrations
  app.migrations.add(CreateUser())
  app.migrations.add(CreateFitReview())
}
```

Best practices:
- Validate upload metadata (content-type, size) before issuing presigned URLs.
- Use short TTLs for presigned URLs and strict key scoping.
- Verify object after upload (size/checksum) before marking a review as public.

---

## 4. Pointer logic (store keys, not URLs)

Store S3 object keys in Postgres and generate CDN URLs at the edge or in the app.

Example `images` table:

```sql
CREATE TABLE images (
  id UUID PRIMARY KEY,
  post_id UUID REFERENCES posts(id),
  image_key TEXT NOT NULL,
  mime_type TEXT,
  width INT,
  height INT,
  size_bytes BIGINT,
  metadata JSONB,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

Example Swift computed property:

```swift
extension FitReview {
  var publicImageURL: URL? {
    guard let key = self.imageKey.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { return nil }
    return URL(string: "https://cdn.fitview.com/\(key)")
  }
}
```

Rationale:
- Keeping keys decouples the app from CDN/provider changes.
- Metadata (dimensions, size) enables smart delivery and validation.

---

## 5. Scalability, durability & cost controls

- S3 durability: 11 nines; suitable for petabytes of imagery.
- Use S3 Versioning and lifecycle policies (Intelligent-Tiering / Glacier) to control costs.
- Use multipart uploads for large files to improve reliability.
- Monitor storage and request metrics (CloudWatch); set budget alerts for spike detection.

---

## 6. Security & compliance

- Use least-privilege IAM roles for any service interacting with S3 or RDS.
- Enforce encryption at rest (SSE) and TLS in transit.
- Consider malware scanning, PII checks, and retention policies for compliance (GDPR/CCPA).

---

## 7. Action items (next steps)

- [ ] Create `fitview-assets` S3 bucket with versioning and proper policies.
- [ ] Configure CloudFront distribution and TLS certificate.
- [ ] Implement presigned upload endpoints in Vapor with strict validation.
- [ ] Add async image processing worker (Vapor worker, Lambda, or container job).
- [ ] Add DB migrations for `images` and related metadata.
- [ ] Add monitoring dashboards and budget alerts.

---

If you'd like, I can add a sample Vapor presigned-upload handler, a Terraform snippet for S3 + CloudFront, or a small diagram illustrating the flow — which would you prefer next?