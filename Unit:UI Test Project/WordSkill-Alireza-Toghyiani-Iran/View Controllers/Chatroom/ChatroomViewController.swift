//
//  ChatroomViewController.swift
//  boonoob-ios-app
//
//  Created by ali on 8/21/20.
//  Copyright © 2020 Yves Songolo. All rights reserved.
//

import UIKit
import RxSwift
import IQKeyboardManagerSwift

class ChatroomViewController: UIViewController {
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var chatView: UIView!
    
    static let identifier = String(describing: ChatroomViewController.self)

    let chatViewController = ChatViewController()
    var messages = [Message]()
    var sender: Sender!
    var chatID: String!
    var APIDispposableMessages: Disposable!
    var chatName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = chatName
        createChatroomView()

        IQKeyboardManager.shared.enable = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    

    
    /// Required for the `MessageInputBar` to be visible
    override var canBecomeFirstResponder: Bool {
        return chatViewController.canBecomeFirstResponder
    }

    /// Required for the `MessageInputBar` to be visible
    override var inputAccessoryView: UIView? {
        return chatViewController.inputAccessoryView
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    func createChatroomView(){

        chatViewController.sender = sender
        chatViewController.chatID = self.chatID
        self.addChild(chatViewController)
        chatViewController.view.frame = chatView.bounds
        chatView.addSubview(chatViewController.view)
        chatViewController.didMove(toParent: self)
    }

    
    @IBAction func backButtonDidTap(_ sender: Any) {
        SegueHelper.popViewController(viewController: self)

    }
}

