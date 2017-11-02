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
    guard let action = action as? AppActions else { return state }
    switch action {
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
    guard let action = action as? AppActions else { return state }
    switch action {
    case .authenticated(let accessToken):
        return accessToken
    case .logout:
        return nil
    default:
        return state
    }
}

func messageReducer(action: Action, state: [Message]) -> [Message] {
    guard let action = action as? AppActions else { return state }
    switch action {
    case .loadedMessages(let messages):
        return `$`.uniq(state + messages, by: { $0.id }).sorted(by: { $0.timestamp < $1.timestamp })
    case .receivedMessage(let message):
        return `$`.uniq(state + [message], by: { $0.id }).sorted(by: { $0.timestamp < $1.timestamp })
    case .logout:
        return []
    default:
        return state
    }
}
