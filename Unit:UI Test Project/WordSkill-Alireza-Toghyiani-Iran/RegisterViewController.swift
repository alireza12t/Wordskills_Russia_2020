//
//  ViewController.swift
//  WordSkill-Alireza-Toghyiani-Iran
//
//  Created by ali on 9/18/20.
//  Copyright © 2020 ali. All rights reserved.
//

import UIKit
import Spring
import RxSwift

class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var nameTextFiled: DesignableTextField!
    @IBOutlet weak var surNameTextFiled: DesignableTextField!
    @IBOutlet weak var emailTextFiled: DesignableTextField!
    @IBOutlet weak var passwordTextFiled: DesignableTextField!
    @IBOutlet weak var confirmPasswordTextFiled: DesignableTextField!

    var textFields: [UITextField]!
    var APIDispposableRegister: Disposable!
    var APIDispposableLogin: Disposable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textFields = [emailTextFiled, nameTextFiled, surNameTextFiled, passwordTextFiled, confirmPasswordTextFiled]
        
        for i in 0 ..< textFields.count {
            textFields[i].tag = 1000 + i
            setupKeyboardDistance(textField: textFields[i])
        }
        
    }

    @IBAction func registerButtonDidTap(_ sender: Any) {
        guard let name = nameTextFiled.text , !name.isEmpty else {
            DialogueHelper.showStatusBarErrorMessage(errorMessageStr: "Enter your name")
            return
        }
        
        guard let surName = surNameTextFiled.text , !surName.isEmpty else {
            DialogueHelper.showStatusBarErrorMessage(errorMessageStr: "Enter your surname")
            return
        }
        
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
        
        #warning("password Validation")
//        guard let password = nameTextFiled.text , !name.isEmpty {
//            DialogueHelper.showStatusBarErrorMessage(errorMessageStr: "Enter your name")
//        }
        
        guard let confirmPassword = confirmPasswordTextFiled.text , !confirmPassword.isEmpty else {
            DialogueHelper.showStatusBarErrorMessage(errorMessageStr: "Enter your Confirm Password")
            return
        }
        
        if password != confirmPassword {
            DialogueHelper.showStatusBarErrorMessage(errorMessageStr: "Confirm Password doesn't match the password")
        }
        
        
        #warning("Fix register model")
        APIDispposableRegister?.dispose()
        APIDispposableRegister = nil
        APIDispposableRegister = API.shared.register(email: email, password: password, firstName: name, lastName: surName)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (response) in
                Log.i("register => onNext => \(response)")
                
                self.APIDispposableLogin?.dispose()
                self.APIDispposableLogin = nil
                self.APIDispposableLogin = API.shared.login(email: email, password: password)
                    .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                    .subscribe(onNext: { (response) in
                        Log.i("login => onNext => \(response)")
                        StoringData.token = "\(response.token)"
                        DispatchQueue.main.async {
                            let vc = TabBarViewController.instantiateFromStoryboardName(storyboardName: .Main)
                            self.navigationController?.setViewControllers([vc], animated: true)
                        }
                        
                        
                    }, onError: { (error) in
                        Log.e("login => onError => \(error)")
                        DialogueHelper.showStatusBarErrorMessage(errorMessageStr: error.localizedDescription)
                    })
                
            }, onError: { (error) in
                Log.e("register => onError => \(error)")
                DialogueHelper.showStatusBarErrorMessage(errorMessageStr: error.localizedDescription)
            })
        
        
    }
    
    @IBAction func signInButtonDidTap(_ sender: Any) {
        SegueHelper.pushViewController(sourceViewController: self, destinationViewController: SignInViewController.instantiateFromStoryboardName(storyboardName: .Main))
    }
}

