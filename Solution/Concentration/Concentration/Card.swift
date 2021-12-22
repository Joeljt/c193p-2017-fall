//
//  Card.swift
//  Concentration
//
//  Created by MAC on 2021/12/22.
//

import Foundation

struct Card {
    
    // Emoji 不在这里？Emoji 是 UI 相关的，Card 结构只表示行为，不存储数据
    // 数据是在点击的时候动态赋值的：如果 faceUp，就 faceDown；如果 faceDown，就变成 faceUp，并设置当前的 emoji
    // 操作 Card 属性的动作发生在 Concentration.swift 中
    
    var isFaceUp = false
    var isMatched = false
    var isSeenBefore = false
    private(set) var identifier: Int
    
    private static var identifierFactor = 0
    
    private static func getUniqueIndetifier() -> Int {
        identifierFactor += 1 // ++ & -- were removed in Swift 3
        return identifierFactor
    }
    
    init() {
        self.identifier = Card.getUniqueIndetifier()
    }
    
}
