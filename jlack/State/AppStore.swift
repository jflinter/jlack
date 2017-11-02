//
//  AppStore.swift
//  jlack
//
//  Created by Jack Flintermann on 11/1/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import ReSwift

enum AppStore {
    static let shared = Store(reducer: appReducer, state: nil)
}
