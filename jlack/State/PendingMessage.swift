//
//  PendingMessage.swift
//  jlack
//
//  Created by Jack Flintermann on 11/6/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import Foundation

struct PendingMessage: MessageProtocol, Equatable {
    let temporaryId: Int
    let text: String
    let conversationId: String
    let timestamp: Date
    
    static func ==(lhs: PendingMessage, rhs: PendingMessage) -> Bool {
        return lhs.temporaryId == rhs.temporaryId
    }
}
