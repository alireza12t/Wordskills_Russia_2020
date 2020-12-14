//
//  ViewController.swift
//  CardsView
//
//  Created by ali on 9/21/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cardsView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cards = CardsView(imageUrls: ["", ""], corner: 15)
        cards.delegate = self
        
        self.cardsView.addSubview(cards)
    }


}

extension ViewController: CardsViewDelegate {
    func didSwipeLeft(_ sender: CardView) {
        
    }
    
    func didSwipeRight(_ sender: CardView) {
        
    }
    

    
    func didImagesEnded(_ sender: CardsView) {
        
    }
    
    
}

