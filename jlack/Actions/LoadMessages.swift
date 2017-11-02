//
//  LoadMessages.swift
//  jlack
//
//  Created by Jack Flintermann on 11/2/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import Cocoa
import ReSwift
import SKWebAPI

extension AppActions {
    static func loadMessages(token: String) -> ReSwift.Action {
        let web = WebAPI(token: token)
        // TODO so, so bad
        web.channelHistory(id: "C7SEJ0AUU", success: { (history) in
            let messages = history.messages.map({ (m: SKWebAPI.Message) -> Message in
                return Message(id: m.ts!, text: m.text!, timestamp: Double(m.ts!)!)
            })
            AppStore.shared.dispatch(AppActions.loadedMessages(messages: messages))
        }, failure: nil)
        return AppActions.requestedMessages
    }
}

