//
//  Messages.swift
//  jlack
//
//  Created by Jack Flintermann on 11/2/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import Cocoa
import ReSwift
import SKWebAPI
import Result

fileprivate struct LoadMessageAction: AppAction {
    var type: AppActionType { return .requestedMessages }
}

fileprivate struct LoadedMessagesAction: AppAction {
    let type: AppActionType
    init(error: APIError) {
        self.type = .loadedMessages(result: Result(error: error))
    }
    init(messages: [Message]) {
        self.type = .loadedMessages(result: Result(messages))
    }
}

fileprivate struct ReceivedMessageAction: AppAction {
    let type: AppActionType
    init(message: Message) {
        self.type = .receivedMessage(message: message)
    }
}

fileprivate struct SendMessageAction: AppAction {
    let type: AppActionType
    init(text: String, temporaryId: Int) {
        self.type = .sendMessage(text: text, temporaryId: temporaryId)
    }
}

struct TimestampAndTemporaryId {
    let timestamp: String
    let temporaryId: Int
}

fileprivate struct AcknowledgedMessageAction: AppAction {
    let type: AppActionType
    init(error: MessageDeliveryError) {
        self.type = .messageAcknowledged(result: Result(error: error))
    }
    init(timestampAndTemporaryId: TimestampAndTemporaryId) {
        self.type = .messageAcknowledged(result: Result(timestampAndTemporaryId))
    }
}

extension AppActionz {
    
    static func loadMessages() -> ReSwift.Action {
        guard let token = AppStore.shared.state.accessToken else {
            return LoadedMessagesAction(error: .unauthenticated)
        }
        let web = WebAPI(token: token)
        // TODO so, so bad
        web.channelHistory(id: "C7SEJ0AUU", success: { history in
            let messages = history.messages.map({ (m: SKWebAPI.Message) -> Message in
                return Message(text: m.text!, timestamp: m.ts!)
            })
            AppStore.shared.dispatch(LoadedMessagesAction(messages: messages))
        }, failure: { error in
            AppStore.shared.dispatch(LoadedMessagesAction(error: .other(error: error)))
        })
        return LoadMessageAction()
    }
    
    static func receivedMessage(message: Message) -> ReSwift.Action {
        return ReceivedMessageAction(message: message)
    }
    
    static func sendMessage(text: String) -> ReSwift.Action {
        let temporaryId = Int(arc4random()) % 100000000
        do {
            try SlackRTMWrapper.shared?.rtm?.sendMessage(text, channelID: "C7SEJ0AUU", id: String(temporaryId))
        } catch let error {
            DispatchQueue.main.async {
                AppStore.shared.dispatch(AcknowledgedMessageAction(error: MessageDeliveryError(temporaryId: temporaryId, actualError: error)))
            }
        }
        return SendMessageAction(text: text, temporaryId: temporaryId)
    }
    
    static func acknowledgeMessage(timestampAndTemporaryId: TimestampAndTemporaryId) -> ReSwift.Action {
        return AcknowledgedMessageAction(timestampAndTemporaryId: timestampAndTemporaryId)
    }
    
    static func acknowledgeMessage(error: MessageDeliveryError) -> ReSwift.Action {
        return AcknowledgedMessageAction(error: error)
    }
    
    
}


