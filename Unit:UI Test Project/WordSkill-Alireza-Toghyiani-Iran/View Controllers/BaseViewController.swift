//
//  BaseViewController.swift
//  WordSkill-Alireza-Toghyiani-Iran
//
//  Created by ali on 9/18/20.
//  Copyright © 2020 ali. All rights reserved.
//

import BRYXBanner
import UIKit
import IQKeyboardManagerSwift
import RxSwift
import Kingfisher

class BaseViewController: UIViewController {
    
    
    let today = Date()
    
    let network: NetworkManager = NetworkManager.sharedInstance
    
    func startCheckingNetwork(){
        
        network.reachability.whenUnreachable = { _ in
            self.notifUserAboutNetwork()
        }
        
        NetworkManager.isUnreachable { _ in
            Log.i("Netowk Lost")
            DispatchQueue.main.async {
                self.notifUserAboutNetwork()
            }
            
        }
    }
    
    var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    var initialInteractivePopGestureRecognizerDelegate: UIGestureRecognizerDelegate?
    var textfieldDistances = [Int:CGFloat]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        navigationController?.view.semanticContentAttribute = .forceRightToLeft
        navigationController?.navigationBar.semanticContentAttribute = .forceRightToLeft
        navigationController?.isNavigationBarHidden = true
        
        
        setupViews()
        
        startCheckingNetwork()
        
        initialInteractivePopGestureRecognizerDelegate = self.navigationController?.interactivePopGestureRecognizer?.delegate
        
    }
    
    
    func listenToNotificationCenterObservers() { }
    func removeNotificationCenterObservers() { }
    
    func addKeyboardHandleGesture(){
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard)))
        setupViews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureViews()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        listenToNotificationCenterObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = initialInteractivePopGestureRecognizerDelegate
        removeNotificationCenterObservers()
    }
    
    func setupViews(){
        
    }
    func configureViews(){
    }
    
    
    func setupKeyboardDistance(textField:UIView) {
        
        let distance = self.view.frame.maxY - textField.frame.maxY + textField.frame.height
        StoringData.keyboardDistances = [String(describing: textField.tag):distance]
        if distance < 500 {
            IQKeyboardManager.shared.keyboardDistanceFromTextField = distance
        }else{
            IQKeyboardManager.shared.keyboardDistanceFromTextField = 450
        }
        
    }
    
    
    
    func setupKeyboardDistanceManualy(distance:CGFloat) {
        IQKeyboardManager.shared.keyboardDistanceFromTextField = distance
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
        for textField in self.view.subviews where textField is UITextField {
            textField.resignFirstResponder()
        }
    }
    
    func doShakeFunction(){
        
    }
    
    func setupImageView(imageView: UIImageView, url: String, placeHolderImage: UIImage = UIImage(named: "movie")!) {
        
        imageView.kf.indicatorType = .activity
        if let url = URL(string: ImageBaseURL + url) {
            imageView.kf.setImage(with: url,placeholder: placeHolderImage , options: .some(.init(arrayLiteral: .cacheOriginalImage)))
        }
        
    }
    
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            UIView.animate(withDuration: 0.4) {
                self.doShakeFunction()
            }
        }
    }
    
    func notifUserAboutNetwork(){
        DispatchQueue.main.async {
            DialogueHelper.showStatusBarErrorMessage(errorMessageStr: "لطفا اتصال خود به اینترنت را بررسی کنید.")
        }
    }
    
    
    

    
    
    
}
