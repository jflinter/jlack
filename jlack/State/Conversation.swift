//
//  Conversation.swift
//  jlack
//
//  Created by Jack Flintermann on 11/5/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

struct Conversation: Equatable {
    let id: String
    let name: String
    
    static func ==(lhs: Conversation, rhs: Conversation) -> Bool {
        return lhs.id == rhs.id
    }
}
