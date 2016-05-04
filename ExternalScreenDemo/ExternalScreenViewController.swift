//
//  ExternalScreenViewController.swift
//  ExternalScreenDemo
//
//  Created by Rodger Higgins on 5/4/16.
//  Copyright © 2016 Rodger Higgins. All rights reserved.
//

import UIKit
import WebKit

class ExternalScreenViewController: UIViewController {
    
    private var webView: WKWebView?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = NSURL(string: "http://www.spazstik-software.com") {
            let req = NSURLRequest(URL: url)
            
            webView?.loadRequest(req)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
