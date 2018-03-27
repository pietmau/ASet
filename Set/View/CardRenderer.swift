import Foundation
import UIKit

protocol CardRenderer {

    func renderCards(_ cards: [UIButton]!, _ cards1: [Card?])

    func setCardsSelected(_ buttons: [UIButton]!, _ dealtCards: [Card?], _ selectedCards: [Card])
}
