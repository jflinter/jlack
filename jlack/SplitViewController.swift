//
//  SplitViewController.swift
//  jlack
//
//  Created by Jack Flintermann on 11/1/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import Cocoa

class SplitViewController: NSSplitViewController {

    @IBOutlet weak var messagesItem: NSSplitViewItem!
    
    static let sideBarWidth: CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.splitView.delegate = self
//        https://stackoverflow.com/questions/41291314/set-nssplitviewcontroller-panes-width-using-swift
        NSLayoutConstraint(item: messagesItem.viewController.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: SplitViewController.sideBarWidth).isActive = true
    }
    
    // this disables resizing the sidebar.
    override func splitView(_ splitView: NSSplitView, effectiveRect proposedEffectiveRect: NSRect, forDrawnRect drawnRect: NSRect, ofDividerAt dividerIndex: Int) -> NSRect {
        return NSRect.zero
    }

}
