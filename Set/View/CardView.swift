import Foundation
import UIKit

class CardView: UIView {
    private let SMALL_INSET = CGFloat(2)
    private let MEDIUM_INSET = CGFloat(5)
    private let BIG_INSET = CGFloat(10)
    private var card: Card? = nil
    var isSelected = false

    convenience init(card: Card) {
        self.init(frame: CGRect.zero)
        self.card = card
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        backgroundColor = UIColor.white.withAlphaComponent(CGFloat(0))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func draw(_ rect: CGRect) {

        drawBackground(rect: rect)
        drawSymbols()
    }

    private func drawSymbols() {
        let rects = getRecs()
        for rect in rects {
            drawShapeInRec(rect)
        }
    }

    private func drawShapeInRec(_ rect: CGRect) {
        let shape = getShape(rect)
        let color = getColor()
        colorShape(shape, color, rect)
    }

    private func colorShape(_ shape: UIBezierPath, _ color: UIColor, _ rect: CGRect) {
        if let shading = card?.shading {
            switch (shading) {
            case Shading.FIRST:
                color.setFill()
                shape.fill()
            case Shading.SECOND:
                color.setStroke()
                shape.stroke()
            case Shading.THIRD:
                color.setStroke()
                shape.stroke()
                stripes(shape, color, rect)
            }
        }
    }

    private func stripes(_ shape: UIBezierPath, _ color: UIColor, _ rect: CGRect) {
        UIGraphicsGetCurrentContext()?.saveGState()
        shape.addClip()
        for stride in stride(from: 0, to: rect.maxX, by: CGFloat(5)) {
            let line = UIBezierPath()
            let start = CGPoint(x: rect.minX + stride, y: rect.minY)
            line.move(to: start)
            let end = CGPoint(x: rect.minX + stride, y: rect.maxY)
            line.addLine(to: end)
            color.setStroke()
            line.stroke()
        }
        UIGraphicsGetCurrentContext()?.restoreGState()
    }

    private func getShape(_ rect: CGRect) -> UIBezierPath {
        if let shape = card?.shape {
            switch (shape) {
            case Shape.FIRST: return getDiamond(rect)
            case Shape.SECOND: return getRect(rect)
            case Shape.THIRD:return getCircle(rect)
            }
        }
        fatalError("Shape cannot be null")
    }

    private func getCircle(_ rect: CGRect) -> UIBezierPath {
        let x: CGFloat = rect.minX + ((rect.width - rect.height) / 2)
        let square: CGRect = CGRect(x: x, y: rect.minY, width: rect.height, height: rect.height)
        return UIBezierPath(ovalIn: square)
    }

    private func getRect(_ rect: CGRect) -> UIBezierPath {
        return UIBezierPath(roundedRect: rect, cornerRadius: BIG_INSET)
    }

    private func getDiamond(_ rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let halfY = rect.minY + rect.height / 2
        let halfX = rect.minX + rect.width / 2
        let startPoint = CGPoint(x: rect.minX, y: halfY)
        path.move(to: startPoint)
        path.addLine(to: CGPoint(x: halfX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: halfY))
        path.addLine(to: CGPoint(x: halfX, y: rect.maxY))
        path.close()
        return path
    }

    private func getColor() -> UIColor {
        if let color = card?.color {
            switch (color) {
            case Color.FIRST: return UIColor.red
            case Color.SECOND: return UIColor.blue
            case Color.THIRD: return UIColor.green
            }
        }
        fatalError("Shape cannot be null")
    }

    private func getRecs() -> [CGRect] {
        var rects: [CGRect] = []
        let rect = getFrameWithInset(rect: bounds)
        if (card?.number == 3) {
            let firstDivision = rect.divided(atDistance: rect.height / 3, from: CGRectEdge.minYEdge)
            let secondDivision = getHalf(rect: firstDivision.remainder)
            rects = [firstDivision.slice, secondDivision.slice, secondDivision.remainder]
            rects = addInsets(rects)
            return rects
        }
        if (card?.number == 1) {
            let firstDivision = rect.divided(atDistance: rect.height / 3, from: CGRectEdge.minYEdge)
            let secondDivision = getHalf(rect: firstDivision.remainder)
            rects = [secondDivision.slice]
            rects = addInsets(rects)
            return rects
        }
        if (card?.number == 2) {
            let firstDivision = rect.divided(atDistance: rect.height / 3, from: CGRectEdge.minYEdge)
            let secondDivision = getHalf(rect: firstDivision.remainder)
            rects = [firstDivision.slice, secondDivision.remainder]
            rects = addInsets(rects)
            return rects
        }
        fatalError("Invalid number!")
    }

    private func addInsets(_ rects: [CGRect]) -> [CGRect] {
        var result: [CGRect] = []
        for rect in rects {
            result.append(rect.insetBy(dx: MEDIUM_INSET, dy: MEDIUM_INSET))
        }
        return result
    }

    private func getHalf(rect: CGRect) -> (slice: CGRect, remainder: CGRect) {
        let rects = rect.divided(atDistance: rect.height / 2, from: CGRectEdge.minYEdge)
        return rects
    }

    private func drawBackground(rect: CGRect) {
        let cardbackGround = drawCard(rect: rect)
        let color = isSelected ? UIColor.yellow : UIColor.white
        color.setFill()
        cardbackGround.fill()
    }

    private func drawCard(rect: CGRect) -> UIBezierPath {
        var inset = getFrameWithInset(rect: rect)
        let cardbackGround = UIBezierPath(roundedRect: inset, cornerRadius: MEDIUM_INSET)
        return cardbackGround
    }

    private func getFrameWithInset(rect: CGRect) -> CGRect {
        return rect.insetBy(dx: BIG_INSET, dy: BIG_INSET)
    }

}
