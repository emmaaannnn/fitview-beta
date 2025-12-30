import XCTest
@testable import Models

final class RegionTests: XCTestCase {
    func testMarketRegionProperties() {
        XCTAssertEqual(MarketRegion.au.displayName, "Australia")
        XCTAssertEqual(MarketRegion.us.displayName, "United States")
        XCTAssertEqual(MarketRegion.uk.displayName, "United Kingdom")
        XCTAssertEqual(MarketRegion.eu.displayName, "Europe")
        XCTAssertEqual(MarketRegion.jp.displayName, "Japan")
        XCTAssertEqual(MarketRegion.kr.displayName, "Korea")

        XCTAssertEqual(MarketRegion.jp.sizingGroup, "asia")
        XCTAssertEqual(MarketRegion.kr.sizingGroup, "asia")
        XCTAssertEqual(MarketRegion.us.sizingGroup, "us")
        XCTAssertEqual(MarketRegion.au.sizingGroup, "western")
        XCTAssertEqual(MarketRegion.uk.sizingGroup, "western")
        XCTAssertEqual(MarketRegion.eu.sizingGroup, "western")

        XCTAssertEqual(MarketRegion.us.preferredSystem, .imperial)
        XCTAssertEqual(MarketRegion.uk.preferredSystem, .imperial)
        XCTAssertEqual(MarketRegion.au.preferredSystem, .metric)
        XCTAssertEqual(MarketRegion.eu.preferredSystem, .metric)
        XCTAssertEqual(MarketRegion.jp.preferredSystem, .metric)
        XCTAssertEqual(MarketRegion.kr.preferredSystem, .metric)
    }
}
