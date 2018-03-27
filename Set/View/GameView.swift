import Foundation
import UIKit

class GameView: UIView {
    private var cardsInternal: [Card: UIView] = [:]

    var callBack: GridViewCallback? = nil {
        didSet {
            grid?.callback = callBack
        }
    }

    var dealtCards: [Card] {
        set {
            for card in newValue {
                if (cardsInternal[card] == nil) {
                    onCardAdded(card)
                }
            }
            for (card, view) in cardsInternal {
                if (!newValue.contains(card)) {
                    onCardRemoved(card)
                }
            }
        }
        get {
            return []
        }
    }

    var selectedtCards: [Card] = [] {
        didSet {
            //redraw()
        }
    }

    private var grid: GridView? {
        get {
            return subviews[0] as? GridView
        }
    }


    private func onCardRemoved(_ card: Card) {
        if let view = cardsInternal[card] {
            view.removeFromSuperview()
        }
    }

    private func onCardAdded(_ card: Card) {
        let cardView: CardView = CardView(card: card)
        cardsInternal[card] = cardView
        grid?.addSubview(cardView)
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

//    private func redraw() {
//        if let views = grid?.subviews {
//            for view in views {
//                view.removeFromSuperview()
//            }
//        }
//        for card in dealtCards {
//            let cardView: CardView = CardView(card: card)
//            if (selectedtCards.contains(card)) {
//                cardView.isSelected = true
//            }
//            grid?.addSubview(cardView)
//        }
//    }
}
