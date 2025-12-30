import XCTest
@testable import Models

final class ReviewTests: XCTestCase {
    
    // Helper to create a review with defaults
    private func makeReview(widthFit: Double, lengthFit: Double) -> FitReview {
        return FitReview(
            authorId: UUID(),
            productId: UUID(),
            authorHeightCm: 180,
            authorBodyBuild: .athletic,
            sizeValue: "M",
            genderCategory: .mens,
            sizeRegion: .us,
            widthFit: widthFit,
            lengthFit: lengthFit,
            fitIntent: .intended,
            imageKeys: []
        )
    }
    
    func testWidthDescription() {
        XCTAssertEqual(makeReview(widthFit: -0.8, lengthFit: 0).widthDescription, "Very Tight")
        XCTAssertEqual(makeReview(widthFit: -0.5, lengthFit: 0).widthDescription, "Slim")
        XCTAssertEqual(makeReview(widthFit: 0.0, lengthFit: 0).widthDescription, "True to Size")
        XCTAssertEqual(makeReview(widthFit: 0.5, lengthFit: 0).widthDescription, "Relaxed")
        XCTAssertEqual(makeReview(widthFit: 0.8, lengthFit: 0).widthDescription, "Oversized / Baggy")
    }
    
    func testLengthDescription() {
        XCTAssertEqual(makeReview(widthFit: 0, lengthFit: -0.8).lengthDescription, "Very Cropped")
        XCTAssertEqual(makeReview(widthFit: 0, lengthFit: -0.5).lengthDescription, "Short")
        XCTAssertEqual(makeReview(widthFit: 0, lengthFit: 0.0).lengthDescription, "Standard Length")
        XCTAssertEqual(makeReview(widthFit: 0, lengthFit: 0.5).lengthDescription, "Long")
        XCTAssertEqual(makeReview(widthFit: 0, lengthFit: 0.8).lengthDescription, "Extra Long / Tall")
    }
    
    func testCompassVerdicts() {
        // Test Boxy & Cropped
        let boxyCropped = makeReview(widthFit: 0.4, lengthFit: -0.4)
        XCTAssertEqual(boxyCropped.compassVerdict, "Boxy & Cropped")

        // Test Super Oversized
        let superOversized = makeReview(widthFit: 0.6, lengthFit: 0.6)
        XCTAssertEqual(superOversized.compassVerdict, "Super Oversized")
        
        // Test Small & Short
        let smallShort = makeReview(widthFit: -0.4, lengthFit: -0.4)
        XCTAssertEqual(smallShort.compassVerdict, "Small & Short")

        // Test regular combo
        let regular = makeReview(widthFit: 0.0, lengthFit: 0.0)
        XCTAssertEqual(regular.compassVerdict, "True to Size / Standard Length")
        
        let slimLong = makeReview(widthFit: -0.5, lengthFit: 0.5)
        XCTAssertEqual(slimLong.compassVerdict, "Slim / Long")
    }
}