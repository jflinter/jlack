//
//  Message.swift
//  jlack
//
//  Created by Jack Flintermann on 11/5/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

// encompasses both Messages and PendingMessages
protocol MessageProtocol {
    var text: String { get }
    var conversationId: String { get }
}

struct Message: Hashable, MessageProtocol {
    let text: String
    let timestamp: String // Slack wants you to treat these as strings for Precision Reasons
    let conversationId: String
    
    init(text: String, timestamp: String, conversationId: String) {
        self.text = text
        self.timestamp = timestamp
        self.conversationId = conversationId
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
