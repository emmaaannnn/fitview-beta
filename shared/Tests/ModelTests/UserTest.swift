import XCTest
@testable import Models

final class UserTests: XCTestCase {
    func testUserInitialization() {
        let user = User(username: "emman", email: "test@fitview.io", marketRegion: .us)
        
        XCTAssertEqual(user.username, "emman")
        XCTAssertNil(user.heightCm) // Verify gradual onboarding starts nil
        XCTAssertEqual(user.marketRegion.preferredSystem, .imperial)
    }

    func testHeightDisplay() {
        // Test imperial conversion (5'10" is roughly 179.8cm, so we'll test 180cm for 5'11")
        let usUser = User(username: "us_user", email: "test@fitview.io", heightCm: 180, marketRegion: .us)
        XCTAssertEqual(usUser.heightDisplay, "5'10\"")

        // Test metric display
        let euUser = User(username: "eu_user", email: "test@fitview.io", heightCm: 180, marketRegion: .eu)
        XCTAssertEqual(euUser.heightDisplay, "180cm")
        
        // Test nil height
        let nilHeightUser = User(username: "nil_height", email: "test@fitview.io", marketRegion: .us)
        XCTAssertEqual(nilHeightUser.heightDisplay, "---")
    }
}