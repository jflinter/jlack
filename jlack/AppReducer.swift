//
//  AppReducer.swift
//  jlack
//
//  Created by Jack Flintermann on 11/1/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import ReSwift
import Dollar
import Foundation

func appReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    state.quickOpenDisplayed = quickLookReducer(action: action, state: state.quickOpenDisplayed)
    state.accessToken = accessTokenReducer(action: action, state: state.accessToken)
    state.messages = messageReducer(action: action, state: state.messages)
    state.conversations = conversationReducer(action: action, state: state.conversations)
    return state
}

func quickLookReducer(action: Action, state: Bool) -> Bool {
    guard let action = action as? AppAction else { return state }
    switch action.type {
    case .pushedCommandT:
        return !state
    case .pushedEsc:
        return false
    case .logout:
        return false
    default:
        return state
    }
}

func accessTokenReducer(action: Action, state: String?) -> String? {
    guard let action = action as? AppAction else { return state }
    switch action.type {
    case .authenticated(let accessToken):
        return accessToken
    case .logout:
        return nil
    default:
        return state
    }
}

func conversationReducer(action: Action, state: ConversationState) -> ConversationState {
    guard let action = action as? AppAction else { return state }
    switch action.type {
    case .loadedConversations(let result):
        switch result {
        case .success(let conversations):
            return state.inserting(conversations)
        case .failure(_):
            // TODO do something?
            break
        }
    case .selectedConversation(let conversationId):
        var state = state
        state.selectedConversationId = conversationId
        return state
    default: break
    }
    return state
}

func messageReducer(action: Action, state: MessageState) -> MessageState {
    guard let action = action as? AppAction else { return state }
    switch action.type {
    case .loadedMessages(let result):
        switch result {
        case .success(let messages):
            return state.inserting(messages)
        case .failure(_):
            return state // TODO figure out errors
        }
    case .sendMessage(let text, let inConversation, let temporaryId):
        let pendingMessage = PendingMessage(temporaryId: temporaryId, text: text, conversationId: inConversation, timestamp: Date())
        return state.insertingPending(pendingMessage)
    case .messageAcknowledged(let result):
        switch result {
        case .success(let acknowledgement):
            return state.handlingMessageConfirmation(acknowledgement)
        case .failure(let error):
            // TODO show an alert or something?
            return state.removingPendingWithId(error.temporaryId)
        }
    case .receivedMessage(let message):
        return state.inserting(message)
    case .logout:
        return MessageState()
    default:
        return state
    }
}
