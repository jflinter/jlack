//
//  LoginViewController.swift
//  jlack
//
//  Created by Jack Flintermann on 11/2/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import Cocoa

class LoginViewController: NSViewController {
    @IBOutlet weak var backgroundView: NSBox!
    @IBOutlet weak var loginButton: NSBox!
    @IBOutlet weak var spinner: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundView.wantsLayer = true
        self.backgroundView.layerContentsRedrawPolicy = .onSetNeedsDisplay
        
        self.loginButton.wantsLayer = true
        self.loginButton.layerContentsRedrawPolicy = .onSetNeedsDisplay
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        AppStore.shared.dispatch(AppActionz.login())
    }
}
