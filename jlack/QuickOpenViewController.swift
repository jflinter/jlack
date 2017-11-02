//
//  QuickOpenViewController.swift
//  jlack
//
//  Created by Jack Flintermann on 11/1/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import Cocoa

class QuickOpenViewController: NSViewController {

    @IBOutlet weak var backgroundView: NSBox!
    @IBOutlet weak var searchField: NSTextView!
    @IBOutlet weak var resultsCollectionView: NSCollectionView!
    @IBOutlet weak var searchContainer: NSBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundView.wantsLayer = true
        self.backgroundView.layerContentsRedrawPolicy = .onSetNeedsDisplay
        
        self.searchContainer.layer = self.searchContainer.layer
        self.searchContainer.wantsLayer = true
        self.searchContainer.layer?.cornerRadius = 20.0
        self.searchContainer.layer?.masksToBounds = true
        
        self.searchField.wantsLayer = true
        self.searchField.layerContentsRedrawPolicy = .onSetNeedsDisplay
        self.searchField.isAutomaticSpellingCorrectionEnabled = false
        self.searchField.isContinuousSpellCheckingEnabled = false
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.view.window?.makeFirstResponder(self.searchField)
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        self.searchField.string = ""
        self.view.window?.makeFirstResponder(nil)
    }
    
}
