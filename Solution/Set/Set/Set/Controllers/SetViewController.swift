//
//  ViewController.swift
//  Set
//
//  Created by MAC on 2022/1/1.
//

import UIKit

class SetViewController: UIViewController {

    private var engine = SetEngine()
    private var selectedButton = [UIButton]()
    private var hintdButton = [UIButton]()
    
    @IBOutlet var cardsButton: [UIButton]!
    
    @IBOutlet weak var moreThreeButton: UIButton!
    
    @IBOutlet weak var hintButton: UIButton!
    
    @IBOutlet weak var newGameButton: UIButton!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func cardPressed(_ sender: UIButton) {
        if let cardIndex = cardsButton.firstIndex(of: sender) {
            // 如果点的是牌桌上正在显示的牌
            if cardIndex < engine.cardOnTable.count {
                engine.chooseCard(at: cardIndex)
                chooseButton(at: sender)
                // 如果有成功找到一组 Set，那当前组就会从牌桌上移除，需要刷新页面
                // 实际上应该在成功匹配的时候才去刷新，否则平白消耗性能
                updateViewFromModel()
            }
        }
    }
    
    @IBAction func onHintButtonClicked(_ sender: UIButton) {
        engine.hint()
        // 如果找到了提示的牌列表
        if engine.hintCard.count > 0 {
            for hint in 0...2 {
                // 遍历提示的牌，然后把对应位置的牌高亮出来
                let index = engine.hintCard[hint]
                cardsButton[index].layer.borderColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
                cardsButton[index].layer.borderWidth = 10
                // 将 button 添加到数组
                hintdButton.append(cardsButton[index])
            }
            // 然后马上又清空？
            hintdButton.removeAll()
        }
    }
    
    @IBAction func onNewGame(_ sender: UIButton) {
        engine = SetEngine() // 重新初始化一个 Set Model
        resetButton()
        updateViewFromModel()
        hideButtonIfNeeded()
        updateScore()
        selectedButton.removeAll()
        hintdButton.removeAll()
    }
    
    @IBAction func onThreeMore(_ sender: UIButton) {
        engine.draw()
        updateViewFromModel()
        hideButtonIfNeeded()
    }
    
    private func resetButton() {
        for button in cardsButton {
            let nsAttributedString = NSAttributedString(string: "")
            button.setAttributedTitle(nsAttributedString, for: .normal)
            button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        }
    }
    
    private func hideButtonIfNeeded() {
        // 如果没牌了就不能再显示 3 more 的 button 了
        moreThreeButton.isHidden = engine.cardOnTable.count == 24 || engine.numberOfCard == 0
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateViewFromModel()
    }
    
    private func updateScore() {
        scoreLabel.text = "\(engine.score)"
    }
    
    // 标记选中状态
    private func chooseButton(at button: UIButton){
        
        if !selectedButton.contains(button) {
            selectedButton += [button]
            button.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            button.layer.borderWidth = 5
        } else {
            selectedButton.remove(at: selectedButton.firstIndex(of: button)!)
            button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            button.layer.borderWidth = 5
        }
        
        // 如果选择 >= 3，就直接清空就可以了，因为判断的逻辑都在 Model 层
        if selectedButton.count == 3 {
            selectedButton.forEach { $0.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) }
            selectedButton.removeAll()
            updateScore()
        }
        
    }
    
    private func updateViewFromModel() {
        for index in engine.cardOnTable.indices {
            cardsButton[index].titleLabel?.numberOfLines = 0 // A value of 0 means no limit
            cardsButton[index].setAttributedTitle(getCardTitle(with: engine.cardOnTable[index]), for: .normal)
        }
    }
    
    private func getCardTitle(with card: Card) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeColor: ModelToView.colors[card.color]!,
            .strokeWidth: ModelToView.strokeWidth[card.fill]!,
            .foregroundColor: ModelToView.colors[card.color]!.withAlphaComponent(ModelToView.alpha[card.fill]!)
        ]
        var cardTitle = ModelToView.shapes[card.shape]!
        switch card.number {
        case .two: cardTitle = "\(cardTitle)\n\(cardTitle)"
        case .three: cardTitle = "\(cardTitle)\n\(cardTitle)\n\(cardTitle)"
        default:
            break
        }
        return NSAttributedString(string: cardTitle, attributes: attributes)
    }

}

struct ModelToView {
    static let shapes: [Card.Shape: String] = [.circle: "●", .triangle: "▲", .square: "■"]
    static var colors: [Card.Color: UIColor] = [.red: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), .purple: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), .green: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)]
    static var alpha: [Card.Fill: CGFloat] = [.solid: 1.0, .empty: 0.40, .stripe: 0.15]
    static var strokeWidth: [Card.Fill: CGFloat] = [.solid: -5, .empty: 5, .stripe: -5]
}

 
