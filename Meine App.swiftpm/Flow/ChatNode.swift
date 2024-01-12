import SwiftUI
import SpriteKit

class ChatNode: SKNode {
    let nodeSize: CGSize
    init(nodeSize: CGSize, name: String, message: String) {
        self.nodeSize = nodeSize
        super.init()
        self.name = "chat"

        //Background
        let chatBackground = SKSpriteNode(imageNamed: "ChatBackground")
        chatBackground.anchorPoint = CGPoint(x: 0.5, y: 0)
        chatBackground.position = CGPoint(x: nodeSize.width / 2, y: 0)
        chatBackground.scale(to: CGSize(width: nodeSize.width, height: nodeSize.height))
        chatBackground.zPosition = 1
        addChild(chatBackground)
        //Name
        let nameLabel = SKLabelNode(text: name)
        nameLabel.position = CGPoint(x: 40, y: nodeSize.height - 10 - nameLabel.fontSize)
        nameLabel.zPosition = 2
        nameLabel.fontName = AppManager.shared.appFont
        nameLabel.fontSize = 28
        nameLabel.fontColor = .black
        nameLabel.horizontalAlignmentMode = .left
        addChild(nameLabel)
        //Message
        let message = SKLabelNode(text: message)
        message.position = CGPoint(x: 40, y: nameLabel.position.y - nameLabel.fontSize)
        message.zPosition = 2
        message.fontName = AppManager.shared.appFont
        message.fontSize = 28
        message.fontColor = .black
        message.horizontalAlignmentMode = .left
        addChild(message)
        
        //nextButton
        let nextButtonTemp = SKSpriteNode(imageNamed: "nextButtonGray")
        nextButtonTemp.position = CGPoint(x: nodeSize.width - 50 - 50, y: 50)
        nextButtonTemp.scale(to: CGSize(width: 50, height: 50))
        nextButtonTemp.zPosition = 2
        nextButtonTemp.name = "nextButtonGray"
        addChild(nextButtonTemp)
        changeButtonColor(button: nextButtonTemp)
        self.alpha = 0
        self.run(SKAction.fadeIn(withDuration: 2))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func changeButtonColor(button: SKSpriteNode) {
        let wait = SKAction.wait(forDuration: 2)
        button.run(wait){
            button.texture = SKTexture(imageNamed: "nextButtonGreen")
            button.name = "nextButtonGreen"
            print("chaning")
        }
    }
}
