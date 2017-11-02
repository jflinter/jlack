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
                return state.accessToken
            }.skipRepeats(==)
        }
    }
    
    func newState(state: String?) {
        if let token = state {
            AppStore.shared.dispatch(AppActions.loadMessages(token: token))
        }
    }
    
    @objc func handleGetURLEvent(event: NSAppleEventDescriptor, withReplyEvent: NSAppleEventDescriptor) {
        if let redirect = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue,
            let url = URL(string: redirect),
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let accessToken = components.queryItems?.filter({ $0.name == "access_token" }).first?.value {
                AppStore.shared.dispatch(AppActions.authenticated(accessToken: accessToken))
        }
    }

}

