//
//  TextEditorViewController.swift
//  jlack
//
//  Created by Jack Flintermann on 11/2/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import Cocoa

class TextEditorViewController: NSViewController, NSTextViewDelegate {

    @IBOutlet weak var messagesContainer: NSView!
    @IBOutlet weak var messageScrollView: NSScrollView!
    @IBOutlet var messageTextView: NSTextView!
    @IBOutlet weak var messageHeightConstraint: NSLayoutConstraint!
    var initialHeightConstraintValue: CGFloat = 0
    let maxHeightConstraintValue: CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageTextView.delegate = self
        self.initialHeightConstraintValue = self.messageHeightConstraint.constant
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        updateTextViewHeight()
    }
    
    func textDidChange(_ notification: Notification) {
        updateTextViewHeight()
    }
    
    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(insertNewline(_:)) {
            if let event = NSApp.currentEvent, event.modifierFlags.contains(.shift) {
                // shift is being held; don't do anything (insert a newline)
                return false
            } else {
                // shift is not held; send a message
                if !textView.string.isEmpty {
                    AppStore.shared.dispatch(AppActionz.sendMessage(text: textView.string))
                    textView.string = ""
                }
            }
        }
        return false
    }
    
    func updateTextViewHeight() {
        let height = min(max(self.messageTextView.frame.size.height, initialHeightConstraintValue), maxHeightConstraintValue)
        self.messageHeightConstraint.constant = height
    }
}
