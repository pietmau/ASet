import Foundation
import UIKit

class GameView: UIView {
    private var cards: [Card] = []
    private var views: [CardView] = []

    var matched: [Card] {
        get {
            return []
        }
        set {
            setMatched(newValue)
        }
    }

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

    private func onCardsMaybeCahnged(_ newValue: [Card]) {
        for i in newValue.indices {
            let newCard = newValue[i]
            let oldCard = cards[i]
            if (newCard != oldCard) {
                repalceOldWitNew(old: oldCard, new: newCard, at: i)

            }
        }
    }

    private func repalceOldWitNew(old: Card, new: Card, at: Int) {
        let newView: CardView = CardView(card: new)
        let oldView = views[at]
        newView.frame = oldView.frame
        grid?.insertSubview(newView, at: at)
        oldView.removeFromSuperview()
        grid?.setNeedsLayout()
        cards[at] = new
        views[at] = newView
    }

    func setMatched(_ matched: [Card]) {
        for i in cards.indices {
            var toBeAnimated: [UIView] = []
            let card = cards[i]
            if (matched.contains(card)) {
                let view = views[i]
                toBeAnimated.append(view)
            }
            UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.5,
                    delay: 0.0,
                    options: [],
                    animations: {
                        toBeAnimated.forEach { view in
                            view.alpha = 0
                        }
                    }
            )
        }
    }

    private func onCardsRemoved(_ newCards: [Card]) {
        for (index, card) in cards.enumerated().reversed() {
            let card = cards[index]
            if (!newCards.contains(card)) {
                onCardRemoved(index: index)
            }
        }
    }

    private func onCardRemoved(index: Int) {
        cards.remove(at: index)
        let view = views.remove(at: index)
        view.removeFromSuperview()
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
            print(views.indices)
            for index in views.indices {
                let view = views[index]
                let card = cards[index]
                if (view.frame.contains(location)) {
                    callBack?.onCardClicked(card: card)
                    return
                }
            }
        }
    }
}
