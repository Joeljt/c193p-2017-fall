//
//  PlayingCardDeck.swift
//  PlayingCard
//
//  Created by MAC on 2022/1/1.
//

import Foundation
import UIKit

struct PlayingCardDeck {
    
    private(set) var cards = [PlayingCard]()
    
    // 组合一下牌，4 个花色，13 张牌，4 * 13 = 52
    init() {
        for suit in PlayingCard.Suit.all {
            for rank in PlayingCard.Rank.all {
                cards.append(PlayingCard(suit: suit, rank: rank))
            }
        }
    }
    
    mutating func draw() -> PlayingCard? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        } else {
            return nil
        }
    }
    
}

extension Int {
    
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
    
}
