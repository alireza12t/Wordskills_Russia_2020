
import UIKit
import Spring



extension UIView {

    
    /// This returns all subviews of View controller
    var allSubViews : [UIView] {

        var array = [self.subviews].flatMap {$0}

        array.forEach { array.append(contentsOf: $0.allSubViews) }

        return array
    }

    /**
    This function is for rounding desired corners of a certain view.
     - parameter corners: corners that we want to make round.
     - parameter radius: The intensity of corners.
    */
    func round(corners: CACornerMask, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
    }
    
    /**
       This function adds a standard shadow based on app's design language to a certain view.
    */
    func dropNormalShadow() {

        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 2
    }
    
    func dropLeftShadow() {
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: -2 , height: 0)
        layer.shadowRadius = 2
    }
    
    /**
       This function adds a standard shadow based on app's design language to top  of a certatin view.
    */
    func dropTopShadow() {

        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0 , height: -2)
        layer.shadowRadius = 2
    }
    
    /**
       This function adds a standard shadow based on app's design language to bottom  of a certatin view.
    */
    func dropBottomShadow() {

        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0 , height: 2)
        layer.shadowRadius = 2
    }
    
    
    /**
          This function removes a view's shadow.
    */
    func removeShadow() {
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOpacity = 0
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 0
    }

    
    /**
       This function makes a circle depending on view's height.(width should be equal to height)
    */
    func makeRound() {
        layer.cornerRadius = layer.frame.height / 2
        layer.masksToBounds = true
    }
    /**
        This function draws a border in top edge of a certain view
        - parameter borderColor: color of the said border
        - parameter borderHeight: thickness of the said border
    */
    func addTopBorder(borderColor: UIColor, borderHeight: CGFloat) {
        let border = CALayer()
        border.backgroundColor = borderColor.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: borderHeight)
        self.layer.addSublayer(border)
    }
    /**
        This function adds the required constraints to centralize a view inside another view
        - parameter subview: the view that we wanna put in center
        - parameter equalSize: If true, the size of 2 views will be equal.
    */
    func constrainCentered(_ subview: UIView, equalSize: Bool = true)  {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let verticalContraint = NSLayoutConstraint(
            item: subview,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0)
        
        let horizontalContraint = NSLayoutConstraint(
            item: subview,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0)
        
        let heightContraint = NSLayoutConstraint(
            item: subview,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: subview.frame.height)
        
        let widthContraint = NSLayoutConstraint(
            item: subview,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: subview.frame.width)

        if equalSize{
            addConstraints([
                horizontalContraint,
                verticalContraint,
                heightContraint,
                widthContraint])
        } else {
            addConstraints([
                horizontalContraint,
                verticalContraint
            ])
        }
        
    }
    /**
          This function adds the required constraints to make a subview appear in the same exact coordinates of its parent view. it adds trailing,leading,top and bottom constraints in order to achieve this goal.
          - parameter subview: the view that we want to put in the same coordinates.
    */
    func constrainToEdges(_ subview: UIView) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let topContraint = NSLayoutConstraint(
            item: subview,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1.0,
            constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(
            item: subview,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0)
        
        let leadingContraint = NSLayoutConstraint(
            item: subview,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0)
        
        let trailingContraint = NSLayoutConstraint(
            item: subview,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 0)
        
        addConstraints([
            topContraint,
            bottomConstraint,
            leadingContraint,
            trailingContraint])
    }
    /**
        This function loads a view from its nib.
        - parameters nibName: name of the nib that belongs to the view we want to load.
        - Returns: a specific class that is converted to nib's original class.
    */
    class func loadFromNib<T>(withName nibName: String) -> T? {
        let nib  = UINib.init(nibName: nibName, bundle: nil)
        let nibObjects = nib.instantiate(withOwner: nil, options: nil)
        for object in nibObjects {
            if let result = object as? T {
                return result
            }
        }
        return nil
    }


    @discardableResult
    func addLineDashedStroke(pattern: [NSNumber] = [10, 10], radius: CGFloat, color: CGColor) -> CALayer {
        let borderLayer = CAShapeLayer()

        borderLayer.strokeColor = color
        borderLayer.lineDashPattern = pattern
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath

        layer.addSublayer(borderLayer)
        return borderLayer
    }
}

