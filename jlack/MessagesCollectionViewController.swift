//
//  MessagesCollectionViewController.swift
//  jlack
//
//  Created by Jack Flintermann on 10/31/17.
//  Copyright © 2017 Jack Flintermann. All rights reserved.
//

import Cocoa
import ReSwift

class MessagesCollectionViewController: NSViewController, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout, StoreSubscriber {
   
    @IBOutlet weak var collectionView: NSCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    struct ConversationAndMessages: Equatable {
        static func ==(lhs: MessagesCollectionViewController.ConversationAndMessages, rhs: MessagesCollectionViewController.ConversationAndMessages) -> Bool {
            return lhs.selectedConversation == rhs.selectedConversation &&
                lhs.messages == rhs.messages &&
                lhs.pendingMessages == rhs.pendingMessages
        }
        
        var totalCount: Int {
            return self.messages.count + self.pendingMessages.count
        }
        
        func message(atIndex index: Int) -> MessageProtocol? {
            if index < self.messages.count {
                return self.messages[index]
            }
            return self.pendingMessages[index - self.messages.count]
        }
        
        let selectedConversation: Conversation
        let messages: [Message]
        let pendingMessages: [PendingMessage]
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        AppStore.shared.subscribe(self) { subscription in
            return subscription.select { state in
                guard let conversation = state.conversations.selectedConversation else { return nil }
                let messages = state.messages.messages(forConversationId: conversation.id)
                let pending = state.messages.pendingMessages(forConversationId: conversation.id)
                return ConversationAndMessages(
                    selectedConversation: conversation,
                    messages: messages,
                    pendingMessages: pending
                )
            }.skipRepeats(==)
        }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        AppStore.shared.unsubscribe(self)
    }
    
    private var conversationAndMessages: ConversationAndMessages? = nil
    func newState(state: ConversationAndMessages?) {
        self.conversationAndMessages = state
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: self.collectionView.frame.size.width, height: 100)
    }
    
    public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.conversationAndMessages?.totalCount ?? 0
    }

    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MessageCollectionViewItem"), for: indexPath) as! MessageCollectionViewItem
        if let message = self.conversationAndMessages?.message(atIndex: indexPath.item) {
            item.textField?.stringValue = message.text
        }
        return item
    }
    
}
