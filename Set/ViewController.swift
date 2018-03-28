import UIKit

class ViewController: UIViewController, GridViewCallback {
    var game: Game = Game(matcher: Positivematcher())

    @IBOutlet weak var gameView: GameView!

    @IBOutlet weak var dealButton: UIButton!

    @IBAction func onDealClicked(_ sender: Any) {
        game.deal()
        updateView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gameView.callBack = self
        updateView()
    }

    private func updateView() {
        gameView.dealtCards = game.dealtCards
        gameView.selectedtCards = game.selectedCards
        if (game.canDeal) {
            dealButton.isEnabled = true
        } else {
            dealButton.isEnabled = false
        }
    }

    func onCardClicked(card: Card) {
        selectCard(card: card)
        updateView()
    }

    public func selectCard(card: Card) {
        if (game.selectedCards.count == 3) {
            isAMatchOrNot(card: card)
        } else if (game.selectedCards.count < 3) {
            game.selectOrDeselect(card)
        }
    }

    private func isAMatchOrNot(card: Card) {
        if (game.selectedCards.contains(card)) {
            return
        }
        if (game.isAMatch()) {
            onIsAMatch(card: card)
        }
        game.setSelectedOnlyLastCard(card: card)
    }


    private func onIsAMatch(card: Card) {
        game.matchedCards.append(contentsOf: game.selectedCards)
        if (game.canDeal) {
            game.deal()
        }
        game.removeMatched()
    }
}

