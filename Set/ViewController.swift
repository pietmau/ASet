import UIKit

class ViewController: UIViewController, GridViewCallback, GameCallback {
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
        gameView.deckPosition = dealButton.frame
        game.callback = self
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
        game.selectCard(card: card)
        updateView()
    }

    func onMatch() {
        gameView.animateExit(game.matchedCards)
        deal()
    }

    private func deal() {
        game.deal()
        updateView()
    }
}

