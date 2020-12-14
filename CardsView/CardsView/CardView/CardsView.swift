//
//  CardView.swift
//  CardsView
//
//  Created by ali on 9/21/20.
//

import UIKit
//import Kingfisher

protocol CardsViewDelegate {
    func didSwipeLeft(_ sender: CardView)
    func didSwipeRight(_ sender: CardView)
    func didImagesEnded(_ sender: CardsView)
}



@IBDesignable
class CardsView: UIView {
    
    @IBOutlet var cardsView: UIView!
    @IBOutlet weak var cardImageView: UIImageView!

    
    public var currentCard: Card = Card(imageUrl: "", cornerRadius: 10)
    

    public var delegate: CardsViewDelegate?
        
    private var imageUrls: [Card] = []
    private var remaining: [Card] = []
    public var remainingCards: [Card] {
        get {
            if self.remaining.isEmpty {
                self.didEndImages()
            }
            return self.remaining
        }
    }

    private var emptyIcon: UIImage = UIImage(named: "EmptyList")!
    
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
    
    init(frame: CGRect = CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: 420), imageUrls: [String], corner: CGFloat,  hateIcon: UIImage =  UIImage(named: "Hate")!, likeicon: UIImage = UIImage(named: "Like")!) {
        super.init(frame: frame)
        
        self.imageUrls = imageUrls.map({ (cardImageUrl) -> Card in
            Card(imageUrl: cardImageUrl, cornerRadius: corner)
        })
        
        if self.imageUrls.isEmpty {
            self.didEndImages()
        }
        
        for image in imageUrls {
            let card = CardView(imageUrl: image, corner: corner, hateIcon: hateIcon, likeicon: likeicon)
            card.delegate = self.delegate
            self.addSubview(card)
        }
        
        
        self.cardImageView.layer.cornerRadius = corner
        
        self.cardImageView.backgroundColor = .clear
        
        self.cardImageView.contentMode = .scaleToFill
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        nibSetup()
        cardsView?.prepareForInterfaceBuilder()
    }
    
    //MARK:- Lifecycle methods
    private func nibSetup() {
        
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupViews()
        addSubview(view)
        cardsView = view
    }
    
    func loadViewFromNib() -> UIView? {
        
        let nibName = String(describing: CardsView.self)
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func setupViews() {
        
    }
    
    
    
}


//MARK: - Public functions
extension CardsView {
    public func swipeRight(){
        
    }
    
    public func swipeLeft(){
        
    }
    
}




//MARK: - Delegate functions
extension CardsView {
    
    private func didEndImages(){
        self.cardImageView.image = emptyIcon
        self.cardImageView.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        self.cardImageView.contentMode = .center

        delegate?.didImagesEnded(self)
    }
}
