//
//  Messages.swift
//  SquadUpAustin
//
//  Created by Sean Chen on 11/20/20.
//  Copyright © 2020 Group 4. All rights reserved.
//

import Foundation
import MessageKit
import Firebase
import FirebaseAuth

class Message: MessageType {
    
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    init(sender: Sender, messageId: String, date: Date, kind: MessageKind) {
        self.sender = sender
        self.messageId = messageId
        self.sentDate = date
        self.kind = kind
    }
}

class Sender: SenderType {
    
    var senderId: String
    var displayName: String
    
    init(id: String, displayName: String) {
        self.senderId = id
        self.displayName = displayName
    }
}

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    var selectedGame: Game?
    var messages: [Message] = []
    let db = Firestore.firestore()
    
    func currentSender() -> SenderType {
        return Sender(id: Auth.auth().currentUser!.uid, displayName: Auth.auth().currentUser!.displayName!)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        //load messages w/ listener
        db.collection("games").document(selectedGame!.id!).collection("chat")
            .order(by: "date")
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        let sender = Sender(id: diff.document.data()["id"]! as! String, displayName: diff.document.data()["displayName"]! as! String)
                        let messageID = diff.document.documentID
                        let timestamp = diff.document.data()["date"]! as! Timestamp
                        let date = timestamp.dateValue()
                        let text = NSAttributedString(string: diff.document.data()["body"]! as! String)
                        let newMessage = Message(sender: sender, messageId: messageID, date: date, kind: .attributedText(text))
                        self.messages.append(newMessage)
                        self.messagesCollectionView.reloadData()
                        DispatchQueue.main.async {
                            self.messagesCollectionView.scrollToBottom(animated: true)
                        }
                    }
                }
            }
    }
}
