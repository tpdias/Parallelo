import SwiftUI
import SpriteKit

class SignNode: SKNode {
    var sprite: SKSpriteNode
    var label: SKLabelNode
    var sign: SKSpriteNode
    
    init(spriteName: String, text: String, position: CGPoint, size: CGSize) {
        self.sprite = SKSpriteNode(imageNamed: spriteName)
        sprite.position = position
        sprite.scale(to: size)
        sprite.zPosition = 3
        
        label = SKLabelNode(text: text)
        label.fontName = AppManager.shared.appFont
        label.fontSize = 24
        label.position = CGPoint(x: sprite.position.x, y: sprite.position.y + sprite.size.height/2 + 10)
        label.fontColor = .black
        
        sign = SKSpriteNode(imageNamed: "SignBackground")
        sign.position = sprite.position
        sign.scale(to: CGSize(width: sprite.size.width + 20, height: sprite.size.height + 10))
        sign.zPosition = 2
        
        super.init()
        addChild(sprite)
        addChild(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

