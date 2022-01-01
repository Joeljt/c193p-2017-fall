//
//  ViewController.swift
//  Concentration
//
//  Created by MAC on 2021/12/22.
//

import UIKit

class ViewController: UIViewController {

    // XIB 连线
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet private var cardsButton: [UIButton]!
    
    // XIB 事件
    @IBAction private func touchCard(_ sender: UIButton) {
        // 点击的时候看当前这张牌 faceUp 还是 faceDown，做翻转操作
        // 我在这里只有 button 集合，只能知道玩家点击的是哪个 button，然后通过下标去找对应的 emoji
        // 这就需要 button 上的 emoji，与 Concentration 内部的 [Card] 一一对应
        if let cardIndex = cardsButton.firstIndex(of: sender) {
            // 1. 通过 MODEL 对象去更新选中的牌的状态
            game.chooseCard(at: cardIndex)
            
            // 2. 在 CONTROLLER 层更新 UI
            updateViewFromModel()
        }
    }
    
    @IBAction func newGameButtonPressed(_ sender: UIButton) {
        setup()
        updateViewFromModel()
    }
    
    // 主题
    private let theme = [
        ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮"],
        ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏉", "🎱", "🏓", "🏸", "🥅", "🏒"],
        ["😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣", "☺️", "😊", "😇", "🙂"],
        ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🚚", "🚛"],
        ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🍈", "🍒", "🍑"],
    ]
    private var currentTheme = [String]()
    private var buttonColor = #colorLiteral(red: 0.9176470588, green: 0.662745098, blue: 0.2666666667, alpha: 1)
    private var backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    // Emoji 映射字典
    private var emojiMap = [Int:String]()

    // Concentration
    private var game: Concentration!
    private var numberOfPairsOfCards: Int {
        return (cardsButton.count + 1) / 2
    }
    
    private func getEmoji(for card: Card) -> String {
        if emojiMap[card.identifier] == nil {
            emojiMap[card.identifier] = currentTheme.remove(at: currentTheme.count.arc4random)
        }
        return emojiMap[card.identifier] ?? "?"
    }

    // 初始化主题
    private func setupThemes() {
        let randomIndex = theme.count.arc4random
        currentTheme = theme[randomIndex]
        updateColor(for: randomIndex)
        
        // 根据最新的主题设置颜色
        view.backgroundColor = self.backgroundColor
        for button in cardsButton {
            button.backgroundColor = self.buttonColor
        }
        scoreLabel.textColor = self.buttonColor
        countLabel.textColor = self.buttonColor
        newGameButton.setTitleColor(self.buttonColor, for: UIControl.State.normal)
        
    }
    
    private func updateViewFromModel() {
        // 从当前主题中遍历，找到对应位置的 emoji，并根据选出来的牌的状态来决定是赋值还是翻过去
        for index in cardsButton.indices {
            let button = cardsButton[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(getEmoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0) : buttonColor
            }
        }
        // 更新分数和翻转次数
        countLabel.text = "Flips: \(game.flipCount)"
        scoreLabel.text = "Score: \(game.score)"
    }
    
    // 根据随机下标更新主题色
    private func updateColor(for theme: Int) {
        switch(theme){
          case 0:
            buttonColor = #colorLiteral(red: 0.4274509804, green: 0.737254902, blue: 0.3882352941, alpha: 1)
            backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
          case 1:
            buttonColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            backgroundColor = #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)
          case 2:
            buttonColor = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)
            backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
          case 3:
            buttonColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
            backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
          case 4:
            buttonColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        default:
            break
        }
    }
    
    private func setup() {
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        setupThemes()
        // 根据主题元素填充 Concentration 的数据，现在只有
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}

