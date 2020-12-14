import BRYXBanner
import Foundation

class DialogueHelper {

    private static var lastDialogue: Banner!
     /**
         This function shows an error message on top half of the screen.
         - parameter errorMessageStr: error message that we want to display.
         - parameter color: color of status bar (default is brandOrange(MCI's orange))
     */
    static func showStatusBarErrorMessage(errorMessageStr: String, _ color: UIColor = .systemOrange)  {
        DispatchQueue.main.async {
            let banner = Banner(title: "", subtitle: errorMessageStr, image: nil, backgroundColor: color)
            dismissLastDialogue()
            DialogueHelper.lastDialogue = banner
            

            banner.titleLabel.font = .SFProText_Bold(size: 12)
            banner.detailLabel.font = .SFProText(size: 14)
            
            banner.titleLabel.textAlignment = .center
            banner.detailLabel.textAlignment = .center

            banner.preferredStatusBarStyle = .lightContent
            banner.dismissesOnTap = true
            banner.show(duration: 3.0)
        }
    }
    
    private class func dismissLastDialogue(){
        if let banner = DialogueHelper.lastDialogue {
            banner.dismiss()
        }
    }
    
    /**
            This function shows a connectivty issue message on top half of the screen.
            - parameter errorMessageStr: error message that we want to display.
            - parameter color: color of status bar (default is brandOrange(MCI's orange))
        */
    static func showNetworkErrorBanner() {
        DispatchQueue.main.async {
            let banner = Banner(title: "Check your network connection", image: UIImage(named: "NetworkProblem"), backgroundColor: .systemBlue)
            dismissLastDialogue()
            DialogueHelper.lastDialogue = banner

            banner.titleLabel.font = .SFProText_Bold(size: 12)
            banner.detailLabel.font = .SFProText(size: 14)

            banner.titleLabel.textAlignment = .center

            banner.detailLabel.textAlignment = .center

            banner.dismissesOnTap = true
            banner.show(duration: 3.0)
        }
    }
}
