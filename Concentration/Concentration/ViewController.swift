//
//  ViewController.swift
//  Concentration
//
//  Created by MAC on 2021/12/6.
//

import UIKit

class ViewController: UIViewController {
    
    // Controller 持有 Model 的引用
    // lazy 懒加载变量，有人使用的时候才去初始化；这样一定能保证 self 可用，初始化就不会有问题了
    // count + 1 进行向上取整，避免除以 2 以后丢掉一个元素
    lazy var game: Concentration = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    

    // [Type] means an array of type, same as normal syntax Array<UIButton>
    // Cmd + Ctrl + click to rename this
    @IBOutlet var cardButtons: Array<UIButton>!
   
    @IBOutlet weak var flipCountLabel: UILabel!
    
    var flipCount = 0 {
        didSet {
            // property observer，每次属性值发生改变时，都会执行此方法
            // 类似 watch 函数
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        // Int? 的类型是 Optional，可选类型
        // 可选类型的本质是枚举，Optional 枚举有两个值，Set 和 Not Set
        // 枚举值可以有关联数据，可以使用 ! 将对应的关联数据拆箱出来使用
        // 而没有关联数据的 Optional 值为 nil，尝试对 nil 进行拆箱会 crash
        // nil 不是 null，也不是空指针，它仅仅表示一个本应该有值的变量没有值而已
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            
        } else {
            print("Something went wrong..");
        }
    }
    
    func updateViewFromModel() {
        // .indices 可以取出数组的下标
        for index in cardButtons.indices {
            let button = cardButtons[index] // 取出对应位置的 UI button
            
            // 按下标取出来对应位置的卡片，然后根据卡片的状态来修改按钮的样式
            // Model >> UI
            let card = game.cards[index]
    
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            }
        }
    }
    
    var emojiChoices = ["👻", "😈", "👻", "😈"]
    var emoji = [Int: String]() // Dictionary simple syntax
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil && emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
                    
        }
        return emoji[card.identifier] ?? "?"
    }
    
//    func flipCard(withEmoji emoji: String, on button: UIButton) {
//        if emoji == button.currentTitle {
//            button.setTitle("", for: UIControl.State.normal)
//            button.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
//        } else {
//            button.setTitle(emoji, for: UIControl.State.normal)
//            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        }
//    }
    
}

