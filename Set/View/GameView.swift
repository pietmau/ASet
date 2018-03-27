import Foundation
import UIKit

class GameView: UIView {

    var callBack: GridViewCallback? = nil {
        didSet {
            grid?.callback = callBack
        }
    }

    var dealtCards: [Card] = [] {
        didSet {
            redraw()
        }
    }

    var selectedtCards: [Card] = [] {
        didSet {
            redraw()
        }
    }

    private var grid: GridView? {
        get {
            return subviews[0] as? GridView
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        let view = GridView(frame: bounds)
        addSubview(view)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        subviews[0].frame = bounds
    }

    private func redraw() {
        if let views = grid?.subviews {
            for view in views {
                view.removeFromSuperview()
            }
        }
        for card in dealtCards {
            let cardView: CardView = CardView(card: card)
            if (selectedtCards.contains(card)) {
                cardView.isSelected = true
            }
            grid?.addSubview(cardView)
        }
    }
}
