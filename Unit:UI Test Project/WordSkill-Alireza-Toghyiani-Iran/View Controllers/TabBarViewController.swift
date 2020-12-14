//
//  TabBarViewController.swift
//  WordSkill-Alireza-Toghyiani-Iran
//
//  Created by ali on 9/19/20.
//  Copyright © 2020 ali. All rights reserved.
//

import UIKit
import RxSwift
class TabBarViewController: UITabBarController {
    
    var APIDispposableUserData: Disposable!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndex = 0

        tabBar.unselectedItemTintColor = .lightGray
        tabBar.tintColor = .brandOrange
                
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .brandBackground
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserData()
        setupTabBarItemImages()
        setupTabBarItemFonts()
    }
    
    
    func getUserData() {
        APIDispposableUserData?.dispose()
        APIDispposableUserData = nil
        APIDispposableUserData = API.shared.userData()
                .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(onNext: { (response) in
                    Log.i("userData => onNext => \(response)")
                    DispatchQueue.main.async {
                        if let user = response.first {
                            StoringData.email = user.email
                        StoringData.name = user.firstName + " " + user.lastName
                            StoringData.avatarID = user.avatarId ?? ""
                        }
                    }

                }, onError: { (error) in
                    Log.e("userData => onError => \(error)")
                    DialogueHelper.showStatusBarErrorMessage(errorMessageStr: error.localizedDescription)
                })
    }
    
    func setupTabBarItemImages() {

        setTabBarItem(
            index: 0,
            title: "Home",
            image: UIImage(named: "Home Deactive")!,
            selectedImage: UIImage(named: "Home Active")!)

        setTabBarItem(
            index: 1,
            title: "Selection",
            image: UIImage(named: "Selection Deactive")!,
            selectedImage: UIImage(named: "Selection Active")!)

        setTabBarItem(
            index: 2,
            title: "Collections",
            image: UIImage(named: "Collections Deactive")!,
            selectedImage: UIImage(named: "Collections Active")!)

        setTabBarItem(
            index: 3,
            title: "Profile",
            image: UIImage(named: "Profile Deactive")!,
            selectedImage: UIImage(named: "Profile Active")!)

        
    }



    func setTabBarItem(index: Int, title: String, image: UIImage, selectedImage: UIImage) {
        tabBar.items![index].title = title
        tabBar.items![index].image = image.withRenderingMode(.alwaysTemplate)
        tabBar.items![index].selectedImage = selectedImage.withRenderingMode(.alwaysTemplate)
    }

    func setupTabBarItemFonts() {
        for item in tabBar.items! {
            let alignment = NSMutableParagraphStyle()
            alignment.alignment = .center
            let attribues = [
                NSAttributedString.Key.font: UIFont.SFProText_Medium(size: 10),
                NSAttributedString.Key.paragraphStyle: alignment,
                NSAttributedString.Key.strikethroughColor: UIColor.darkGray
            ]
            item.setTitleTextAttributes(attribues, for: UIControl.State())
            item.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: 1)
        }
    }


}






