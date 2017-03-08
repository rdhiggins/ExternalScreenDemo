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
    
    fileprivate var webView: WKWebView?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: "http://www.spazstik-software.com") {
            let req = URLRequest(url: url)
            
            _ = webView?.load(req)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
