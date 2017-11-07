//
//  AppDelegate.swift
//  jlack
//
//  Created by Jack Flintermann on 10/30/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import Cocoa
import ReSwift
import SKWebAPI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, StoreSubscriber {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        Settings.load(withStore: AppStore.shared)
        SlackRTMWrapper.load(withStore: AppStore.shared)
        
        let selector = #selector(AppDelegate.handleGetURLEvent(event:withReplyEvent:))
        NSAppleEventManager.shared().setEventHandler(self, andSelector: selector, forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
        
        AppStore.shared.subscribe(self) { sub in
            sub.select { state in
                return (state.accessToken, state.conversations.selectedConversationId)
                }.skipRepeats({ (tuple1, tuple2) -> Bool in
                    return tuple1.0 == tuple2.0 && tuple1.1 == tuple2.1
                })
        }
    }
    
    func newState(state: (String?, String?)) {
        if let _ = state.0, let conversationId = state.1 {
            // TODO this should live elsewhere
            AppStore.shared.dispatch(AppActionz.loadMessages(inConversationWithId: conversationId))
        }
    }
    
    @objc func handleGetURLEvent(event: NSAppleEventDescriptor, withReplyEvent: NSAppleEventDescriptor) {
        if let redirect = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue,
            let url = URL(string: redirect),
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let accessToken = components.queryItems?.filter({ $0.name == "access_token" }).first?.value {
                AppStore.shared.dispatch(AppActionz.authenticated(accessToken: accessToken))
        }
    }

}

