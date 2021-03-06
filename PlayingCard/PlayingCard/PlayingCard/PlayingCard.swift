//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by MAC on 2022/1/1.
//

import Foundation

struct PlayingCard: CustomStringConvertible{
    
    var suit: Suit
    var rank: Rank
    
    enum Suit: String, CustomStringConvertible {
        case spades = "♠️"
        case hearts = "❤️"
        case clubs = "♣️"
        case diamonds = "♦️"
        static var all = [Suit.spades, .hearts, .clubs, .diamonds]
        var description: String { return rawValue }
    }
    
    enum Rank: CustomStringConvertible {
        case ace
        case numeric(Int)
        case face(String)
        
        var order: Int {
            switch self {
            case .ace: return 1
            case .numeric(let pips): return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default: return 0
            }
        }
        
        static var all: [Rank] {
            var allRanks = [Rank.ace]
            for pips in 2...10 {
                allRanks.append(Rank.numeric(pips))
            }
            allRanks += [Rank.face("J"), .face("Q"), .face("K")]
            return allRanks
        }
        
        var description: String {
            switch self {
            case .ace: return "A"
            case .numeric(let pips): return String(pips)
            case .face(let kind): return kind
            }
        }
        
    }
    
    var description: String {
        //return "\(suit.rawValue)\(rank.description)"
        // Suit 和 Rank 都自己重写过 toString，直接写就可以了
        return "\(suit)\(rank)"
    }
    
}
