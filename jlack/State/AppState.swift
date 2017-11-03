//
//  State.swift
//  jlack
//
//  Created by Jack Flintermann on 11/1/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import ReSwift
import Foundation

// Think of this as a database. Each variable is a table. Each model here should be as *normalized* as possible.
struct AppState: StateType {
    init() {
        quickOpenDisplayed = false
        accessToken = nil
        conversations = []
        messages = []
    }
    
    var quickOpenDisplayed: Bool
    var accessToken: String?
    var conversations: [Conversation]
    var messages: [Message]
}

struct Message: Hashable {
    let temporaryId: Int? // for attributing delivery confirmations to queued messages
    let text: String
    let timestamp: String // Slack wants you to treat these as strings for Precision Reasons
    
    init(text: String, timestamp: String, temporaryId: Int? = nil) {
        self.text = text
        self.timestamp = timestamp
        self.temporaryId = temporaryId
    }
    
    static func ==(lhs: Message, rhs: Message) -> Bool {
        return lhs.timestamp == rhs.timestamp
    }
    
    var hashValue: Int {
        get {
            return self.timestamp.hashValue
        }
    }
}

struct Conversation {
    var id: String
    var messageTimestamps: [String]
}
