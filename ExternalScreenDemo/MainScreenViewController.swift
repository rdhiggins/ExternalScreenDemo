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


/// View controller used as the main view controller for the application.
/// It is displayed on the devices main screen only.  It uses a WKWebView as
/// its main view, which it loads a web site into..
class MainScreenViewController: UIViewController {

    /// Returns the view as a WKWebView
    var webView: WKWebView? {
        return view as? WKWebView
    }
    
    /// Property used to store a reference to the external window object
    /// when active
    fileprivate var externalWindow: UIWindow?
    
    deinit {
        // Cleanup notifications
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Overrided loadView method that is used to use a WKWebView
    override func loadView() {
        view = WKWebView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup to process external screen notifications
        setupScreenNotifications()
        
        // Load the WKWebView with something to show
        if let url = URL(string: "http://www.spazstik-software.com") {
            let req = URLRequest(url: url)
            
            _ = webView?.load(req)
        }
        
        // Check to see if there is an external screen already connected
        if UIScreen.screens.count > 1 {
            setupExternalScreen(UIScreen.screens[1])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /// A private method used to setup a external screen with a window
    /// loaded with a ExternalScreenViewController
    ///
    /// - parameter screen: A UIScreen object to connect the 
    /// ExternalScreenViewController too
    fileprivate func setupExternalScreen(_ screen: UIScreen) {
        guard externalWindow == nil,
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExternalScreen") as? ExternalScreenViewController else {
                return
        }
        
        externalWindow = UIWindow(frame: screen.bounds)
        externalWindow!.rootViewController = vc
        externalWindow!.screen = screen
        externalWindow!.isHidden = false
    }
    
    /// A private method used to teardown the external UIWindow object
    /// used to display the content on the external screen
    fileprivate func teardownExternalScreen() {
        guard let ew = externalWindow else { return }
        
        ew.isHidden = true
        externalWindow = nil
    }
    
    /// The method used to handle the external screen connection NSNoticiations.
    ///
    /// - parameter notification: A NSNotification object that informs us about
    /// the UIScreen instance that has just become active
    func externalScreenDidConnect(_ notification: Notification) {
        guard let screen = notification.object as? UIScreen else {
            return
        }
        
        setupExternalScreen(screen)
    }
    
    /// The method used to handle the notification for when a external screen
    /// disconnect.
    ///
    /// - parameter notification: A NSNotification object that informs us about
    /// the UIScreen instance that has just disconnected
    func externalScreenDidDisconnect(_ notification: Notification) {
        guard let _ = notification.object as? UIScreen else {
            return
        }
        
        teardownExternalScreen()
    }
    
    /// Method used to register the notification handlers for external
    /// screen connects/disconnects
    fileprivate func setupScreenNotifications() {
        let center = NotificationCenter.default

        center.addObserver(self, selector: #selector(MainScreenViewController.externalScreenDidConnect(_:)), name: NSNotification.Name.UIScreenDidConnect, object: nil)
        center.addObserver(self, selector: #selector(MainScreenViewController.externalScreenDidDisconnect(_:)), name: NSNotification.Name.UIScreenDidDisconnect, object: nil)
    }
}
