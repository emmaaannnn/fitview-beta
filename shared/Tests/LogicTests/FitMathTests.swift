import XCTest
@testable import Logic
@testable import Models

final class FitMathTests: XCTestCase {

    func testRegionalSizeWarning() {
        // US user, Asia review
        XCTAssertNotNil(FitMath.regionalSizeWarning(userRegion: .us, reviewRegion: .jp))
        XCTAssertNotNil(FitMath.regionalSizeWarning(userRegion: .us, reviewRegion: .kr))
        
        // Asia user, US review
        XCTAssertNotNil(FitMath.regionalSizeWarning(userRegion: .jp, reviewRegion: .us))
        
        // No warning cases
        XCTAssertNil(FitMath.regionalSizeWarning(userRegion: .us, reviewRegion: .au))
        XCTAssertNil(FitMath.regionalSizeWarning(userRegion: .us, reviewRegion: .uk))
        XCTAssertNil(FitMath.regionalSizeWarning(userRegion: .jp, reviewRegion: .kr))
    }

    func testRegionalVolumeScale() {
        // Asia to US
        XCTAssertEqual(FitMath.regionalVolumeScale(from: .jp, to: .us), 0.8)
        XCTAssertEqual(FitMath.regionalVolumeScale(from: .kr, to: .us), 0.8)
        
        // US to Asia
        XCTAssertEqual(FitMath.regionalVolumeScale(from: .us, to: .jp), 1.2)
        
        // Western to US
        XCTAssertEqual(FitMath.regionalVolumeScale(from: .au, to: .us), 0.95)
        XCTAssertEqual(FitMath.regionalVolumeScale(from: .uk, to: .us), 0.95)
        
        // No change
        XCTAssertEqual(FitMath.regionalVolumeScale(from: .us, to: .us), 1.0)
        XCTAssertEqual(FitMath.regionalVolumeScale(from: .jp, to: .kr), 1.0)
    }
}
