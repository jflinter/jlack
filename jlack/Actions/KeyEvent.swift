//
//  KeyEvent.swift
//  jlack
//
//  Created by Jack Flintermann on 11/2/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import ReSwift
import Cocoa

extension AppActions {
    static func fromEvent(_ event: NSEvent) -> Action? {
        let tKeyCode = 17
        let escKeyCode = 53
        
        func isCommandT(_ event: NSEvent) -> Bool {
            return event.keyCode == tKeyCode && event.modifierFlags.contains(NSEvent.ModifierFlags.command)
        }
        
        func isEsc(_ event: NSEvent) -> Bool {
            return event.keyCode == escKeyCode
        }
        
        if isCommandT(event) {
            return AppActions.pushedCommandT
        }
        if isEsc(event) {
            return AppActions.pushedEsc
        }
        return nil
    }
}
