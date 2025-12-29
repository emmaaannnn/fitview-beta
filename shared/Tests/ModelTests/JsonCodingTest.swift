import XCTest
@testable import Models

final class JsonCodingTests: XCTestCase {
    func testProductDecoding() throws {
        let json = """
        {
            "id": "550e8400-e29b-41d4-a716-446655440000",
            "brandName": "Nike",
            "name": "Tech Fleece",
            "originalURL": "https://nike.com/tech",
            "createdAt": "2023-10-27T10:00:00Z"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let product = try decoder.decode(Product.self, from: json)
        XCTAssertEqual(product.brandName, "Nike")
    }
}