//
//  Concentration.swift
//  Concentration
//
//  Created by MAC on 2021/12/6.
//

import Foundation

// API: application programming interface

/**
 Model 层
 
 只要所有的参数都有默认值，那 class 会有一个默认的空参构造
 
 */
class Concentration {
    
//    var cards = Array<Card>()
    var cards = [Card]() // [Card] == Array<Card>
    
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    func chooseCard(at index: Int){
//        cards[index].isFaceUp = !cards[index].isFaceUp
        if !cards[index].isMatched {
            if let matchIndex == indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
            } else {
                // either no cards or 2 cards are face up
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        // ..< 左闭右开，... 右侧也包含
        // _ 意味着不关心这个值，可以忽略它
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            // let matchingCard = card // 值类型，赋值给其他变量会复制一份，不需要重新创建
            // cards.append(card) // 添加到数组中也会复制一份
            cards += [card, card] // 可以用 += 实现 addAll 的功能
        }
        // TODO: Shuffle the cards
    }
    
}
