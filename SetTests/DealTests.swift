import XCTest
@testable import Set

public class DealTests: XCTestCase {
    public var game: Game? = nil

    public override func setUp() {
        super.setUp()
        game = GameImpl(matcher: NegativeMatcher())
    }

    public override func tearDown() {
        super.tearDown()
    }

    func test_deal() {
        let initialCards = game!.dealtCards
        game!.deal()
        let finalCards = game!.dealtCards
        XCTAssert(finalCards.count == initialCards.count + 3)
        XCTAssert(finalCards.count == 15)
        XCTAssert(game!.selectedCards.count == 0)
    }

    func test_match_and_deal() {
        game = GameImpl(matcher: Positivematcher())
        game!.selectCard(at: 0)
        game!.selectCard(at: 1)
        game!.selectCard(at: 2)
        XCTAssert(game!.dealtCards.count == 12)
        game!.selectCard(at: 3)
        XCTAssert(game!.dealtCards.count == 12)
        XCTAssert(game!.matchedCards.count == 3)
        XCTAssert(game!.selectedCards.count == 1, "Expected \(1) but was \(game!.selectedCards.count)")
        XCTAssert(game!.remainingCards.count == 81 - 12 - 3)
    }

}

