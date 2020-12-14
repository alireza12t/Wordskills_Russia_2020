

import UIKit

class SegueHelper: NSObject {
    
    static var appNavigationController: UINavigationController!
    /**
        This function pops a view controller inside navigation controller from a source view controller.
        - parameter sourceViewController: a view controller that wants to pop to source view controller.
        - parameter destinationViewController: a view controller that we want to display to user.
        - parameter navigationController: our currenet navigation controller that's going to handle the process of poping a view controller.
        - parameter timingFunction: defines how long we want our animation to take.
        - parameter animationType: defines the type of our popping animation.
        - parameter animationSubType: define the sub type of our popping animation.
    */
    class func popViewControllerWithCustomAnimation(sourceViewController: UIViewController, destinationViewController: UIViewController, navigationController: UINavigationController, timingFunction: CAMediaTimingFunctionName, animationType: CATransitionType, animationSubtype: CATransitionSubtype) {
        print("sourceViewController => \(sourceViewController.restorationIdentifier ?? "Nil") ,destinationViewController => \(destinationViewController.restorationIdentifier ?? "Nil")")

        sourceViewController.navigationController?.popToViewController(destinationViewController, animated: true)
       
    }
    /**
       This function pushes a view controller on another view controller using the existing navigation controller in our hierchy
       - parameter sourceViewController: a view controller that we want to push the new view controller on.
       - parameter destinationViewController: a view controller that we want to show the user.
    */
    class func pushViewController(sourceViewController: UIViewController, destinationViewController: UIViewController) {
        print("sourceViewController => \(sourceViewController.restorationIdentifier ?? "Nil") ,destinationViewController => \(destinationViewController.restorationIdentifier ?? "Nil")")
        
        
        sourceViewController.navigationController?.pushViewController(destinationViewController, animated: true)
       
    }
    /**
           This function pops a view controller inside navigation controller from a source view controller.
           - parameter sourceViewController: a view controller that wants to pop to source view controller.
           - parameter destinationViewController: a view controller that we want to display to user.
    */
    class func popViewController(sourceViewController: UIViewController, destinationViewController: UIViewController) {
        print("sourceViewController => \(sourceViewController.restorationIdentifier ?? "Nil") ,destinationViewController => \(destinationViewController.restorationIdentifier ?? "Nil")")

        sourceViewController.navigationController?.popToViewController(destinationViewController, animated: true)
       
    }
    /**
          This function pushes a view controller on another view controller using the existing navigation controller in our hierchy without any animation.
          - parameter sourceViewController: a view controller that we want to push the new view controller on.
          - parameter destinationViewController: a view controller that we want to show the user.
    */
    class func pushViewControllerWithoutAnimation(sourceViewController: UIViewController, destinationViewController: UIViewController) {
        print("sourceViewController => \(sourceViewController) ,destinationViewController => \(destinationViewController)")

        sourceViewController.navigationController?.pushViewController(destinationViewController, animated: false)
    }
   /**
         This function presents a view controller on another view controller.
         - parameter sourceViewController: a view controller that we want to present the new view controller on.
         - parameter destinationViewController: a view controller that we want to show the user.
   */
    class func presentViewController(sourceViewController: UIViewController, destinationViewController: UIViewController) {
        print("sourceViewController => \(sourceViewController) ,destinationViewController => \(destinationViewController)")
        sourceViewController.present(destinationViewController, animated: true, completion: nil)
    }
    
    
    
    
    /**
        This function pops a view controller inside navigation controller from a source view controller.
        - parameter viewController: a view controller that we want to display to user.
      */
    class func popViewController(viewController: UIViewController) {
        print("viewController => \(viewController)")

        viewController.navigationController?.popViewController(animated: true)
    }

    class func pushViewControllerWithAnimation(sourceViewController: UIViewController, destinationViewController: UIViewController){

        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        sourceViewController.navigationController?.view.layer.add(transition, forKey: kCATransition)
        sourceViewController.navigationController?.pushViewController(destinationViewController, animated: false)
    }

    class func popViewControllerWithAnimation(viewController: UIViewController){

        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromBottom
        viewController.navigationController?.view.layer.add(transition, forKey:kCATransition)
        let _ = viewController.navigationController?.popViewController(animated: false)
    }
}
