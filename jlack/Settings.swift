//
//  UserDefaults.swift
//  jlack
//
//  Created by Jack Flintermann on 11/1/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import ReSwift
import Foundation

// TODO rename this once we store things in the keychain, etc
class Settings: StoreSubscriber {
    
    private let store: Store<AppState>
    private static var shared: Settings? = nil
    private static let key = "jlack_access_token"
    private static var accessToken: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        } get {
            return UserDefaults.standard.string(forKey: key)
        }
    }
    
    func newState(state: AppState) {
        Settings.accessToken = state.accessToken
    }
    
    private init(withStore store: MainThreadStoreWrapper<AppState>) {
        self.store = store.store
        if let token = Settings.accessToken {
            store.dispatch(AppActionz.authenticated(accessToken: token))
        }
        store.subscribe(self)
    }
    
    static func load(withStore store: MainThreadStoreWrapper<AppState>) {
        guard self.shared == nil else { return }
        let settings = Settings(withStore: store)
        self.shared = settings
    }
}
