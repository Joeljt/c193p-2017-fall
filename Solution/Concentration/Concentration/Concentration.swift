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
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    return index
//                }
//            }
//            return nil
            
            // 必须确保只有一个 oneAndOnlyFaceUpCard
            // 遍历过程中检查是否有 faceUp 的牌：
            // 1、如果没有 faceUp 的牌，直接返回 nil，说明没有牌是正在显示的
            // 2、如果有 faceUp 的牌，要看记录的 index 是否为空：
            // 如果为空就把 index 值赋给它；如果不为空，就返回空 >> 用这种方式保证当前只有一张牌是翻开的状态
            // 因为这个变量只会在选牌的时候触发，只要保证这个变量标记的是最近一次选中的牌，就能 visibleIndex != index，就可以进入 else 分支，然后给 indexOfOneAndOnlyFaceUpCard 赋值，就会把所有的牌都翻回去
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
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
            if let visibleCardIndex = indexOfOneAndOnlyFaceUpCard, visibleCardIndex != index {
                // 目前有两张牌是 faceUp 的，比对是否匹配
                if cards[visibleCardIndex].identifier == cards[index].identifier {
                    cards[visibleCardIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2 // 成功命中，加两分
                } else {
                    if cards[visibleCardIndex].isSeenBefore || cards[index].isSeenBefore {
                        score -= 1
                    }
                    cards[visibleCardIndex].isSeenBefore = true
                    cards[index].isSeenBefore = true
                }
                cards[index].isFaceUp = true // 把选择的牌翻过来
            } else {
                // 当前所有卡片都是背面的，点击以后把点的这个卡片翻过来
                indexOfOneAndOnlyFaceUpCard = index
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
