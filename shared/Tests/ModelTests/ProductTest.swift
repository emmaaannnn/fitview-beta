import XCTest
@testable import Models

final class ProductTests: XCTestCase {
    func testProductInitialization() {
        let url = URL(string: "https://example.com")!
        let product = Product(
            brandName: "ExampleBrand",
            name: "ExampleProduct",
            sku: "12345",
            genderCategory: .mens,
            originRegion: .us,
            originalURL: url
        )

        XCTAssertEqual(product.brandName, "ExampleBrand")
        XCTAssertEqual(product.name, "ExampleProduct")
        XCTAssertEqual(product.sku, "12345")
        XCTAssertEqual(product.genderCategory, .mens)
        XCTAssertEqual(product.originRegion, .us)
        XCTAssertEqual(product.originalURL, url)
    }
}
