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
    
    static func load(withStore store: MainThreadStoreWrapper<AppState>) {
        guard self.shared == nil else { return }
        self.shared = SlackRTMWrapper(withStore: store.store)
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
        if let channelsJSON = json["channels"] as? [[String: Any]] {
            let channels: [Conversation] = channelsJSON.flatMap { channelJSON in
                guard let id = channelJSON["id"] as? String, let name = channelJSON["name"] as? String else { return nil }
                return Conversation(id: id, name: name)
            }
            AppStore.shared.dispatch(AppActionz.loadedConversations(channels))
        }
        // TODO?
    }
    
    func notificationForEvent(_ event: Event, type: EventType, instance: SKRTMAPI) {
        switch type {
        case .ok:
            if let replyTo = event.replyTo {
                if let _ = event.text {
                    self.store.dispatch(AppActionz.acknowledgeMessage(
                        messageAcknowledged: MessageAcknowledged(
                            timestamp: event.ts!,
                            temporaryId: Int(replyTo),
                            text: event.text!
                        )
                    ))
                } else {
                    self.store.dispatch(AppActionz.acknowledgeMessage(
                        error: MessageDeliveryError(temporaryId: Int(replyTo), actualError: APIError.messageNotAcknowledged)
                    ))
                }
            }
        case .message:
            // TODO so, so bad
            // TODO specifically, we need to update SKCore to get conversationId not channelId or DMs will break
            if let text = event.text, let timestamp = event.ts, let conversationId = (event.channelID ?? event.channel?.id) {
                let message = Message(text: text, timestamp: timestamp, conversationId: conversationId)
                self.store.dispatch(AppActionz.receivedMessage(message: message))
            }
        default:
            break
        }
    }
}

