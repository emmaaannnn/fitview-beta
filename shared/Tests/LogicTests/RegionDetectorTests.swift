import XCTest
@testable import Logic
@testable import Models

final class RegionDetectorTests: XCTestCase {

    func testDetectRegion() {
        let urlJP_host = URL(string: "https://www.uniqlo.jp/jp/ja/")!
        let urlJP_path = URL(string: "https://www.example.com/jp/products")!
        let urlKR_host = URL(string: "https://www.musinsa.com/kr/")!
        let urlKR_path = URL(string: "https://www.example.com/ko_kr/products")!
        let urlAU_host = URL(string: "https://www.iconic.com.au/")!
        let urlAU_path = URL(string: "https://www.example.com/au/products")!
        let urlUK_host = URL(string: "https://www.asos.co.uk/")!
        let urlUK_path = URL(string: "https://www.example.com/en_gb/products")!
        let urlUS = URL(string: "https://www.nike.com/us")!

        XCTAssertEqual(RegionDetector.detect(from: urlJP_host), .jp)
        XCTAssertEqual(RegionDetector.detect(from: urlJP_path), .jp)
        XCTAssertEqual(RegionDetector.detect(from: urlKR_host), .kr)
        XCTAssertEqual(RegionDetector.detect(from: urlKR_path), .kr)
        XCTAssertEqual(RegionDetector.detect(from: urlAU_host), .au)
        XCTAssertEqual(RegionDetector.detect(from: urlAU_path), .au)
        XCTAssertEqual(RegionDetector.detect(from: urlUK_host), .uk)
        XCTAssertEqual(RegionDetector.detect(from: urlUK_path), .uk)
        
        // Default to US
        XCTAssertEqual(RegionDetector.detect(from: urlUS), .us)
    }

    func testRegionalSizeWarning() {
        // This is duplicated from FitMath, but we test it here to ensure RegionDetector is consistent
        // US user, Asia review
        XCTAssertNotNil(RegionDetector.regionalSizeWarning(userRegion: .us, reviewRegion: .jp))
        
        // Asia user, US review
        XCTAssertNotNil(RegionDetector.regionalSizeWarning(userRegion: .jp, reviewRegion: .us))
        
        // No warning
        XCTAssertNil(RegionDetector.regionalSizeWarning(userRegion: .us, reviewRegion: .au))
    }

    func testRegionalVolumeScale() {
        // This is duplicated from FitMath, but we test it here to ensure RegionDetector is consistent
        // Asia to US
        XCTAssertEqual(RegionDetector.regionalVolumeScale(from: .jp, to: .us), 0.8)
        
        // US to Asia
        XCTAssertEqual(RegionDetector.regionalVolumeScale(from: .us, to: .jp), 1.2)
        
        // Western to US
        XCTAssertEqual(RegionDetector.regionalVolumeScale(from: .au, to: .us), 0.95)
        
        // No change
        XCTAssertEqual(RegionDetector.regionalVolumeScale(from: .us, to: .us), 1.0)
    }
}
