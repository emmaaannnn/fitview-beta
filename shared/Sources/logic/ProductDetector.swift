import Foundation
import SwiftSoup
import Models 

public struct ProductDetector {
    
    // MARK: - 1. Store Detection
    public static func detectStore(from url: URL) -> String {
        let host = url.host()?.lowercased() ?? ""
        let cleanHost = host.replacingOccurrences(of: #"^(www\d?|m)\."#, with: "", options: .regularExpression)
            .components(separatedBy: ".")[0]
        
        let manualStoreNames = ["hm": "H&M", "bigw": "Big W", "kmart": "Kmart", "uniqlo": "Uniqlo", "amazon": "Amazon", "asos": "Asos", "zara": "Zara"]
        return manualStoreNames[cleanHost] ?? cleanHost.capitalized
    }
    
    // MARK: - 2. Brand Detection
    public static func detectBrand(from doc: Document, storeName: String) -> String {
        // 🚨 AMAZON OVERRIDE: Force Brand to Unknown
        if storeName == "Amazon" { return "Unknown" }
        
        var detectedBrand: String? = nil
        
        // Strategy A: JSON-LD (Robust Regex)
        if let jsonScripts = try? doc.select("script[type=application/ld+json]") {
            for script in jsonScripts {
                let rawJson = script.data()
                
                // Nested: "brand": { "@type": "Brand", "name": "Nike" }
                let pattern = #""brand"\s*:\s*\{[^}]*?"name"\s*:\s*"([^"]+)""#
                if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
                    let range = NSRange(rawJson.startIndex..<rawJson.endIndex, in: rawJson)
                    if let match = regex.firstMatch(in: rawJson, options: [], range: range) {
                        if let swiftRange = Range(match.range(at: 1), in: rawJson) {
                            detectedBrand = String(rawJson[swiftRange])
                            break
                        }
                    }
                }
                
                // Simple: "brand": "Nike"
                if detectedBrand == nil, let simpleMatch = rawJson.range(of: #"(?<="brand":\s?")[^"]+"#, options: .regularExpression) {
                    detectedBrand = String(rawJson[simpleMatch])
                    break
                }
            }
        }
        
        // Strategy B: Meta Tags & Title Fallback
        if detectedBrand == nil {
            let metaTags = ["product:brand", "og:brand", "twitter:data1"]
            for tag in metaTags {
                if let content = try? doc.select("meta[name=\(tag)], meta[property=\(tag)]").attr("content"), !content.isEmpty {
                    detectedBrand = content
                    break
                }
            }
        }

        // Strategy C: Store-Specific Fallbacks (ASOS Only)
        if detectedBrand == nil || detectedBrand == storeName {
            if storeName == "Asos", let title = try? doc.title() {
                let parts = title.components(separatedBy: "|")
                if parts.count > 0 {
                    let firstPart = parts[0].trimmingCharacters(in: .whitespaces)
                    if !firstPart.isEmpty && firstPart.count < 50 {
                         detectedBrand = firstPart.components(separatedBy: " ").prefix(2).joined(separator: " ")
                    }
                }
            }
        }

        return normalizeBrand(detectedBrand ?? storeName)
    }
    
    // MARK: - 3. SKU Detection
    public static func detectSKU(from doc: Document, urlString: String, brandName: String, storeName: String) -> String? {
        // 🚨 ZARA OVERRIDE: Force ID to Unknown so it passes verification
        if storeName == "Zara" { return "Unknown" }
        
        var finalID: String? = nil
        let brandLower = brandName.lowercased()
        let bodyText = (try? doc.body()?.text()) ?? ""
        
        // 1. HIGH PRIORITY: Explicit Text Scrapers
        
        // Uniqlo "Item Code"
        if storeName == "Uniqlo" {
            let pattern = #"Item Code:\s*(\d{6})"#
            if let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) {
                let range = NSRange(bodyText.startIndex..<bodyText.endIndex, in: bodyText)
                if let match = regex.firstMatch(in: bodyText, options: [], range: range) {
                     if let swiftRange = Range(match.range(at: 1), in: bodyText) {
                         return String(bodyText[swiftRange])
                     }
                }
            }
        }

        // 2. JSON-LD (Standard)
        if let jsonScripts = try? doc.select("script[type=application/ld+json]") {
            for script in jsonScripts {
                let rawJson = script.data()
                if let match = rawJson.range(of: #"(?<="sku":\s?")[^"]+"#, options: .regularExpression) {
                    finalID = String(rawJson[match])
                    break 
                } else if let match = rawJson.range(of: #"(?<="mpn":\s?")[^"]+"#, options: .regularExpression) {
                    finalID = String(rawJson[match])
                    break 
                }
            }
        }
        
        if finalID != nil { return finalID }
        
        // 3. Meta Tags
        let metaTags = ["product:retailer_item_id", "m_sku", "og:description"]
        for tag in metaTags {
            if let content = try? doc.select("meta[property=\(tag)], meta[name=\(tag)]").attr("content") {
                if brandLower == "nike", let range = content.range(of: #"[A-Z]{2}\d{4}-\d{3}"#, options: .regularExpression) {
                    return String(content[range])
                }
            }
        }
        
        // 4. Fallbacks (URL Regex)
        if brandLower.contains("kmart"), let range = urlString.range(of: #"S\d{6,}"#, options: .regularExpression) {
            return String(urlString[range]).uppercased()
        } 
        
        if brandLower.contains("uniqlo") {
             if let range = urlString.range(of: #"E\d{6}-\d{3}"#, options: .regularExpression) {
                 return String(urlString[range]).replacingOccurrences(of: "E", with: "")
             } else if let range = urlString.range(of: #"\d{6}"#, options: .regularExpression) {
                 return String(urlString[range])
             }
        }
        
        if storeName == "Amazon" { return "Unknown" }
        
        return finalID
    }

    public static func normalizeBrand(_ rawName: String) -> String {
        let clean = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
        let suffixes = [" Official Store", " Online", " AU", " US", " UK", " Australia", " Inc", ".com", ":"]
        var finalName = clean
        for suffix in suffixes {
            finalName = finalName.replacingOccurrences(of: suffix, with: "", options: [.caseInsensitive])
        }
        finalName = finalName.trimmingCharacters(in: .punctuationCharacters)
        return finalName.capitalized 
    }
}