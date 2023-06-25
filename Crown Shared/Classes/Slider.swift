import Foundation
import SpriteKit

class Slider: SKSpriteNode {
    
    enum BackgroundColor {
            case xSlider
            case ySlider
            case rotationSlider

            var color: UIColor {
                switch self {
                case .xSlider:
                    return #colorLiteral(red: 0.9568627451, green: 0.662745098, blue: 0.2156862745, alpha: 1)
                case .ySlider:
                    return #colorLiteral(red: 0.937254902, green: 0.2308279684, blue: 0.3821538478, alpha: 1)
                case .rotationSlider:
                    return #colorLiteral(red: 0.5411764706, green: 0.2156862745, blue: 0.9568627451, alpha: 1)
                }
            }
        }
    
    var slidingHandler: (CGFloat) -> () = {pos in}
    var scrollCenter: SKSpriteNode!
    var isHorizontal = false
    init (length: CGFloat, isHorizontal: Bool, backgroundColor: BackgroundColor) {
        self.isHorizontal = isHorizontal
        let b: CGFloat = 15
        let a = length
        let shapeSize = isHorizontal ? CGSize(width: a, height: b) : CGSize(width: b, height: a)
        super.init(texture: nil, color: .clear, size: shapeSize)
        self.isUserInteractionEnabled = true
        self.zPosition = 1
        
        let bg = SKShapeNode(rect: CGRect(x: -shapeSize.width/2, y: -shapeSize.height/2, width: shapeSize.width, height: shapeSize.height), cornerRadius: b/2)
        bg.name = "background"
        bg.strokeColor = #colorLiteral(red: 0.1843137255, green: 0.1843137255, blue: 0.1843137255, alpha: 1)
        bg.lineWidth = 1
        bg.fillColor = backgroundColor.color
        bg.zPosition = self.zPosition
        addChild(bg)
        
        let centerTexture = SKTexture(imageNamed: "ellipseSlider")
        let centerSize = getSizeByHeight(texture: centerTexture, height: 2*b)
        scrollCenter = SKSpriteNode(texture: centerTexture, size: centerSize)
//        scrollCenter.run(.repeatForever(.rotate(byAngle: 4, duration: 2)))
        scrollCenter.color = .white
        scrollCenter.zPosition = bg.zPosition + 1
        scrollCenter.name = "center"
        addChild(scrollCenter)
        if (isHorizontal) {
            scrollCenter.position.x = -shapeSize.width/2
        } else {
            scrollCenter.position.y = -shapeSize.height/2
        }
    }
    
    var isReversed = false
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let positionInNode = touches.first!.location(in: self)
        if (isHorizontal) {
            guard positionInNode.x < frame.width/2 && positionInNode.x > -frame.width/2 else {return}
            let coef: CGFloat = positionInNode.x < 0 ? -1 : 1
            let data = coef * abs(positionInNode.x / (frame.width/2))
            scrollCenter.run(.moveTo(x: positionInNode.x, duration: 0.05))
            slidingHandler(data)
//            print("horizontal data",data)
        } else {
            guard positionInNode.y < frame.height/2 && positionInNode.y > -frame.height/2 else {return}
//            print(positionInNode.y)
            let coef: CGFloat = positionInNode.y < 0 ? -1 : 1
            let data = coef * abs(positionInNode.y / (frame.height/2))
            scrollCenter.run(.moveTo(y: positionInNode.y, duration: 0.05))
            slidingHandler(data)
//            print("data",data)
        }
    }
    
    func getSizeByHeight(texture: SKTexture, height: CGFloat) -> CGSize {
      let ratio = height/texture.size().height
      let size = CGSize(width: texture.size().width * ratio, height: height)
      return size
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
