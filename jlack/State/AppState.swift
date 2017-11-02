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
    static func ==(lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
    var hashValue: Int {
        get {
            return self.id.hashValue
        }
    }
    
    var id: String
    var text: String
    var timestamp: Double // TODO I am lazy
}

struct Conversation {
    var id: String
    var messageIds: [String]
}
