import SwiftUI
import SpriteKit

class QuestionNode: SKNode {
    let backgroundSize: CGSize
    init(size: CGSize, label: String, index: Int) {
        self.backgroundSize = size
        super.init()
        let background = SKSpriteNode(imageNamed: "QuestionBackground")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.scale(to: CGSize(width: size.width/2, height: size.height/2))
        background.zPosition = 2
        background.name = "questionBackground" + String(index)
        addChild(background)
        
        let label = SKLabelNode(text: label)
        label.position = background.position
        label.fontName = AppManager.shared.appFont
        label.fontColor = .black
        label.fontSize = 32
        addChild(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
