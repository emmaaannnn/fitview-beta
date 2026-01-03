import Foundation
import Models

public struct GenderDetector {
    /// Detects gender using pure strings extracted by the scraper.
    public static func detectGender(from url: URL, title: String, bodyText: String, breadcrumbs: String) -> GenderCategory {
        let path = url.path.lowercased()
        let cleanTitle = title.lowercased()
        let text = bodyText.lowercased()
        let crumbs = breadcrumbs.lowercased()
        
        // 1. URL Path check (High Priority)
        if path.contains("/men/") || path.contains("/mens/") { return .mens }
        if path.contains("/women/") || path.contains("/womens/") { return .womens }
        if path.contains("/unisex/") { return .unisex }
        
        // 2. Title Check (New: Fixes Amazon "Nike Mens T-Shirt")
        if cleanTitle.contains("unisex") { return .unisex }
        if cleanTitle.contains("women's") || cleanTitle.contains("womens ") { return .womens }
        if cleanTitle.contains("men's") || cleanTitle.contains("mens ") { return .mens } // Catch "mens" without apostrophe
        
        // 3. Breadcrumbs check
        if crumbs.contains("women") { return .womens }
        if crumbs.contains("men") { return .mens }
        
        // 4. Page text check
        if text.contains("unisex") { return .unisex }
        if text.contains("women's") || text.contains("womenswear") { return .womens }
        if text.contains("men's") || text.contains("menswear") { return .mens }
        
        return .unknown
    }
}