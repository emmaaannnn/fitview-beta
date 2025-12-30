import Foundation
import Models

public struct ProductDetector {
    /// Detects gender using pure strings extracted by the scraper.
    public static func detectGender(from url: URL, bodyText: String, breadcrumbs: String) -> GenderCategory {
        let path = url.path.lowercased()
        let text = bodyText.lowercased()
        let crumbs = breadcrumbs.lowercased()
        
        // 1. URL Path check (High Priority)
        if path.contains("/men/") || path.contains("/mens/") { return .mens }
        if path.contains("/women/") || path.contains("/womens/") { return .womens }
        if path.contains("/unisex/") { return .unisex }
        
        // 2. Breadcrumbs check
        if crumbs.contains("women") { return .womens }
        if crumbs.contains("men") { return .mens }
        
        // 3. Page text check
        if text.contains("unisex") { return .unisex }
        if text.contains("women's") || text.contains("womenswear") { return .womens }
        if text.contains("men's") || text.contains("menswear") { return .mens }
        
        return .unknown
    }
}