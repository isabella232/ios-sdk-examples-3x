//
//  WebViewController.swift
//  TaboolaSDKExampleV3
//
//  Created by Liad Elidan on 22/03/2020.
//  Copyright © 2020 Liad Elidan. All rights reserved.
//

import Foundation
import TaboolaSDK

class WebViewController: UIViewController, WKNavigationDelegate, TBLWebDelegate{
    @IBOutlet weak var webViewContainer: UIView!
    var webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.frame = view.frame
        webViewContainer.addSubview(webView)
        
        let jsPage =  TBLWebPage.init(delegate: self)
        jsPage.createUnit(with: webView)
                
        try? loadExamplePage()
    }
    
    func loadExamplePage() throws {
        guard let htmlPath = Bundle.main.path(forResource: "SampleHTMLPage", ofType: "html") else {
            print("Error loading HTML")
            return
        }
        let appHtml = try String.init(contentsOfFile: htmlPath, encoding: .utf8)
        webView.loadHTMLString(appHtml, baseURL: URL(string: "https://cdn.taboola.com/mobile-sdk/init/"))
    }
    
    // TBLWebDelegate:
    
    func webView(_ webView: WKWebView!, didLoadPlacementNamed placementName: String!, withHeight height: CGFloat) {
        print("Placement name: \(String(describing: placementName)) has been loaded with height: \(height)")
    }
    
    func webView(_ webView: WKWebView!, didFailToLoadPlacementNamed placementName: String!, withErrorMessage error: String!) {
        print("Placement name: \(String(describing: placementName)) failed to load!)")
        print("Error: \(String(describing: error))")
    }
    
    func onItemClick(_ placementName: String!, withItemId itemId: String!, withClickUrl clickUrl: String!, isOrganic organic: Bool) -> Bool {
        // Return 'true' for Taboola SDK to handle the click event (default behavior).
        // Return 'false' to handle the click event yourself. (Applicable for organic content only.)
        return true;
    }
}
