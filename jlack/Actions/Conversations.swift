//
//  Conversations.swift
//  jlack
//
//  Created by Jack Flintermann on 11/5/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import Result
import ReSwift

fileprivate struct ListConversationsAction: AppAction {
    var type: AppActionType { return .pushedCommandT }
}

fileprivate struct LoadConversationsAction: AppAction {
    var type: AppActionType { return .requestedConversations }
}

fileprivate struct LoadedConversationsAction: AppAction {
    let type: AppActionType
    init(error: APIError) {
        self.type = .loadedConversations(result: Result(error: error))
    }
    init(conversations: [Conversation]) {
        self.type = .loadedConversations(result: Result(conversations))
    }
}

fileprivate struct SelectedConversationAction: AppAction {
    let type: AppActionType
    init(conversationId: String) {
        self.type = .selectedConversation(conversationId: conversationId)
    }
}

extension AppActionz {
    static func loadedConversations(_ conversations: [Conversation]) -> ReSwift.Action {
        return LoadedConversationsAction(conversations: conversations)
    }
    
    static func selectedConversation(_ conversationId: String) -> ReSwift.Action {
        AppStore.shared.dispatch(loadMessages(inConversationWithId: conversationId))
        return SelectedConversationAction(conversationId: conversationId)
    }
}
