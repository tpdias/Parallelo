import SwiftUI
import SpriteKit

let conclusionText: [String] = [
"Thanks for comming!"
]

class ConclusionScene: SKScene {
    let background: SKSpriteNode
    let steve: SKSpriteNode
    let pauseNode: PauseNode
    let chatNode: ChatNode
    var curText = 0
    
    override init(size: CGSize) {
        background = SKSpriteNode(imageNamed: "RainbowBackground")
        background.scale(to: size)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        background.name = "background"
    
        //Steve
        steve = SKSpriteNode(imageNamed: "Steve0")
        steve.scale(to: CGSize(width: size.width/2, height: size.width/2))
        steve.position = CGPoint(x: size.width/2, y: size.height/2)
        steve.zPosition = 1
        steve.name = "steve"
        let textures = [SKTexture(imageNamed: "Steve0"), SKTexture(imageNamed: "Steve1")]
        let action = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.7, resize: false, restore: true))
        steve.run(action)
        
        pauseNode = PauseNode(size: size)
        
        chatNode = ChatNode(nodeSize: CGSize(width: size.width, height: size.height/4), name: "Steve Jobs", message: conclusionText[curText])
        
        
        super.init(size: size)
        addChild(background)
        addChild(steve)
        addChild(chatNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}
