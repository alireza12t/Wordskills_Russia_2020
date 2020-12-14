

import UIKit
import SwiftUI

extension UIViewController {
    /**
     This variable returns the name of a storyboard that contains a specific view controller.
     */
    class var storyboardID: String {
        print("\(self)")
        return "\(self)"
    }
    /**
     This function returns a view controller from a storyboard.
     - parameters storyboardName: it's a struct that holds all storyboard names that are included in the project.
     - Returns: UIViewController
     */
    static func instantiateFromStoryboardName(storyboardName: StoryboardName) -> Self {
        return storyboardName.viewController(viewControllerClass: self)
    }
    /**
     This function dismisses keyboard when user taps around the application's main view
     */
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    /**
     This function adds another view controller inside a specific view controller as a child view.
     - parameters childViewController: view controller we want to add.
     - parameters view : the view that we want to act as parent.
     */
    func addChildViewControllerWithView(_ childViewController: UIViewController, toView view: UIView? = nil) {
        let view: UIView = view ?? self.view
        childViewController.removeFromParent()
        childViewController.willMove(toParent: self)
        addChild(childViewController)
        childViewController.didMove(toParent: self)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(childViewController.view)
        view.addConstraints([
            NSLayoutConstraint(item: childViewController.view!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: childViewController.view!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: childViewController.view!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: childViewController.view!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        view.layoutIfNeeded()
    }
    /**
     This function removes a child view controller from its parent.
     - parameter childViewController: the said child that we want to remove from its parent.
     */
    func removeChildViewController(_ childViewController: UIViewController) {
        childViewController.removeFromParent()
        childViewController.willMove(toParent: nil)
        childViewController.removeFromParent()
        childViewController.didMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        view.layoutIfNeeded()
    }


}



