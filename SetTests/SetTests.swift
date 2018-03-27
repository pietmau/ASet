import XCTest
@testable import Set

public class SetTests: XCTestCase {
    public var game: Game? = nil

    public override func setUp() {
        super.setUp()
        game = GameImpl(matcher: NegativeMatcher())
    }

    public override func tearDown() {
        super.tearDown()
    }

    func test_initiallyWeAreDealtTwelevecards() {
        XCTAssert(game?.dealtCards.count == 12, "Was \(game?.dealtCards.count)")
        XCTAssert(game?.remainingCards.count == (81 - 12), "Was \(game?.remainingCards.count)")
    }

    func test_initiallySelecgtedCardsIsImpty() {
        XCTAssert(game?.selectedCards.isEmpty == true)
    }

    func test_initiallyWeAreDealtTweleveValidCards() {
        let invalid = game?.dealtCards.filter { card in
            !Card.isAValidCard(card: card!)
        }
        XCTAssert(invalid!.isEmpty)
    }

    func test_initiallyWeStartWithValidCards() {
        let invalid = game?.remainingCards.filter { card in
            !Card.isAValidCard(card: card)
        }
        XCTAssert(invalid!.isEmpty)
    }

    func test_noOverallCardsDuplicates() {
        var cards = (game?.remainingCards)!
        let cards1 = game?.dealtCards as! [Card]
        cards.append(contentsOf: cards1)
        XCTAssert(cards.count == 81)
        XCTAssert(!findDuplicates(cards: cards1))
    }

    func test_noDealtCardsDuplicates() {
        let cards1 = game?.dealtCards
        XCTAssert(!findDuplicates(cards: cards1!))
    }

    func test_noRemainingCardsDuplicates() {
        let cards = game?.remainingCards
        XCTAssert(!findDuplicates(cards: cards!))
    }

    func test_selection() {
        game!.selectCard(at: 0)
        XCTAssert(game!.selectedCards.first! == game!.dealtCards.first!)
        game!.selectCard(at: 1)
        XCTAssert(game!.selectedCards.first! == game!.dealtCards.first!)
        XCTAssert(game!.selectedCards[1] == game!.dealtCards[1]!)
    }

    func test_selectionMoreThanThree() {
        selectThreeCards()
        game!.selectCard(at: 3)
        XCTAssert(game!.selectedCards.count == 1, "Expected 1 but was \(game!.selectedCards.count)")
    }

    func test_selectionThree() {
        selectThreeCards()
        XCTAssert(game!.selectedCards.count == 3, "Expected 3 but was \(game!.selectedCards.count)")
    }

    func test_selectiDuplicate() {
        selectTwocards()
        game!.selectCard(at: 1)
        XCTAssert(game!.selectedCards.count == 1, "Expected 1 but was \(game!.selectedCards.count)")
    }

    func test_selectionAndNotMatch() {
        selectThreeCards()
        game!.selectCard(at: 2)
        XCTAssert(game!.matchedCards.isEmpty)
        XCTAssert(game!.dealtCards.count == 12, "Expected \(12) but  was \(game!.dealtCards.count)")
    }

    func test_selectionAndMatch() {
        game = GameImpl(matcher: Positivematcher())
        selectThreeCards()
        game!.selectCard(at: 3)
        XCTAssert(game!.matchedCards.count == 3)
        XCTAssert(game!.dealtCards.count == 12, "Expected \(12) but  was \(game!.dealtCards.count)")
    }

    func test_lessThanThreeAndSelect() {
        selectTwocards()
        game!.selectCard(at: 2)
        XCTAssert(game!.matchedCards.count == 0)
        XCTAssert(game!.dealtCards.count == 12, "Expected \(12) but  was \(game!.dealtCards.count)")
        XCTAssert(game!.selectedCards.count == 3)
        XCTAssert(game!.remainingCards.count == 81 - 12)
        XCTAssert(game!.selectedCards[0] == game!.dealtCards[0])
        XCTAssert(game!.selectedCards[1] == game!.dealtCards[1])
        XCTAssert(game!.selectedCards[2] == game!.dealtCards[2])
    }

