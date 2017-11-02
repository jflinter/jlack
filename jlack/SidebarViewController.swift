//
//  SidebarViewController.swift
//  jlack
//
//  Created by Jack Flintermann on 11/2/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import Cocoa

class SidebarViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    // TODO move me somewhere else; don't forget to update the bottom constraint on the outline view in the storyboard
    @IBAction func logoutPressed(_ sender: Any) {
        AppStore.shared.dispatch(AppActions.logout)
    }
}
