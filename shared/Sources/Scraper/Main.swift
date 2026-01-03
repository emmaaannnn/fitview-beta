import Foundation
import SwiftSoup
import Models
import Logic

@main
struct ScraperApp {
    static func main() async {
        let testURLs = [
            //"https://www.uniqlo.com/au/en/products/E475053-000/00?colorDisplayCode=03&sizeDisplayCode=005",
            // "https://www.nike.com/jp/t/%E3%83%8A%E3%82%A4%E3%82%AD-%E3%83%86%E3%83%83%E3%82%AF-%E3%83%95%E3%83%AB%E3%82%B8%E3%83%83%E3%83%97-%E3%82%A6%E3%82%A3%E3%83%B3%E3%83%89%E3%83%A9%E3%83%B3%E3%83%8A%E3%83%BC-%E3%83%91%E3%83%BC%E3%82%AB%E3%83%BC-VBcJhM/HV0950-234",
            "https://www.zara.com/au/en/perforated-long-sleeve-t-shirt-p04387416.html?v1=457855780&v2=2133743",
            // "https://www.kmart.com.au/product/rib-tank-s169486/?selectedSwatch=DRIFT+BROWN",
            // "https://www.bigw.com.au/product/allgood-men-s-double-cloth-shirt-navy/p/1747940-navy",
            // "https://www2.hm.com/en_us/productpage.1316883001.html",
            // "https://www2.hm.com/en_au/productpage.1272338003.html",
            // "https://www.asos.com/au/polo-ralph-lauren/polo-ralph-lauren-chest-logo-lounge-t-shirt-in-camel/prd/208817481#colourWayId-208817483",
            // "https://www.bigw.com.au/product/nike-park-20-t-shirt-training-athletic-sportswear-black-black-size-m/p/9900492866?srsltid=AfmBOoqaUU41UXYXUgtKy4mVIFHDF5Otyv6CVTx6ckgJeHDsyyQVrUFk",
            "https://www.amazon.com.au/Nike-Dri-FIT-T-Shirt-Black-White/dp/B08QW8LJ3L/ref=sr_1_10?dib=eyJ2IjoiMSJ9.FNphDQKWcRUM6cUab0ddPW17wZN1SPz1Hlhaq9Q7lFXW7IsWN6-FgkGpTCiG030-_FR5nnZkDPl2bZMgkLW3ohMHCU4osqAfvZ0zCpfk2slhHKFohVMVXWjc4AuQWJJqdKyfceyKafV_8OT60ZfnImulZSFLaZyLjm4F-7SqhWRK48Fr-Geh_1XRKyj1SkL-P857_xq13Zx58I75dRQjM8KI19Wb2nMfNOjzL5oAYVF7GGVXAk_15XiaDgvOTy-uGFw4O9o2u0z769VtQgzBXXy13l34WNtgRE7jzCP3sUg.ICWemiptMcwoyRwdEfxl2F7gAwk5-3V931j7mCdzbNA&dib_tag=se&keywords=nike%2Bshirt&qid=1767434416&sr=8-10&th=1&psc=1"
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
            // 1. Fetch & Parse
            let html = try String(contentsOf: url, encoding: .utf8)
            let doc = try SwiftSoup.parse(html)

            // 2. Delegate "Identity" Logic to ProductDetector
            let store = ProductDetector.detectStore(from: url)
            let brand = ProductDetector.detectBrand(from: doc, storeName: store)
            let region = RegionDetector.detect(from: url)
            
            // 3. Delegate "Demographics" Logic
            let rawTitle = try doc.title()
            let name = rawTitle.components(separatedBy: " | ")[0]
            let bodyText = (try? doc.body()?.text()) ?? ""
            let breadcrumbs = (try? doc.select(".breadcrumb, .breadcrumbs").text()) ?? ""
            
            // Calling your existing separate GenderDetector file
            let gender = GenderDetector.detectGender(from: url, title: name, bodyText: bodyText, breadcrumbs: breadcrumbs)

            // 4. Verify SKU (The Brain does the heavy lifting now)
            guard let sku = ProductDetector.detectSKU(from: doc, urlString: urlString, brandName: brand, storeName: store), !sku.isEmpty else {
                print("⚠️ SKU not found for \(urlString). Skipping...")
                return
            }

            // 5. Create Product
            let scrapedProduct = Product(
                brandName: brand,
                sku: sku,
                storeName: store,
                name: name,
                genderCategory: gender,
                originRegion: region,
                originalURL: url,
                createdAt: Date()
            )

            print("✅ AUTOMATION COMPLETE")
            print("Brand:      \(scrapedProduct.brandName)")
            print("Store:      \(scrapedProduct.storeName)")
            print("Product:    \(scrapedProduct.name)")
            print("Region:     \(scrapedProduct.originRegion.displayName)")
            print("Product ID: \(scrapedProduct.sku)")
            print("Gender:     \(scrapedProduct.genderCategory.rawValue)")

        } catch {
            print("❌ Automation failed: \(error.localizedDescription)")
        }
    }
}