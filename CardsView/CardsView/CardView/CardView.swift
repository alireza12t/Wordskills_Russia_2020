//
//  CardView.swift
//  CardsView
//
//  Created by ali on 9/21/20.
//

import UIKit


@IBDesignable
class CardView: UIView, UIGestureRecognizerDelegate {


    @IBOutlet var cardView: UIView!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var stateImageView: UIImageView!
    
    
    public var delegate: CardsViewDelegate?


    private var hateIcon: UIImage!
    private var likeIcon: UIImage!
    
    //MARK:- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        nibSetup()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
        nibSetup()
    }
    
    init(frame: CGRect = CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: 400), imageUrl: String, corner: CGFloat,  hateIcon: UIImage?, likeicon: UIImage?) {
        super.init(frame: frame)
        

        
        if let hate = hateIcon {
            self.hateIcon = hate
        }
        
        if let like = likeicon {
            self.likeIcon = like
        }
        self.cardImageView.layer.cornerRadius = corner
//        panGesture.delegate = self

        self.cardImageView.backgroundColor = .black
        
        self.cardImageView.contentMode = .scaleToFill
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        nibSetup()
        cardView?.prepareForInterfaceBuilder()
    }
    
    //MARK:- Lifecycle methods
    private func nibSetup() {
        
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupViews()
        addSubview(view)
        cardView = view
    }
    
 
    func loadViewFromNib() -> UIView? {
        
        let nibName = String(describing: CardView.self)
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func setupViews() {
        
    }
    
    func showLike(){
        self.stateImageView.image = likeIcon
        self.stateImageView.isHidden = false
    }
    
    
    func showHate(){
        self.stateImageView.image = hateIcon
        self.stateImageView.isHidden = false
    }
    
    
    @IBAction func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let card = sender.view
        let point = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        card?.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)
       switch sender.state {
        case .ended:
            if ((card?.center.x)!) > 400 {
                showLike()
                delegate?.didSwipeRight(self)
                UIView.animate(withDuration: 0.2) {
                    card?.center = CGPoint(x: centerOfParentContainer.x + point.x + 200, y: centerOfParentContainer.y + point.y + 75)
                    card?.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            }else if (card?.center.x)! < -65 {
                showHate()
                delegate?.didSwipeLeft(self)
                UIView.animate(withDuration: 0.2) {
                    card?.center = CGPoint(x: centerOfParentContainer.x + point.x - 200, y: centerOfParentContainer.y + point.y + 75)
                    card?.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            }
            UIView.animate(withDuration: 0.2) {
                card?.transform = .identity
                card?.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                self.layoutIfNeeded()
            }
        case .changed:
            let rotation = tan(point.x)
            card?.transform = CGAffineTransform(rotationAngle: rotation)

        default:
            break
        }
     }
}

