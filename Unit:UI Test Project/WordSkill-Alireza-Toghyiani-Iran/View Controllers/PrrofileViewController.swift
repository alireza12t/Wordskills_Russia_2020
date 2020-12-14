//
//  PrrofileViewController.swift
//  WordSkill-Alireza-Toghyiani-Iran
//
//  Created by ali on 9/19/20.
//  Copyright © 2020 ali. All rights reserved.
//

import UIKit
import Spring
import RxSwift

class PrrofileViewController: BaseViewController {

    @IBOutlet weak var profileImage: DesignableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    var APIDispposableUserData: Disposable!
    var APIDispposableUpdateAvatar: Disposable!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserData()
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
                        self.emailLabel.text = user.email
                        self.nameLabel.text = user.firstName + " " + user.lastName
                        
                            self.setupImageView(imageView: self.profileImage, url: user.avatarId ?? "", placeHolderImage: UIImage(systemName: "person.fill")!)
                        }
                    }

                }, onError: { (error) in
                    Log.e("userData => onError => \(error)")
                    DialogueHelper.showStatusBarErrorMessage(errorMessageStr: error.localizedDescription)
                })
    }
    
    @IBAction func editButtonDidTap(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
    }
    

    @IBAction func logOutButtonDidTap(_ sender: Any) {
        StoringData.token = ""
        self.navigationController?.setViewControllers([SignInViewController.instantiateFromStoryboardName(storyboardName: .Main)], animated: true)
    }
}


extension PrrofileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage

        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            newImage = UIImage(systemName: "person.fill")!
        }
        
        
        APIDispposableUpdateAvatar?.dispose()
        APIDispposableUpdateAvatar = nil
        APIDispposableUpdateAvatar = API.shared.uploadAvatar(image: newImage)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (response) in
                Log.i("userData => onNext => \(response)")
                DispatchQueue.main.async {
                    self.profileImage.image = newImage
                }

            }, onError: { (error) in
                Log.e("userData => onError => \(error)")
                DialogueHelper.showStatusBarErrorMessage(errorMessageStr: error.localizedDescription)
                DispatchQueue.main.async {
                    self.profileImage.image = UIImage(systemName: "person.fill")!
                }
            })

        dismiss(animated: true)
    }
}
