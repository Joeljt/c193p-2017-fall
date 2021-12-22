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
struct Concentration {
    
    // 可以访问，但是不应该被外界进行修改
    private(set) var cards = [Card]() // [Card] == Array<Card>
    
    // 计算属性
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            // fliter 筛选，然后通过 Collection 协议的扩展直接取出来对应的数据
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
            
//            var foundIndex: Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int){
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
//        cards[index].isFaceUp = !cards[index].isFaceUp
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        
    }
    
    init(numberOfPairsOfCards: Int) {
        
        assert(numberOfPairsOfCards > 0, "Invalid Argument for Concentration.init()")
        
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
    
    func getSize() -> (weight: Double, height: Double, name: String) {
    
        
        
        return (68.8, 171.2, "Joey")
    }
    
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
