import XCTest
@testable import Models

final class JsonCodingTests: XCTestCase {
    func testProductCoding() throws {
        let url = URL(string: "https://nike.com/tech")!
        let uuid = UUID()
        // Dates need to be precisely controlled for accurate comparison after serialization/deserialization.
        var components = DateComponents()
        components.year = 2023
        components.month = 10
        components.day = 27
        components.hour = 10
        components.minute = 0
        components.second = 0
        components.timeZone = TimeZone(secondsFromGMT: 0)
        let date = Calendar.current.date(from: components)!

        let product = Product(
            id: uuid,
            brandName: "Nike",
            name: "Tech Fleece",
            sku: "CU4495-010",
            genderCategory: .mens,
            originRegion: .us,
            originalURL: url,
            createdAt: date
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .sortedKeys // Ensure consistent JSON output for comparison
        
        let data = try encoder.encode(product)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedProduct = try decoder.decode(Product.self, from: data)
        
        XCTAssertEqual(product, decodedProduct)
    }

    func testRegionCoding() throws {
        let region = MarketRegion.us

        let encoder = JSONEncoder()
        let data = try encoder.encode(region)

        let decoder = JSONDecoder()
        let decodedRegion = try decoder.decode(MarketRegion.self, from: data)

        XCTAssertEqual(region, decodedRegion)
        
        // Test raw value
        let stringValue = String(data: data, encoding: .utf8)
        XCTAssertEqual(stringValue, "\"US\"")
    }

    func testUserCoding() throws {
        var components = DateComponents()
        components.year = 2023
        components.month = 10
        components.day = 27
        components.hour = 10
        components.minute = 0
        components.second = 0
        components.timeZone = TimeZone(secondsFromGMT: 0)
        let date = Calendar.current.date(from: components)!

        let user = User(
            id: UUID(),
            username: "emman",
            email: "test@fitview.io",
            heightCm: 180,
            weightKg: 80,
            bodyBuild: .athletic,
            stylePreference: .menswear,
            marketRegion: .us,
            profileImageKey: "image.jpg",
            isVerified: true,
            createdAt: date
        )

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .sortedKeys

        let data = try encoder.encode(user)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let decodedUser = try decoder.decode(User.self, from: data)

        XCTAssertEqual(user, decodedUser)
    }

    func testFitReviewCoding() throws {
        var components = DateComponents()
        components.year = 2023
        components.month = 10
        components.day = 27
        components.hour = 10
        components.minute = 0
        components.second = 0
        components.timeZone = TimeZone(secondsFromGMT: 0)
        let date = Calendar.current.date(from: components)!

        let review = FitReview(
            id: UUID(),
            authorId: UUID(),
            productId: UUID(),
            authorHeightCm: 180,
            authorBodyBuild: .athletic,
            sizeValue: "L",
            genderCategory: .mens,
            sizeRegion: .us,
            widthFit: 0.8,
            lengthFit: -0.6,
            fitIntent: .intended,
            imageKeys: ["img1"],
            createdAt: date
        )

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .sortedKeys

        let data = try encoder.encode(review)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let decodedReview = try decoder.decode(FitReview.self, from: data)

        XCTAssertEqual(review, decodedReview)
    }
}