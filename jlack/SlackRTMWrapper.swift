//
//  SlackRTM.swift
//  jlack
//
//  Created by Jack Flintermann on 11/1/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import ReSwift
import Foundation
import SKCore

class SlackRTMWrapper: StoreSubscriber, RTMAdapter {
    private let store: Store<AppState>
    var rtm: SKRTMAPI? = nil
    static var shared: SlackRTMWrapper? = nil
    
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
        case .ok:
            if let _ = event.text {
                self.store.dispatch(AppActionz.acknowledgeMessage(
                    timestampAndTemporaryId: TimestampAndTemporaryId(
                        timestamp: event.ts!,
                        temporaryId: Int(event.replyTo!)
                    )
                ))
            } else {
                self.store.dispatch(AppActionz.acknowledgeMessage(
                    error: MessageDeliveryError(temporaryId: Int(event.replyTo!), actualError: APIError.messageNotAcknowledged)
                ))
            }
        case .message:
            // TODO so, so bad
            let message = Message(text: event.text!, timestamp: event.ts!)
            self.store.dispatch(AppActionz.receivedMessage(message: message))
        default:
            break
        }
    }
}

