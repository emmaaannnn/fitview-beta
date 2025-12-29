import XCTest
@testable import Models

final class FitReviewTests: XCTestCase {
    func testCompassVerdicts() {
        // Test Boxy & Cropped
        let boxyReview = FitReview(
            authorId: UUID(),
            productId: UUID(), // Product ID first
            authorHeightCm: 180,
            authorBodyBuild: .athletic,
            sizeValue: "L",
            sizeCategory: .menswear,
            sizeRegion: .us, 
            widthFit: 0.8,   // Baggy
            lengthFit: -0.6, // Short
            fitIntent: .intended,
            imageKeys: ["img1"]
        )
        
        XCTAssertEqual(boxyReview.compassVerdict, "Boxy & Cropped")
        
        // Test True to Size
        let ttsReview = FitReview(
            authorId: UUID(),
            productId: UUID(),
            authorHeightCm: 180,
            authorBodyBuild: .athletic,
            sizeValue: "M",
            sizeCategory: .menswear,
            sizeRegion: .us,   // <--- ADD THIS
            widthFit: 0.0,
            lengthFit: 0.0,
            fitIntent: .intended,
            imageKeys: ["img1"]
        )
        
        XCTAssertEqual(ttsReview.widthDescription, "True to Size")
    }
}