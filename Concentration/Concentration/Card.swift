//
//  Card.swift
//  Concentration
//
//  Created by MAC on 2021/12/6.
//

import Foundation

// struct vs class
// 1. struct 没有继承；
// 2. struct value type, class reference type
//  struct 是值传递，当做参数传值时，会复制一份；class 是引用传递
//  Int/Array/Dictionary 都是 struct 类型
struct Card {
    
    // Card 不会有标识 Emoji 的属性，Emoji 是 UI 的一部分
    // Model 层的数据是 UI independent 的
    
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    static var identifierFactory = 0
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory;
    }
    
    // 声明构造器为 identifier 赋值
    // init 也可以向普通函数一样，为属性提供 external / internal name
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }

    
}
