import Foundation
import UIKit

class GameView: UIView {
    var deckPosition: CGRect? = nil
    public static let ENTERING_DURATION = 0.5
    private var cards: [Card] = []
    private var views: [CardView] = []

    var matched: [Card] {
        get {
            return []
        }
        set {
            animateExit(newValue)
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

    private func onCardsRemoved(_ newCards: [Card]) {
        for (index, card) in cards.enumerated().reversed() {
            let card = cards[index]
            if (!newCards.contains(card)) {
                onCardRemoved(index: index)
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

    private func onCardsMaybeCahnged(_ newValue: [Card]) {
        for i in newValue.indices {
            let newCard = newValue[i]
            let oldCard = cards[i]
            if (newCard != oldCard) {
                onCardReplaced(old: oldCard, new: newCard, at: i)
            }
        }
    }

    private func onCardRemoved(index: Int) {
        cards.remove(at: index)
        let view = views.remove(at: index)
        view.removeFromSuperview()
    }

    private func onCardAdded(_ card: Card) {
        let cardView: CardView = CardView(card: card)
        cards.append(card)
        views.append(cardView)
        grid?.addSubview(cardView)
        animateEntering(newView: cardView)
    }

    private func onCardReplaced(old: Card, new: Card, at: Int) {
        let newView: CardView = CardView(card: new)
        let oldView = views[at]
        newView.frame = oldView.frame
        grid?.insertSubview(newView, at: at)
        oldView.removeFromSuperview()
        grid?.setNeedsLayout()
        cards[at] = new
        views[at] = newView
        animateEntering(newView: newView)
    }

    private func animateEntering(newView: CardView) {
        newView.alpha = 0
        Timer.scheduledTimer(withTimeInterval: GameView.ENTERING_DURATION, repeats: false, block: { _ in
            UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: GameView.ENTERING_DURATION,
                    delay: 0.0,
                    animations: { newView.alpha = 1 }
            )
        })
    }

    func animateExit(_ matched: [Card]) {
        for i in cards.indices {
            if (matched.contains(cards[i])) {
                let view = views[i]
                animateAway(view)
            }
        }
    }

    private func animateAway(_ view: UIView) {
        UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: GameView.ENTERING_DURATION,
                delay: 0.0,
                animations: {
                    view.alpha = 0
                })
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

    var selectedtCards: [Card] = [] {
        didSet {
            onCardsSelected(selectedtCards: selectedtCards)
        }
    }

}
