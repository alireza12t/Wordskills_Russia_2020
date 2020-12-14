//
//  SignInViewController.swift
//  WordSkill-Alireza-Toghyiani-Iran
//
//  Created by ali on 9/18/20.
//  Copyright © 2020 ali. All rights reserved.
//

import UIKit
import Spring
import RxSwift

class SignInViewController: BaseViewController {
    
    @IBOutlet weak var emailTextFiled: DesignableTextField!
    @IBOutlet weak var passwordTextFiled: DesignableTextField!
    
    var textFields: [UITextField]!
    var APIDispposableLogin: Disposable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textFields = [emailTextFiled, passwordTextFiled]
        
        for i in 0 ..< textFields.count {
            textFields[i].tag = 2000 + i
            setupKeyboardDistance(textField: textFields[i])
        }
        
    }
    
    
    @IBAction func loginButtonDidTap(_ sender: Any) {
        guard let email = emailTextFiled.text , !email.isEmpty else {
            DialogueHelper.showStatusBarErrorMessage(errorMessageStr: "Enter your email")
            return
        }
        
        if !ValidationHelper.validateEmail(email) {
            DialogueHelper.showStatusBarErrorMessage(errorMessageStr: "Enter a valid Email")
        }
        
        guard let password = passwordTextFiled.text , !password.isEmpty else {
            DialogueHelper.showStatusBarErrorMessage(errorMessageStr: "Enter your password")
            return
        }
        
        APIDispposableLogin?.dispose()
        APIDispposableLogin = nil
        APIDispposableLogin = API.shared.login(email: email, password: password)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (response) in
                Log.i("login => onNext => \(response)")
                StoringData.token = "Bearer \(response.token)"
                DispatchQueue.main.async {
                    let vc = TabBarViewController.instantiateFromStoryboardName(storyboardName: .Main)
                    self.navigationController?.setViewControllers([vc], animated: true)
                }
                
                
            }, onError: { (error) in
                Log.e("login => onError => \(error)")
                DialogueHelper.showStatusBarErrorMessage(errorMessageStr: error.localizedDescription)
            })
        
        
    }
    
    
    @IBAction func registerButtonDidTap(_ sender: Any) {
        SegueHelper.popViewController(viewController: self)
    }
}
