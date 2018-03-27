import Foundation
import UIKit

class GridView: UIView {
    private var grid: Grid? = nil
    var callback: GridViewCallback? = nil

    public var ratio: CGFloat = STANDARD_RATIO {
        didSet {
            setNeedsLayout()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setBackground()
    }

    private func setBackground() {
        backgroundColor = UIColor.orange
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setBackground()
    }

    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        layoutSubviews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        calculateGrid()
        layoutViews()
    }

    private func layoutViews() {
        for index in 0..<subviews.count {
            var view: UIView = subviews[index]
            if let frame = grid?[index] {
                view.frame = frame
            }
        }
    }

    private func calculateGrid() {
        grid = Grid(layout: Grid.Layout.aspectRatio(ratio), frame: bounds)
        grid?.cellCount = subviews.count
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as? UITouch {
            let location = touch.location(in: self)
            if let grid = grid {
                for index in 0..<(grid.cellCount) {
                    if (grid[index]?.contains(location) == true) {
                        callback?.onCardClicked(index: index)
                    }
                }
            }
        }
    }
}

protocol GridViewCallback {
    func onCardClicked(index: Int)
}


extension GridView {

    public static let STANDARD_RATIO: CGFloat = 5 / 8

}
