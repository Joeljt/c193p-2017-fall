//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by MAC on 2022/1/1.
//

import UIKit

@IBDesignable
class PlayingCardView: UIView {
    
    @IBInspectable
    var rank: Int = 5 {
        didSet {
            setNeedsDisplay() // 强制重绘
            setNeedsLayout() // 强制重新布局
        }
    }
    @IBInspectable
    var suit: String = "❤️" {
        didSet {
            setNeedsDisplay() // 强制重绘
            setNeedsLayout() // 强制重新布局
        }
    }
    @IBInspectable
    var isFaceUp: Bool = true  {
        didSet {
            setNeedsDisplay() // 强制重绘
            setNeedsLayout() // 强制重新布局
        }
    }
    
    var faceCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize { didSet { setNeedsDisplay() } }
    
    @objc func adjustFaceCardScale(byHandlingGestureRecognizedBy recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            // 根据缩放比例来设置默认样式，并在之后进行重置
            faceCardScale *= recognizer.scale
            recognizer.scale = 1.0 // 重置手势的缩放比例，否则不能保证还原
        default: break
        }
    }
    
    private func centeredAttributedString(_ string: String, fontSize : CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.paragraphStyle:paragraphStyle,
                                .font: font])
    }
    
    private var cornerString: NSAttributedString {
        return centeredAttributedString("\(rankString)\n\(suit)", fontSize: cornerFontSize)
    }
    
    private lazy var upperLeftCornerLabel = createCornerLabel()
    private lazy var lowerLeftCornerLabel = createCornerLabel()
    
    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }

    private func configureCornerLabel(_ label: UILabel){
        label.attributedText = cornerString
        label.frame.size = CGSize.zero // 清空原本的值，并设置 sizeToFit 实现自适应
        label.sizeToFit()
        label.isHidden = !isFaceUp
    }
    
    // 在配置变化时重绘页面
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCornerLabel(upperLeftCornerLabel)
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        
        configureCornerLabel(lowerLeftCornerLabel)
        lowerLeftCornerLabel.transform = CGAffineTransform.identity
            //.translatedBy(x: lowerLeftCornerLabel.frame.size.width, y: lowerLeftCornerLabel.frame.size.height)
            .rotated(by: CGFloat.pi)
        lowerLeftCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -lowerLeftCornerLabel.frame.size.width, dy: -lowerLeftCornerLabel.frame.size.height)
        
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        if isFaceUp {
            if let faceCardImage = UIImage(named: rankString + suit) {
                faceCardImage.draw(in: bounds.zoom(by: faceCardScale))
            }
        } else {
            if let cardBackImage = UIImage(named: "cardback") {
                cardBackImage.draw(in: bounds.zoom(by: faceCardScale))
            }
        }
        
        
    }
    
    

}

extension PlayingCardView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    private var rankString: String {
        switch rank {
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}

extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
