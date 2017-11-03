//
//  APIErrors.swift
//  jlack
//
//  Created by Jack Flintermann on 11/2/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

struct MessageDeliveryError: Error {
    let temporaryId: Int
    let actualError: Error
}

enum APIError: Error {
    case unauthenticated
    case messageNotAcknowledged // TODO
    case other(error: Error)
}
