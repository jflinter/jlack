//
//  MainContainerViewController.swift
//  jlack
//
//  Created by Jack Flintermann on 11/1/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import Cocoa
import ReSwift

class MainContainerViewController: NSViewController, StoreSubscriber {
    @IBOutlet weak var splitView: NSView!
    @IBOutlet weak var quickOpenView: NSView!
    @IBOutlet weak var loginView: NSView!
    
    typealias QuickOpenDisplayedAndAccessToken = (Bool, String?)

    override func viewWillAppear() {
        super.viewWillAppear()
        AppStore.shared.subscribe(self) { subscription in
            return subscription.select { ($0.quickOpenDisplayed, $0.accessToken) }.skipRepeats({
                $0.0 == $1.0 && $0.1 == $1.1
            })
        }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        AppStore.shared.unsubscribe(self)
    }
    
    func newState(state: QuickOpenDisplayedAndAccessToken) {
        self.quickOpenView.isHidden = !state.0
        self.loginView.isHidden = state.1 != nil
    }
}
