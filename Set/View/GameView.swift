import Foundation
import UIKit

class GameView: UIView {
    private var cards: [Card] = []
    private var views: [CardView] = []

    var callBack: GridViewCallback? = nil {
        didSet {
            grid?.callback = callBack
        }
    }

    var dealtCards: [Card] {
        set {
            onCardsSet(newValue: newValue)
        }
        get {
            return []
        }
    }

    private func onCardsSet(newValue: [Card]) {
        if (newValue.count > cards.count) {
            onCardsAdded(newValue)
            return
        }
        if (newValue.count < cards.count) {
            onCardsRemoved(newValue)
            return
        }
        if (newValue.count == cards.count) {
            onCardsMaybeCahnged(newValue)
            return
        }
    }

    var selectedtCards: [Card] = [] {
        didSet {
            onCardsSelected(selectedtCards: selectedtCards)
        }
    }

    private func onCardsMaybeCahnged(_ value: [Card]) {
        
    }

    private func onCardsRemoved(_ newCards: [Card]) {
        for index in 0..<cards.count {
            let card = cards[index]
            if (!newCards.contains(card)) {
                onCardRemoved(index)
                break
            }
        }
    }

    private func onCardsAdded(_ newCards: [Card]) {
        for card in newCards {
            if (!cards.contains(card)) {
                onCardAdded(card)
            }
        }
    }

    private func onCardsSelected(selectedtCards: [Card]) {
        for index in 0..<cards.count {
            var view = views[index]
            if (selectedtCards.contains(cards[index])) {
                view.isSelected = true
            } else {
                view.isSelected = false
            }
            view.setNeedsDisplay()
        }
    }

    private var grid: GridView? {
        get {
            return subviews[0] as? GridView
        }
    }


    private func onCardRemoved(_ index: Int) {
        cards.remove(at: index)
        let view = views.remove(at: index)
        view.removeFromSuperview()
    }

    private func onCardAdded(_ card: Card) {
        let cardView: CardView = CardView(card: card)
        cards.append(card)
        views.append(cardView)
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

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as? UITouch {
            let location = touch.location(in: self)
            for index in 0..<views.count {
                let view = views[index]
                let card = cards[index]
                if (view.frame.contains(location)) {
                    callBack?.onCardClicked(card: card)
                }
            }
        }
    }
}
