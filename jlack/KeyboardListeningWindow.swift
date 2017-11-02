//
//  KeyboardListeningWindow.swift
//  jlack
//
//  Created by Jack Flintermann on 11/2/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import Cocoa
import ReSwift

class KeyboardListeningWindow: NSWindow {

    override func keyDown(with event: NSEvent) {
        if let action = AppActions.fromEvent(event) {
            AppStore.shared.dispatch(action)
        } else {
            super.keyDown(with: event)
        }
    }
}
