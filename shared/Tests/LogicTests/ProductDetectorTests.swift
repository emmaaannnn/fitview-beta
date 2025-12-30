import XCTest
@testable import Logic
@testable import Models

final class ProductDetectorTests: XCTestCase {

    func testDetectGender() {
        let urlMen = URL(string: "https://example.com/products/men/shirt")!
        let urlWomen = URL(string: "https://example.com/products/womens/dress")!
        let urlUnisex = URL(string: "https://example.com/products/unisex/hat")!
        let urlNone = URL(string: "https://example.com/products/item")!

        // Test URL path detection
        XCTAssertEqual(ProductDetector.detectGender(from: urlMen, bodyText: "", breadcrumbs: ""), .mens)
        XCTAssertEqual(ProductDetector.detectGender(from: urlWomen, bodyText: "", breadcrumbs: ""), .womens)
        XCTAssertEqual(ProductDetector.detectGender(from: urlUnisex, bodyText: "", breadcrumbs: ""), .unisex)

        // Test breadcrumbs detection
        XCTAssertEqual(ProductDetector.detectGender(from: urlNone, bodyText: "", breadcrumbs: "Home > Men > Shirts"), .mens)
        XCTAssertEqual(ProductDetector.detectGender(from: urlNone, bodyText: "", breadcrumbs: "Home > Women > Dresses"), .womens)

        // Test body text detection
        XCTAssertEqual(ProductDetector.detectGender(from: urlNone, bodyText: "A great menswear shirt", breadcrumbs: ""), .mens)
        XCTAssertEqual(ProductDetector.detectGender(from: urlNone, bodyText: "A great womenswear dress", breadcrumbs: ""), .womens)
        XCTAssertEqual(ProductDetector.detectGender(from: urlNone, bodyText: "A great unisex hat", breadcrumbs: ""), .unisex)

        // Test fallback to unknown
        XCTAssertEqual(ProductDetector.detectGender(from: urlNone, bodyText: "A great item", breadcrumbs: "Home > All"), .unknown)
    }
}
