//
//  MessageViewController.swift
//  boonoob-ios-app
//
//  Created by ali on 8/20/20.
//  Copyright © 2020 Yves Songolo. All rights reserved.
//

import UIKit
import MessageKit
import RxSwift
import Kingfisher
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    
    
    var chatID: String!
    var sender: Sender!
    let outgoingAvatarOverlap: CGFloat = 17.5
    var messages = [Message]()
    var APIDispposableSendMessage: Disposable!
    var APIDispposableMessages: Disposable!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMessageCollectiionView()
        configuureMessageInputBar()
        messagesCollectionView.backgroundColor = .brandBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.messagesCollectionView.scrollToBottom(animated: false)
        getMessages()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messagesCollectionView.contentInset.bottom = messageInputBar.frame.height
        messagesCollectionView.scrollIndicatorInsets.bottom = messageInputBar.frame.height
    }
    
    func showErrorBanner(errorTitle: String){
        DialogueHelper.showStatusBarErrorMessage(errorMessageStr: errorTitle)
    }
    
    func getMessages(){
        APIDispposableMessages?.dispose()
        APIDispposableMessages = nil
        APIDispposableMessages = API.shared.getMessages(chatID: chatID)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (response) in
                Log.i("lastWatch => onNext => \(response)")
                DispatchQueue.main.async {
                    self.messages = response
                    self.messagesCollectionView.reloadData()
                }

            }, onError: { (error) in
                Log.e("lastWatch => onError => \(error)")
                DialogueHelper.showStatusBarErrorMessage(errorMessageStr: error.localizedDescription)
            })
    }
    

    func sendMessage(text: String) {
        APIDispposableSendMessage?.dispose()
        APIDispposableSendMessage = nil
        APIDispposableSendMessage = API.shared.sendMessage(chatID: self.chatID, message: text)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (response) in
                Log.i("lastWatch => onNext => \(response)")
                DispatchQueue.main.async {
                    self.getMessages()
                    self.messageInputBar.sendButton.stopAnimating()
                    self.messageInputBar.inputTextView.placeholder = "Write a message ..."
                }

            }, onError: { (error) in
                Log.e("lastWatch => onError => \(error)")
                DialogueHelper.showStatusBarErrorMessage(errorMessageStr: error.localizedDescription)
                self.messageInputBar.sendButton.stopAnimating()
                self.messageInputBar.inputTextView.placeholder = "Write a message ..."
            })
        
        }
    
    
    
    func configureMessageCollectiionView(){
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
    }
    
    func configuureMessageInputBar(){
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = .black
        messageInputBar.inputTextView.placeholder = "Write a message ..."
        messageInputBar.backgroundColor = .brandBackground
        messageInputBar.sendButton.setTitleColor(.black, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            UIColor.black.withAlphaComponent(0.3),
            for: .highlighted
        )
        messageInputBar.sendButton.setTitle("", for: .normal)
        messageInputBar.sendButton.setImage(UIImage(named: "send"), for: .normal)
        
        

    }
    

    
    func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
        return indexPath.section % 3 == 0 && !isPreviousMessageSameSender(at: indexPath)
    }
    
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return messages[indexPath.section].authorAvatarId  == messages[indexPath.section - 1].authorAvatarId
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < (messages.count) else { return false }
        return messages[indexPath.section].authorAvatarId == messages[indexPath.section + 1].authorAvatarId
    }
    
    

    
    
    func isLastSectionVisible() -> Bool {
        
        guard !messages.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
}


extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        let chatroomMessage = messages[indexPath.section]
        
        let senderID = (chatroomMessage.authorAvatarId ?? "") + (chatroomMessage.authorName ?? "")
        let senderName = chatroomMessage.authorName ?? ""
        let sender = Sender(senderId: senderID, displayName: senderName, avatarID: senderID)
        
        let message = MessageKit(text: chatroomMessage.text, user: sender, messageId: "\(chatroomMessage.messageId)", date: chatroomMessage.creationDateTime.getDate(format: "yyyy-MM-dd"))

        return message
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isTimeLabelVisible(at: indexPath) {
            return NSAttributedString(string: message.sentDate.toiMessagesString(), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}

extension ChatViewController: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isTimeLabelVisible(at: indexPath) {
            return 18
        }
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isFromCurrentSender(message: message) {
            return !isPreviousMessageSameSender(at: indexPath) ? 20 : 0
        } else {
            return !isPreviousMessageSameSender(at: indexPath) ? (20 + outgoingAvatarOverlap) : 0
        }
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return (!isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message)) ? 16 : 0
    }
}

extension ChatViewController: MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .darkText
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        switch detector {
        case .hashtag, .mention: return [.foregroundColor: UIColor.blue]
        default: return MessageLabel.defaultAttributes
        }
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation, .mention, .hashtag]
    }
    
    // MARK: - All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .brandOrange : UIColor(red: 46/255, green: 43/255, blue: 42/255, alpha: 1)
    }
    
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        var corners: UIRectCorner = []
        
        if isFromCurrentSender(message: message) {
            corners.formUnion(.topLeft)
            corners.formUnion(.bottomLeft)
            if !isPreviousMessageSameSender(at: indexPath) {
                corners.formUnion(.topRight)
            }
            if !isNextMessageSameSender(at: indexPath) {
                corners.formUnion(.bottomRight)
            }
        } else {
            corners.formUnion(.topRight)
            corners.formUnion(.bottomRight)
            if !isPreviousMessageSameSender(at: indexPath) {
                corners.formUnion(.topLeft)
            }
            if !isNextMessageSameSender(at: indexPath) {
                corners.formUnion(.bottomLeft)
            }
        }
        
        return .custom { view in
            let radius: CGFloat = 16
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            view.layer.mask = mask
        }
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let itemData = messages[indexPath.section]
        let kingfisherOption: [KingfisherOptionsInfoItem] = [.fromMemoryCacheOrRefresh, .keepCurrentImageWhileLoading]

        avatarView.isHidden = isNextMessageSameSender(at: indexPath)
        avatarView.layer.borderWidth = 2
        
         
        let senderImageURL = ImageBaseURL +  (itemData.authorAvatarId ?? "")
            avatarView.kf.setImage(with: URL(string: senderImageURL), placeholder: UIImage(systemName: "person.fill")!, options: kingfisherOption)

        
    }
}



extension ChatViewController: InputBarAccessoryViewDelegate {
    
    @objc
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        processInputBar(messageInputBar)
    }
    
    func processInputBar(_ inputBar: InputBarAccessoryView) {
        // Here we can parse for which substrings were autocompleted
        let attributedText = inputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
            
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
        }
        
        let components = inputBar.inputTextView.components
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        // Send button activity animation
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        // Resign first responder for iPad split view
        inputBar.inputTextView.resignFirstResponder()
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                self?.insertMessages(components)
            }
        }
    }
    
    private func insertMessages(_ data: [Any]) {
        for component in data {
            if let str = component as? String {
                if str.isEmpty {
                    DialogueHelper.showStatusBarErrorMessage(errorMessageStr: "Please enter your message")
                } else {
                sendMessage(text: str)
                }
            }
        }
    }
}
