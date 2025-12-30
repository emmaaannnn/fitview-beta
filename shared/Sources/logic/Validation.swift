import Foundation
import Models

public struct Validation {
    
    /// Determines if a product has enough data to be considered "Trusted"
    public static func isProductValidated(sku: String?, brand: String, name: String) -> Bool {
        // 1. A product MUST have a SKU to be validated in V2
        guard let sku = sku, !sku.isEmpty else { return false }
        
        // 2. The brand and name must be substantial (not just "Unknown")
        if brand.lowercased() == "unknown" || name.count < 3 {
            return false
        }
        
        return true
    }
    
    /// Compares two SKUs to see if they represent the same "Design Era"
    /// This helps the app detect if the product version has shifted.
    public static func isSameVersion(scrapedSKU: String, existingSKU: String) -> Bool {
        // In fashion, sometimes only the last 3 digits change for color, 
        // while the first 6 are the "Version ID".
        // Example: E450535-000 vs E450535-001 (Same version, different color)
        let scrapedBase = scrapedSKU.prefix(7)
        let existingBase = existingSKU.prefix(7)
        
        return scrapedBase == existingBase
    }
}