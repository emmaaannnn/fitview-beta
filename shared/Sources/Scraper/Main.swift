import Foundation
import SwiftSoup
import Models
import Logic

@main
struct ScraperApp {
    static func main() async {
        let testURLs = [
            "https://www.uniqlo.com/au/en/products/E475053-000/00?colorDisplayCode=03&sizeDisplayCode=005",
            "https://www.nike.com/jp/t/%E3%83%8A%E3%82%A4%E3%82%AD-%E3%83%86%E3%83%83%E3%82%AF-%E3%83%95%E3%83%AB%E3%82%B8%E3%83%83%E3%83%97-%E3%82%A6%E3%82%A3%E3%83%B3%E3%83%89%E3%83%A9%E3%83%B3%E3%83%8A%E3%83%BC-%E3%83%91%E3%83%BC%E3%82%AB%E3%83%BC-VBcJhM/HV0950-234",
            "https://www.zara.com/au/en/perforated-long-sleeve-t-shirt-p04387416.html?v1=457855780&v2=2133743",
            "https://www.kmart.com.au/product/rib-tank-s169486/?selectedSwatch=DRIFT+BROWN",
            "https://www.bigw.com.au/product/allgood-men-s-double-cloth-shirt-navy/p/1747940-navy",
            "https://www2.hm.com/en_us/productpage.1316883001.html"
        ]

        print("🚀 Starting Batch Scrape...\n")

        for urlString in testURLs {
            await scrapeSingleSite(urlString: urlString)
            print("\n------------------------------------------\n")
        }
    }

    static func scrapeSingleSite(urlString: String) async {
        guard let url = URL(string: urlString) else { return }

        do {
            let html = try String(contentsOf: url, encoding: .utf8)
            let doc = try SwiftSoup.parse(html)

            // 1. Brand Detection
            let brandMeta = try doc.select("meta[property=og:site_name]").attr("content")
            let detectedBrand = brandMeta.isEmpty 
                ? (url.host()?.replacingOccurrences(of: "www.", with: "").components(separatedBy: ".")[0].capitalized ?? "Unknown")
                : brandMeta

            // 2. Name Detection - CHANGED TO VAR
            let rawTitle = try doc.title()
            var cleanedName = rawTitle.components(separatedBy: " | ")[0] 

            // 3. Region Detection
            let region = RegionDetector.detect(from: url)

            // 4. OMNI-ID HUNTER
            var finalID: String? = nil
            let brandLower = detectedBrand.lowercased()

            // Priority: Structured Data
            let jsonScripts = try doc.select("script[type=application/ld+json]")
            for script in jsonScripts {
                let rawJson = script.data() // Removed try, .data() doesn't throw
                if let skuMatch = rawJson.range(of: #"(?<="sku":\s?")[^"]+"#, options: .regularExpression) {
                    finalID = String(rawJson[skuMatch])
                } else if let mpnMatch = rawJson.range(of: #"(?<="mpn":\s?")[^"]+"#, options: .regularExpression) {
                    finalID = String(rawJson[mpnMatch])
                }
            }

            // Fallback: Meta Tags
            if finalID == nil || finalID?.isEmpty == true {
                let metaTags = ["product:retailer_item_id", "m_sku", "og:description"]
                for tag in metaTags {
                    let content = try doc.select("meta[property=\(tag)], meta[name=\(tag)]").attr("content")
                    
                    if brandLower.contains("nike"), let range = content.range(of: #"[A-Z]{2}\d{4}-\d{3}"#, options: .regularExpression) {
                        finalID = String(content[range])
                        break
                    }   
                }
            }

            // Final Regex Fallback
            if finalID == nil || finalID?.isEmpty == true {
                if brandLower.contains("kmart"), let range = urlString.range(of: #"S\d{6,}"#, options: .regularExpression) {
                    finalID = String(urlString[range]).uppercased()
                } else if brandLower.contains("uniqlo"), let range = urlString.range(of: #"E\d{6}-\d{3}"#, options: .regularExpression) {
                    finalID = String(urlString[range]).replacingOccurrences(of: "E", with: "")
                }
            }

            // 6. Create Product
            let scrapedProduct = Product(
                brandName: detectedBrand,
                name: cleanedName,
                sku: finalID,
                originRegion: region,
                originalURL: url,
            )

            print("✅ AUTOMATION COMPLETE")
            print("Brand:      \(scrapedProduct.brandName)")
            print("Product:    \(scrapedProduct.name)")
            print("Region:     \(scrapedProduct.originRegion.displayName)")
            print("Product ID: \(scrapedProduct.sku ?? "None")")

        } catch {
            print("❌ Automation failed: \(error.localizedDescription)")
        }
    }
}