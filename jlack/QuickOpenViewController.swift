//
//  QuickOpenViewController.swift
//  jlack
//
//  Created by Jack Flintermann on 11/1/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import Cocoa
import ReSwift

class QuickOpenViewController: NSViewController, StoreSubscriber, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout, NSTextViewDelegate {

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
        
        self.resultsCollectionView.delegate = self
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        self.view.window?.makeFirstResponder(self.searchField)
        AppStore.shared.subscribe(self) { subscription in
            return subscription.select { state in
                return state.conversations
            }.skipRepeats(==)
        }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        self.searchField.string = ""
        self.view.window?.makeFirstResponder(nil)
        AppStore.shared.unsubscribe(self)
    }
    
    var conversations: [Conversation] = []
    var filteredConversations: [Conversation] {
        return self.conversations.filter { conversation in
            guard let text = self.searchText, text.count > 0 else { return true }
            return conversation.name.lowercased().contains(text.lowercased())
        }
    }
    func newState(state: ConversationState) {
        self.conversations = Array(state.conversationsByID.values)
        DispatchQueue.main.async {
            self.resultsCollectionView.reloadData()
        }
    }
    
    var searchText: String?
    func textDidChange(_ notification: Notification) {
        self.searchText = self.searchField.string
        self.resultsCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: self.resultsCollectionView.frame.size.width, height: 40)
    }
    
    public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredConversations.count
    }
    
    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "QuickLookCollectionViewItem"), for: indexPath) as! QuickLookCollectionViewItem
        let conversation = self.filteredConversations[indexPath.item]
        item.textField?.stringValue = conversation.name
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        collectionView.deselectItems(at: indexPaths)
        guard let indexPath = indexPaths.first else { return }
        let conversation = self.filteredConversations[indexPath.item]
        AppStore.shared.dispatch(AppActionz.selectedConversation(conversation.id))
    }
    
}
