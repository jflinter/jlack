//
//  State.swift
//  jlack
//
//  Created by Jack Flintermann on 11/1/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import ReSwift
import Foundation

// Think of this as a database. Each struct is a table. Each model here should be as *normalized* as possible.
struct AppState: StateType {
    var quickOpenDisplayed: Bool = false
    var accessToken: String? = nil
    var conversations: ConversationState = ConversationState()
    var messages: MessageState = MessageState()
}

struct ConversationState: Equatable {
    // TODO initializing these to known defaults; they should instead be loaded on launch.
    fileprivate static let yakshackId = "C7SEJ0AUU"
    fileprivate static let yakshack = Conversation(id: yakshackId, name: "general")
    var conversationsByID: [String: Conversation] = [ConversationState.yakshackId: ConversationState.yakshack]
    var selectedConversationId: String? = ConversationState.yakshackId
    var selectedConversation: Conversation? {
        guard let id = selectedConversationId else { return nil }
        return conversationsByID[id]
    }
    var pendingMessages: [String: String] = [:] // temporary id to conversation id
    
    func inserting(_ conversation: Conversation) -> ConversationState {
        var state = self
        state.conversationsByID.merge([conversation.id: conversation], uniquingKeysWith: {x, y in x})
        return state
    }
    
    func inserting(_ conversations: [Conversation]) -> ConversationState {
        var state = self
        let normalized: [String: Conversation] = Dictionary(conversations.map {($0.id, $0)}, uniquingKeysWith: { x, y in return x })
        state.conversationsByID.merge(normalized, uniquingKeysWith: {x, y in x})
        return state
    }
    
    static func ==(lhs: ConversationState, rhs: ConversationState) -> Bool {
        return lhs.conversationsByID == rhs.conversationsByID && lhs.selectedConversationId == rhs.selectedConversationId
    }
}

struct MessageState {
    private var messagesByID: [String: Message] = [:]
    private var pendingMessagesByID: [Int: PendingMessage] = [:]
    
    func messages(forConversationId conversationId: String) -> [Message] {
        return self.messagesByID.values.filter { $0.conversationId == conversationId }.sorted { $0.timestamp < $1.timestamp }
    }
    
    func pendingMessages(forConversationId conversationId: String) -> [PendingMessage] {
        return self.pendingMessagesByID.values.filter { $0.conversationId == conversationId }.sorted { $0.timestamp < $1.timestamp }
    }
    
    func inserting(_ message: Message) -> MessageState {
        var state = self
        state.messagesByID.merge([message.timestamp: message], uniquingKeysWith: {x, y in x})
        return state
    }
    
    func inserting(_ messages: [Message]) -> MessageState {
        var state = self
        let normalized: [String: Message] = Dictionary(messages.map {($0.timestamp, $0)}, uniquingKeysWith: { x, y in return x })
        state.messagesByID.merge(normalized, uniquingKeysWith: {x, y in x})
        return state
    }
    
    func insertingPending(_ pendingMessage: PendingMessage) -> MessageState {
        var state = self
        state.pendingMessagesByID[pendingMessage.temporaryId] = pendingMessage
        return state
    }
    
    // TODO this might be reducer logic
    func handlingMessageConfirmation(_ acknowledgement: MessageAcknowledged) -> MessageState {
        var state = self
        guard let pending = state.pendingMessagesByID.removeValue(forKey: acknowledgement.temporaryId) else { return state }
        let message = Message(text: acknowledgement.text, timestamp: acknowledgement.timestamp, conversationId: pending.conversationId)
        return state.inserting(message)
    }
    
    func removingPendingWithId(_ pendingMessageId: Int) -> MessageState {
        var state = self
        state.pendingMessagesByID.removeValue(forKey: pendingMessageId)
        return state
    }
}
