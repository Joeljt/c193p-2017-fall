//
//  ViewController.swift
//  PlayingCard
//
//  Created by MAC on 2022/1/1.
//

import UIKit

class ViewController: UIViewController {

    var deck = PlayingCardDeck()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for _ in 1...10 {
            let card = deck.draw()!
            print(card)
        }
    }


}