    func test_lessThanThreeAndDeSelect() {
        selectTwocards()
        game!.selectCard(at: 1)
        XCTAssert(game!.matchedCards.count == 0)
        XCTAssert(game!.dealtCards.count == 12, "Expected \(12) but  was \(game!.dealtCards.count)")
        XCTAssert(game!.selectedCards.count == 1)
        XCTAssert(game!.remainingCards.count == 81 - 12)
        XCTAssert(game!.selectedCards[0] == game!.dealtCards[0])
    }


    func test_ThreeeDSelected() {
        itSAMatch()
        itSNotAMatch()
    }

    private func itSNotAMatch() {
        func selectThreeAndReSelect() {
            setUp()
            selectThreeCards()
            game!.selectCard(at: 1)
            XCTAssert(game!.matchedCards.count == 0)
            XCTAssert(game!.dealtCards.count == 12, "Expected \(12) but  was \(game!.dealtCards.count)")
            XCTAssert(game!.selectedCards.count == 3)
            XCTAssert(game!.remainingCards.count == 81 - 12)
            XCTAssert(game!.selectedCards[0] == game!.dealtCards[0])
            XCTAssert(game!.selectedCards[1] == game!.dealtCards[1])
            XCTAssert(game!.selectedCards[2] == game!.dealtCards[2])
        }

        func selectThreeAndSelectOther() {
            setUp()
            selectThreeCards()
            XCTAssert(game!.matchedCards.count == 0)
            XCTAssert(game!.dealtCards.count == 12, "Expected \(12) but  was \(game!.dealtCards.count)")
            XCTAssert(game!.selectedCards.count == 3)
            XCTAssert(game!.remainingCards.count == 81 - 12)
            XCTAssert(game!.selectedCards[0] == game!.dealtCards[0])
            game!.selectCard(at: 4)
            XCTAssert(game!.matchedCards.count == 0)
            XCTAssert(game!.dealtCards.count == 12, "Expected \(12) but  was \(game!.dealtCards.count)")
            XCTAssert(game!.selectedCards.count == 1)
            XCTAssert(game!.remainingCards.count == 81 - 12)
            XCTAssert(game!.selectedCards[0] == game!.dealtCards[4])
        }

        selectThreeAndReSelect()
        selectThreeAndSelectOther()
    }

    private func itSAMatch() {

        func selectThreeAndReSelect() {
            game = GameImpl(matcher: Positivematcher())
            selectThreeCards()
            game!.selectCard(at: 1)
            XCTAssert(game!.matchedCards.count == 0)
            XCTAssert(game!.dealtCards.count == 12, "Expected \(12) but  was \(game!.dealtCards.count)")
            XCTAssert(game!.selectedCards.count == 3)
            XCTAssert(game!.remainingCards.count == 81 - 12)
            XCTAssert(game!.selectedCards[0] == game!.dealtCards[0])
            XCTAssert(game!.selectedCards[1] == game!.dealtCards[1])
            XCTAssert(game!.selectedCards[2] == game!.dealtCards[2])
        }

        func selectThreeAndSelectOther() {
            game = GameImpl(matcher: Positivematcher())
            selectThreeCards()
            XCTAssert(game!.matchedCards.count == 0)
            XCTAssert(game!.dealtCards.count == 12, "Expected \(12) but  was \(game!.dealtCards.count)")
            XCTAssert(game!.selectedCards.count == 3)
            XCTAssert(game!.remainingCards.count == 81 - 12)
            XCTAssert(game!.selectedCards[0] == game!.dealtCards[0])
            game!.selectCard(at: 4)
            XCTAssert(game!.matchedCards.count == 3)
            XCTAssert(game!.dealtCards.count == 12, "Expected \(12) but  was \(game!.dealtCards.count)")
            XCTAssert(game!.selectedCards.count == 1)
            XCTAssert(game!.remainingCards.count == 81 - 12 - 3)
            XCTAssert(game!.selectedCards[0] == game!.dealtCards[4])
        }

        selectThreeAndReSelect()
        selectThreeAndSelectOther()
    }


    private func selectTwocards() {
        game!.selectCard(at: 0)
        game!.selectCard(at: 1)
    }

    private func selectThreeCards() {
        selectTwocards()
        game!.selectCard(at: 2)
    }

    private func findDuplicates(cards: [Card?]) -> Bool {
        var dup = false
        for i in cards.indices {
            for j in cards.indices {
                if (i != j && cards[i] == cards[j]) {
                    dup = true
                    break
                }
            }
        }
        return dup
    }
}

