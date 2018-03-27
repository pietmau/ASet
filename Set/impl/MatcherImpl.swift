import Foundation

class MatcherImpl: Matcher {

    func isAMatch(cards: [Card]) -> Bool {
        if (cards.count != 3) {
            return false
        }
        if (!numbersMatch(cards)) {
            return false
        }
        if (!shapesMatch(cards)) {
            return false
        }
        if (!colorMatch(cards)) {
            return false
        }
        if (!shadingMatch(cards)) {
            return false
        }
        return true
    }

    private func shadingMatch(_ cards: [Card]) -> Bool {
        let numbers = cards.map { card in
            card.shading
        }
        let set = Set<Shading>(numbers)
        return (set.count == 3 || set.count == 1)
    }

    private func colorMatch(_ cards: [Card]) -> Bool {
        let numbers = cards.map { card in
            card.color
        }
        let set = Set<Color>(numbers)
        return (set.count == 3 || set.count == 1)
    }

    private func shapesMatch(_ cards: [Card]) -> Bool {
        let numbers = cards.map { card in
            card.shape
        }
        let set = Set<Shape>(numbers)
        return (set.count == 3 || set.count == 1)
    }

    private func numbersMatch(_ cards: [Card]) -> Bool {
        let numbers = cards.map { card in
            card.number
        }
        let set = Set<Int>(numbers)
        return (set.count == 3 || set.count == 1)
    }
}
