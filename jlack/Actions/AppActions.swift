//
//  AppActions.swift
//  jlack
//
//  Created by Jack Flintermann on 11/1/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import ReSwift
import Cocoa

enum AppActions: Action {
    case authenticated(accessToken: String)
    case requestedMessages
    case loadedMessages(messages: [Message])
    case receivedMessage(message: Message)
    case loginPressed
    case logout
    case pushedCommandT
    case pushedEsc
}

