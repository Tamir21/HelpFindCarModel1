//
//  URLViewController.swift
//  HelpFindCarModel
//
//  Created by Tamir Hussain on 09/01/2018.
//  Copyright © 2018 Tamir Hussain. All rights reserved.
//

import UIKit
import WebKit

class URLViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    var selectedDealership:Dealership!
    
    // Set up the webview
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the URL from the web service
        let myURL = URL(string: (selectedDealership?.URL)!)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
