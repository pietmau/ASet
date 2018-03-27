import Foundation

public class GameImpl: Game {
    public var dealtCards: [Card] = []
    public var selectedCards: [Card] = []
    public var remainingCards: [Card] = []
    public var matchedCards: [Card] = []
    private let matcher: Matcher

    public var canDeal: Bool {
        get {
            return remainingCards.count >= 3
        }
    }

    init(matcher: Matcher) {
        self.matcher = matcher
        remainingCards = Card.createAll()
        for _ in 1...4 {
            deal()
        }
    }

    public func deal() {
        dealInternal()
        unselctCards()
    }

    private func dealInternal() {
        var toBeDealt = getThreeCards()
        for index in dealtCards.indices {
            if (toBeDealt.isEmpty) {
                return
            }
            let currentcard = dealtCards[index]
            if ((matchedCards.contains(currentcard))) {
                dealtCards[index] = toBeDealt.removeFirst()
            }
        }
        dealtCards.append(contentsOf: toBeDealt)
    }

    private func getThreeCards() -> [Card] {
        var result: [Card] = []
        if (canDeal) {
            for _ in 0...2 {
                let rand = Int(arc4random_uniform(UInt32(remainingCards.count)))
                let card = remainingCards.remove(at: rand)
                result.append(card)
            }
        }
        return result
    }

    private func unselctCards() {
        selectedCards.removeAll()
    }

    private func onIsAMatch(card: Card) {
        matchedCards.append(contentsOf: selectedCards)
        onIsNotAMatch(card: card)
        if (canDeal) {
            dealInternal()
        } else {
            removeMatched()
        }
    }

    private func removeMatched() {
        for card in dealtCards {
            if matchedCards.contains(card) {
                let index = dealtCards.index(of: card)!
                dealtCards.remove(at: index)
            }
        }
    }

    private func isAMatch() -> Bool {
        return matcher.isAMatch(cards: selectedCards)
    }

    public func selectCard(at: Int) {
        if (at < 0 || at >= dealtCards.count) {
            return
        }
        let card = dealtCards[at]
        if (selectedCards.count == 3) {
            isAMatchOrNot(card: card)
        } else if (selectedCards.count < 3) {
            selectOrDeselect(card)
        }

    }

    private func isAMatchOrNot(card: Card) {
        if (selectedCards.contains(card)) {
            return
        }
        if (isAMatch()) {
            onIsAMatch(card: card)
        } else {
            onIsNotAMatch(card: card)
        }
    }

    private func selectOrDeselect(_ card: Card) {
        if (selectedCards.contains(card)) {
            deselect(card: card)
        } else {
            setSelected(card)
        }
    }

    private func setSelected(_ card: Card) {
        selectedCards.append(card)
    }

    private func deselect(card: Card) {
        let index = selectedCards.index(of: card)
        selectedCards.remove(at: index!)
    }

    private func onIsNotAMatch(card: Card) {
        if (selectedCards.contains(card)) {
            return
        } else {
            unselctCards()
            selectedCards.append(card)
        }
    }

}
