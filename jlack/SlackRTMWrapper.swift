//
//  SlackRTM.swift
//  jlack
//
//  Created by Jack Flintermann on 11/1/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import ReSwift
import Foundation
import SKRTMAPI

class SlackRTMWrapper: StoreSubscriber, RTMAdapter {
    private let store: Store<AppState>
    private var rtm: SKRTMAPI? = nil
    private static var shared: SlackRTMWrapper? = nil
    
    private init(withStore store: Store<AppState>) {
        self.store = store
        store.subscribe(self) { subscription in
            return subscription.select { $0.accessToken }.skipRepeats(==)
        }
    }
    
    static func load(withStore store: Store<AppState>) {
        guard self.shared == nil else { return }
        self.shared = SlackRTMWrapper(withStore: store)
    }
    
    func newState(state: String?) {
        if let token = state {
            self.rtm = SKRTMAPI(withAPIToken: token)
            self.rtm?.adapter = self
            self.rtm?.connect()
        } else {
            self.rtm?.disconnect()
            self.rtm = nil
        }
    }
    
    func initialSetup(json: [String : Any], instance: SKRTMAPI) {
        // TODO?
    }
    
    func notificationForEvent(_ event: Event, type: EventType, instance: SKRTMAPI) {
        switch type {
        case .message:
            // TODO so, so bad
            let message = Message(id: event.ts!, text: event.text!, timestamp: Double(event.ts!)!)
            self.store.dispatch(AppActions.receivedMessage(message: message))
        default:
            break
        }
    }
}

