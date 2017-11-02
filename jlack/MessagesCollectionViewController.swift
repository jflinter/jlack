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
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        AppStore.shared.subscribe(self)
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        AppStore.shared.unsubscribe(self)
    }
    
    func newState(state: AppState) {
        // TODO this is incorrect; it should be messages in the current conversation
        self.messages = state.messages
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: self.collectionView.frame.size.width, height: 100)
    }
    
    public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }

    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MessageCollectionViewItem"), for: indexPath) as! MessageCollectionViewItem
        item.textField?.stringValue = self.messages[indexPath.item].text
        return item
    }
    
}
