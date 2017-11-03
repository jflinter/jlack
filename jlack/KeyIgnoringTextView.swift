//
//  KeyIgnoringTextField.swift
//  jlack
//
//  Created by Jack Flintermann on 11/2/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import Cocoa

class KeyIgnoringTextView: NSTextView {

    // TODO it's not ideal that this logic is duplicated in KeyboardListeningWindow.
    // It's needed because here the text view is the first responder, not the window.
    override func keyDown(with event: NSEvent) {
        if let action = AppActionz.fromEvent(event) {
            AppStore.shared.dispatch(action)
        } else {
            super.keyDown(with: event)
        }
    }
}
