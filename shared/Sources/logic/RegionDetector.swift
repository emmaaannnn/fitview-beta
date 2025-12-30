import Foundation
import Models

public struct RegionDetector {
    public static func detect(from url: URL) -> MarketRegion {
        let host = url.host()?.lowercased() ?? ""
        let path = url.path.lowercased()
        
        // 1. Check Path (Priority for Global sites like Nike/Zara/Uniqlo)
        if path.contains("/jp/") || path.contains("/kr/") || host.hasSuffix(".jp") {
            return .asia
        }
        if path.contains("/au/") || host.hasSuffix(".au") {
            return .au
        }
        if path.contains("/uk/") || path.contains("/gb/") || host.hasSuffix(".uk") {
            return .uk
        }
        
        // 2. Fallback to US
        return .us
    }
}