import XCTest
@testable import Models
@testable import Logic

final class BodyMathTests: XCTestCase {

    // MARK: - Test Users
    
    let userA = User(
        id: UUID(),
        username: "userA",
        email: "a@test.com",
        heightCm: 180,
        weightKg: 75,
        bodyBuild: .athletic,
        marketRegion: .us
    )
    
    // Identical to userA
    let userTwin = User(
        id: UUID(),
        username: "userTwin",
        email: "twin@test.com",
        heightCm: 180,
        weightKg: 75,
        bodyBuild: .athletic,
        marketRegion: .au
    )
    
    // Similar to userA
    let userSimilar = User(
        id: UUID(),
        username: "userSimilar",
        email: "similar@test.com",
        heightCm: 178, // -2cm
        weightKg: 78, // +3kg
        bodyBuild: .average, // Adjacent
        marketRegion: .au
    )

    // Comparable to userA
    let userComparable = User(
        id: UUID(),
        username: "userComparable",
        email: "comparable@test.com",
        heightCm: 185, // +5cm
        weightKg: 85, // +10kg
        bodyBuild: .muscular, // Adjacent
        marketRegion: .us
    )
    
    // Different from userA
    let userDifferent = User(
        id: UUID(),
        username: "userDifferent",
        email: "different@test.com",
        heightCm: 160, // -20cm
        weightKg: 95, // +20kg
        bodyBuild: .large,
        marketRegion: .eu    
    )
    
    // Missing vital info
    let userIncomplete = User(
        id: UUID(),
        username: "userIncomplete",
        email: "incomplete@test.com",
        heightCm: nil,
        weightKg: 75,
        bodyBuild: .average,
        marketRegion: .au
    )

    // MARK: - Test Cases for `compare`

    func testCompare_WhenUsersAreIdentical_ReturnsTwin() {
        let comparison = BodyMath.compare(userA, to: userTwin)
        XCTAssertNotNil(comparison)
        XCTAssertEqual(comparison?.tier, .twin)
        XCTAssert(comparison!.percentage >= 90)
    }
    
    func testCompare_WhenUsersAreSimilar_ReturnsSimilar() {
        let comparison = BodyMath.compare(userA, to: userSimilar)
        XCTAssertNotNil(comparison)
        XCTAssertEqual(comparison?.tier, .similar)
        XCTAssert(comparison!.percentage >= 70 && comparison!.percentage < 90)
    }

    func testCompare_WhenUsersAreComparable_ReturnsComparable() {
        let comparison = BodyMath.compare(userA, to: userComparable)
        XCTAssertNotNil(comparison)
        XCTAssertEqual(comparison?.tier, .comparable)
        XCTAssert(comparison!.percentage >= 50 && comparison!.percentage < 70)
    }

    func testCompare_WhenUsersAreDifferent_ReturnsDifferent() {
        let comparison = BodyMath.compare(userA, to: userDifferent)
        XCTAssertNotNil(comparison)
        XCTAssertEqual(comparison?.tier, .different)
        XCTAssert(comparison!.percentage < 50)
    }
    
    func testCompare_WhenUserDataIsMissing_ReturnsNil() {
        let comparison1 = BodyMath.compare(userA, to: userIncomplete)
        XCTAssertNil(comparison1)
        
        let comparison2 = BodyMath.compare(userIncomplete, to: userA)
        XCTAssertNil(comparison2)
    }

    // MARK: - Test Cases for `findBestMatch`

    func testFindBestMatch_FindsHighestPercentage() {
        let others = [userDifferent, userSimilar, userComparable]
        
        let bestMatch = BodyMath.findBestMatch(for: userA, from: others)
        
        XCTAssertNotNil(bestMatch)
        XCTAssertEqual(bestMatch?.user.id, userSimilar.id)
        XCTAssertEqual(bestMatch?.comparison.tier, .similar)
    }
    
    func testFindBestMatch_WithEmptyList_ReturnsNil() {
        let bestMatch = BodyMath.findBestMatch(for: userA, from: [])
        XCTAssertNil(bestMatch)
    }
    
    func testFindBestMatch_ExcludesSelf() {
        let others = [userA, userSimilar]
        let bestMatch = BodyMath.findBestMatch(for: userA, from: others)
        
        XCTAssertNotNil(bestMatch)
        XCTAssertEqual(bestMatch?.user.id, userSimilar.id, "Should not match with itself.")
    }
}
