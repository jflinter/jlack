//
//  AppActionz.swift
//  jlack
//
//  Created by Jack Flintermann on 11/1/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import ReSwift
import Cocoa
import Result

enum AppActionType {
    case authenticated(accessToken: String)
    
    case requestedMessages
    case loadedMessages(result: Result<[Message], APIError>)
    case receivedMessage(message: Message)
    case sendMessage(text: String, inConversation: String, temporaryId: Int)
    case messageAcknowledged(result: Result<MessageAcknowledged, MessageDeliveryError>)
    
    case requestedConversations
    case loadedConversations(result: Result<[Conversation], APIError>)
    case selectedConversation(conversationId: String)
    
    case loginPressed
    case logout
    case pushedCommandT
    case pushedEsc
}

enum AppActionz {} // will be extended with static functions.

protocol AppAction: Action {
    var type: AppActionType { get }
}
