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
    
    typealias QuickOpenDisplayedAndAccessTokenAndSelectedConversationId = (Bool, String?, String?)

    override func viewWillAppear() {
        super.viewWillAppear()
        AppStore.shared.subscribe(self) { subscription in
            let select = subscription.select { ($0.quickOpenDisplayed, $0.accessToken, $0.conversations.selectedConversationId) }
            return select.skipRepeats({
                $0.0 == $1.0 && $0.1 == $1.1 && $0.2 == $1.2
            })
        }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        AppStore.shared.unsubscribe(self)
    }
    
    var currentConversationId: String? = nil
    func newState(state: QuickOpenDisplayedAndAccessTokenAndSelectedConversationId) {
        self.quickOpenView.isHidden = !state.0 || currentConversationId != state.2
        self.loginView.isHidden = state.1 != nil
        self.currentConversationId = state.2
    }
}
