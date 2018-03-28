import Foundation

public class Game {
    public var dealtCards: [Card] = []
    public var selectedCards: [Card] = []
    public var remainingCards: [Card] = []
    public var matchedCards: [Card] = []
    private let matcher: Matcher
    var callback: GameCallback? = nil

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

    public func selectCard(card: Card) {
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
        }
        setSelectedOnlyLastCard(card: card)
    }

    private func onIsAMatch(card: Card) {
        matchedCards.append(contentsOf: selectedCards)
        callback?.onMatch()
    }


    public func deal() {
        unselctCards()
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

    func unselctCards() {
        selectedCards.removeAll()
    }

    func removeMatched() {
        for card in dealtCards {
            if matchedCards.contains(card) {
                let index = dealtCards.index(of: card)!
                dealtCards.remove(at: index)
            }
        }
    }

    func isAMatch() -> Bool {
        return matcher.isAMatch(cards: selectedCards)
    }

    func selectOrDeselect(_ card: Card) {
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

    func setSelectedOnlyLastCard(card: Card) {
        if (selectedCards.contains(card)) {
            return
        } else {
            unselctCards()
            selectedCards.append(card)
        }
    }
}

protocol GameCallback {
    func onMatch()
}


