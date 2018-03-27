import UIKit

class ViewController: UIViewController, GridViewCallback {
    var game: Game = GameImpl(matcher: Positivematcher())

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

    func onCardClicked(index: Int) {
        game.selectCard(at: index)
        updateView()
    }
}

