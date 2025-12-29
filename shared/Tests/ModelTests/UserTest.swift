import XCTest
@testable import Models

final class UserTests: XCTestCase {
    func testUserInitialization() {
        let user = User(username: "emman", email: "test@fitview.io", marketRegion: .us)
        
        XCTAssertEqual(user.username, "emman")
        XCTAssertNil(user.heightCm) // Verify gradual onboarding starts nil
        XCTAssertEqual(user.marketRegion.preferredSystem, .imperial)
    }
}