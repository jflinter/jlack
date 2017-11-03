//
//  AppReducer.swift
//  jlack
//
//  Created by Jack Flintermann on 11/1/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import ReSwift
import Dollar

func appReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    state.quickOpenDisplayed = quickLookReducer(action: action, state: state.quickOpenDisplayed)
    state.accessToken = accessTokenReducer(action: action, state: state.accessToken)
    state.messages = messageReducer(action: action, state: state.messages)
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

func messageReducer(action: Action, state: [Message]) -> [Message] {
    guard let action = action as? AppAction else { return state }
    switch action.type {
    case .loadedMessages(let result):
        switch result {
        case .success(let messages):
            return `$`.uniq(state + messages, by: { $0.timestamp }).sorted(by: { $0.timestamp < $1.timestamp })
        case .failure(_):
            return [] // TODO figure out errors
        }
    case .sendMessage(let text, let temporaryId):
        // TODO this is hacky - i'm trying to get messages into a stable sort order
        // so that if we send a message, then a new message is received before ours is confirmed,
        // we can still sort the whole array of messages and get the correct order.
        let tmpTimestamp = (state.last?.timestamp ?? "") + "$"
        let message = Message(text: text, timestamp: tmpTimestamp, temporaryId: temporaryId)
        return state + [message]
    case .messageAcknowledged(let result):
        switch result {
        case .success(let timestampAndTemporaryId):
            // loop through messages, convert temp message into a real one
            return state.map { message in
                if message.temporaryId == timestampAndTemporaryId.temporaryId {
                    return Message(text: message.text, timestamp: timestampAndTemporaryId.timestamp)
                }
                return message
            }
        case .failure(let error): // TODO show an alert or something
            // loop through messages, remove the one that failed to send
            return state.filter { $0.temporaryId == error.temporaryId }
        }
    case .receivedMessage(let message):
        return `$`.uniq(state + [message], by: { $0.timestamp }).sorted(by: { $0.timestamp < $1.timestamp })
    case .logout:
        return []
    default:
        return state
    }
}
