//
//  Concentration.swift
//  Concentration
//
//  Created by MAC on 2021/12/22.
//

import Foundation

struct Concentration {
    
    private(set) var cards = [Card]()
    
    private(set) var flipCount = 0
    private(set) var score: Int
    
    private(set) var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            for index in cards.indices {
                if cards[index].isFaceUp {
                    return index
                }
            }
            return nil
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    /**
     会引起当前结构体变化的方法，需要显式增加 mutating 修饰
     */
    mutating func chooseCard(at index: Int) {
        flipCount += 1 // 每次点击都要计数
        // 如果点击的是已经匹配中的卡片，就忽略不计
  
        if !cards[index].isMatched {
            // 取出来点击的 Card，先看其 faceUp 状态，如果是 faceDown，就先翻过来
            if let visibleCardIndex = indexOfOneAndOnlyFaceUpCard {
                if visibleCardIndex != index {
                    cards[index].isFaceUp = true
                }
            } else {
                // 当前所有卡片都是背面的，点击以后把点的这个卡片翻过来
                indexOfOneAndOnlyFaceUpCard = index
//                cards[index].isFaceUp = true
            }
        }
    }
    
    mutating func checkIfMatch(at index: Int) {
        if let visibleCardIndex = indexOfOneAndOnlyFaceUpCard {
            if(cards[index].identifier == cards[visibleCardIndex].identifier) {
                score += 2
                cards[index].isMatched = true
                cards[visibleCardIndex].isMatched = true
            } else {
                score -= 1
                cards[index].isFaceUp = false
                cards[visibleCardIndex].isFaceUp = false
            }
        }
    }
    
    /**
     构造器，接收一个牌的组数，同样的 emoji 会有两组
     */
    init(numberOfPairsOfCards: Int) {
        // 初始化分数为 0
        score = 0
        // 根据指定的数量初始化数组
        for _ in 0...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card] // Card 是 struct，value type，传入数组的时候会自动拷贝一份，所以可以直接放入数组而不用新建
        }
        // 随机打乱顺序，否则顺序都是固定的
        for _ in 0..<1000 {
            for index in cards.indices {
                let randomIndex = cards.count.arc4random
                // 交换两张牌在数组中的位置，arc4random 最大值是 count-1，不会越界
                let temp = cards[randomIndex]
                cards[randomIndex] = cards[index]
                cards[index] = temp
            }
        }
    }
    
}

extension Int {
    // 给 Int 加一个生成随机数的扩展
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
