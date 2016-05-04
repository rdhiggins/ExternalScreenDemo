//
// MainScreenViewController.swift
// MIT License
//
// Copyright (c) 2016 Spazstik Software, LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


import UIKit
import WebKit

class MainScreenViewController: UIViewController {

    private var webView: WKWebView?
    private var externalWindow: UIWindow?
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func loadView() {
        webView = WKWebView()
        view = webView
        
        // Check to see if there is an external screen already connected
        if UIScreen.screens().count > 1 {
            setupExternalScreen(UIScreen.screens()[1])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreenNotifications()
        
        if let url = NSURL(string: "http://www.spazstik-software.com") {
            let req = NSURLRequest(URL: url)
            
            webView?.loadRequest(req)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    private func setupExternalScreen(screen: UIScreen) {
        guard externalWindow == nil,
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ExternalScreen") as? ExternalScreenViewController else {
                return
        }
        
        externalWindow = UIWindow(frame: screen.bounds)
        externalWindow!.rootViewController = vc
        externalWindow!.screen = screen
        externalWindow!.hidden = false
    }
    
    private func teardownExternalScreen() {
        guard let ew = externalWindow else { return }
        
        ew.hidden = true
        externalWindow = nil
    }
    
    func externalScreenDidConnect(notification: NSNotification) {
        guard let screen = notification.object as? UIScreen else {
            return
        }
        
        setupExternalScreen(screen)
    }
    
    func externalScreenDidDisconnect(notification: NSNotification) {
        guard let _ = notification.object as? UIScreen else {
            return
        }
        
        teardownExternalScreen()
    }
    
    private func setupScreenNotifications() {
        let center = NSNotificationCenter.defaultCenter()

        center.addObserver(self, selector: #selector(MainScreenViewController.externalScreenDidConnect(_:)), name: UIScreenDidConnectNotification, object: nil)
        center.addObserver(self, selector: #selector(MainScreenViewController.externalScreenDidDisconnect(_:)), name: UIScreenDidDisconnectNotification, object: nil)
    }
}
