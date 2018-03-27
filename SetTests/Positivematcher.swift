import Foundation

class Positivematcher: Matcher {
    func isAMatch(cards: [Card]) -> Bool {
        return cards.count == 3
    }
}
