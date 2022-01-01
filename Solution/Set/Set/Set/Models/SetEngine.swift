//
//  SetEngine.swift
//  Set
//
//  Created by MAC on 2022/1/1.
//

import Foundation

struct SetEngine {
    
    private(set) var deck = [Card]()
    private(set) var score = 0
    
    var numberOfCard: Int {
        return deck.count
    }
    
    private(set) var cardOnTable = [Card]()
    private var selectedCard = [Card]()
    var hintCard = [Int]()
    
    mutating func chooseCard(at index: Int) {
        let card = cardOnTable[index]
        // 如果选择的牌已经选过了，就从 selectedCard 中将其移除
        if selectedCard.contains(card), let pos = selectedCard.firstIndex(of: card) {
            selectedCard.remove(at: pos)
        } else {
            // 将牌桌上对应位置的牌取出来，放到 selectedCard 里
            selectedCard += [cardOnTable[index]]
        }
        
        // 判断是不是选择了三张牌，如果选完了三张，则判断当前是否满足 Set 条件
        if selectedCard.count == 3 {
            if isSet(on: selectedCard) {
                for selectCard in selectedCard {
                    cardOnTable.remove(at: cardOnTable.firstIndex(of: selectCard)!)
                }
                selectedCard.removeAll()
                draw() // 移除三张牌后，重新补齐
                score += 1
            } else {
                score -= 1
            }
        }
    }
    
    /**
     满足 Set 的条件：任意两张牌不能有任何两个属性相同
     */
    func isSet(on selectedCard: [Card]) -> Bool {
        // trailing closure
        // 当一个方法的参数是一个仅有的方法时，外层的 () 就不再需要了，返回值也不用写，参数可以用 $0 $1 来替代
        // map 函数：将目标数组转换成按照传入的方法操作过后的新数组
        // 先用 map 将选中的牌所有的 color 都筛选出来，再用 Set() 将结果去重
        let color = Set(selectedCard.map { $0.color }).count
        let shape = Set(selectedCard.map { $0.shape }).count
        let number = Set(selectedCard.map { $0.number }).count
        let fill = Set(selectedCard.map { $0.fill }).count
        
        // 任意两张牌不能有任何两个属性相同
        return color != 2 && shape != 2 && number != 2 && fill != 2
    }
    
    /**
     从牌堆里随机取出来 3 张牌，放到牌桌上
     */
    mutating func draw() {
        if deck.count > 0 {
            for _ in 1...3 {
                cardOnTable += [deck.remove(at: deck.randomIndex)]
            }
        }
    }
    
    /**
     初始化牌桌上的牌，先初始化 12 张
     */
    private mutating func initDeck() {
        for _ in 1...4 {
            draw()
        }
    }
    
    /**
     提示功能:
        从牌桌上的牌里找出来满足条件的三张牌，放入 hintCard 数组里
        从第一张牌开始，假设可以成立；然后从第二张
     */
    mutating func hint() {
        hintCard.removeAll()
        for i in 0..<cardOnTable.count {
            for j in (i+1)..<cardOnTable.count {
                for k in (j+1)..<cardOnTable.count {
                    let hints = [cardOnTable[i], cardOnTable[j], cardOnTable[k]]
                    if isSet(on: hints) {
                        hintCard += [i, j, k]
                    }
                }
            }
        }
    }
    
    init() {
        // 准备牌堆
        for color in Card.Color.all {
            for number in Card.Number.all {
                for shape in Card.Shape.all {
                    for fill in Card.Fill.all {
                        let card = Card(with: color, number, shape, fill)
                        deck += [card]
                    }
                }
            }
        }
        // 初始化牌桌上的牌
        initDeck()
    }
    
}

extension Array {
    
    // 以当前数组大小为上限，生成一个随机数
    var randomIndex: Int {
        return Int(arc4random_uniform(UInt32(count - 1)))
    }
    
}
