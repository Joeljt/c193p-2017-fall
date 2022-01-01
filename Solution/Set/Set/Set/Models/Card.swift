//
//  Card.swift
//  Set
//
//  Created by MAC on 2022/1/1.
//

import Foundation

/**
 在 Set 游戏中，每张卡片有四个特性：
 - 形状：三角形、正方形、圆形
 - 颜色：红色、绿色、紫色
 - 数字：1、2、3
 - 填充：完整填充、无填充、条纹填充
 */
struct Card: CustomStringConvertible, Equatable {
    
    var color: Color
    var number: Number
    var shape: Shape
    var fill: Fill
    
    // 在声明后指定 : String 可以控制当前枚举类的 rawValue 类型，并直接使用 .rawValue 进行访问
    enum Color: String, CustomStringConvertible {
        case red = "red"
        case green = "green"
        case purple = "purple"
        var description: String { return rawValue }
        static let all = [Color.red, Color.green, Color.purple]
    }
    
    enum Number: Int, CustomStringConvertible {
        case one = 1
        case two
        case three
        var description: String { return String(rawValue) }
        static let all = [Number.one, .two, .three]
    }
    
    enum Shape: String, CustomStringConvertible {
        case circle = "circle"
        case square = "square"
        case triangle = "triangle"
        var description: String { return rawValue }
        static let all = [Shape.circle, .square, .triangle]
    }
    
    enum Fill: String, CustomStringConvertible {
        case solid = "solid"
        case stripe = "stripe"
        case empty = "empty"
        var description: String { return rawValue }
        static let all = [Fill.solid, .stripe, .empty]
    }
    
    init(with c: Color, _ n: Number, _ s: Shape, _ f: Fill) {
        color = c
        number = n
        shape = s
        fill = f
    }
    
    // 重写 toString
    var description: String {
        return "Color: \(color) Number: \(number) Shape: \(shape) Fill: \(fill)\n"
    }
    
    // 重写 == 操作符
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.color == rhs.color && lhs.shape == rhs.shape &&
            lhs.number == rhs.number && lhs.fill == rhs.fill;
    }
    
}
