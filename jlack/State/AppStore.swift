//
//  AppStore.swift
//  jlack
//
//  Created by Jack Flintermann on 11/1/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import Cocoa
import ReSwift
import Foundation

enum AppStore {
    static let shared = MainThreadStoreWrapper(store: Store(reducer: appReducer, state: nil))
}

struct MainThreadStoreWrapper<State: StateType> {
    let store: Store<State>
    var state: State { return self.store.state }
    func dispatch(_ action: Action) {
        if Thread.isMainThread {
            self.store.dispatch(action)
        } else {
            DispatchQueue.main.async {
                self.store.dispatch(action)
            }
        }
    }
    
    func subscribe<SelectedState, S>(_ subscriber: S, transform: ((Subscription<State>) -> Subscription<SelectedState>)? = nil) where SelectedState == S.StoreSubscriberStateType, S : StoreSubscriber {
        if Thread.isMainThread {
            store.subscribe(subscriber, transform: transform)
        } else {
            DispatchQueue.main.async {
                self.store.subscribe(subscriber, transform: transform)
            }
        }
    }
    
    func unsubscribe(_ subscriber: AnyStoreSubscriber) {
        if Thread.isMainThread {
            self.store.unsubscribe(subscriber)
        } else {
            DispatchQueue.main.async {
                self.store.unsubscribe(subscriber)
            }
        }
    }
}

