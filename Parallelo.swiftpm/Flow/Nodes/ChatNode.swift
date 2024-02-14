import SwiftUI
import SpriteKit

class ChatNode: SKNode {
    var textLabel: SKLabelNode 
    var nameLabel: SKLabelNode
    var chatBackground: SKSpriteNode
    init(nodeSize: CGSize, name: String, message: String) {
        //Background
        chatBackground = SKSpriteNode(imageNamed: "ChatBackground")
        chatBackground.anchorPoint = CGPoint(x: 0.5, y: 0)
        chatBackground.position = CGPoint(x: nodeSize.width / 2, y: 0)
        chatBackground.scale(to: CGSize(width: nodeSize.width, height: nodeSize.height))
        chatBackground.zPosition = 1
        //Name
        nameLabel = SKLabelNode(text: name)
        nameLabel.position = CGPoint(x: 40, y: nodeSize.height - 10 - nameLabel.fontSize)
        nameLabel.zPosition = 2
        nameLabel.fontName = AppManager.shared.appFont
        nameLabel.fontSize = 28
        nameLabel.fontColor = .white
        nameLabel.horizontalAlignmentMode = .left
        nameLabel.name = "nameLabel"
        //Message
//        let nLines = CGFloat((message.components(separatedBy: "\n")).count)
//        let offset:CGFloat = (28 * 2 * (nLines)) - (nLines - 1) * 15
        textLabel = SKLabelNode(text: message)
        textLabel.position = CGPoint(x: 40, y: nameLabel.position.y - 56)
        let labelHeight = textLabel.calculateAccumulatedFrame().height
        textLabel.position.y -= labelHeight / 2     
        textLabel.zPosition = 2
        textLabel.fontName = AppManager.shared.appFont
        textLabel.fontSize = 28
        textLabel.numberOfLines = 5
        textLabel.preferredMaxLayoutWidth = chatBackground.size.width - 100
        textLabel.fontColor = .white
        textLabel.horizontalAlignmentMode = .left
        textLabel.name = "message"
        super.init()
        addChild(nameLabel)
        addChild(textLabel)
        addChild(chatBackground)

        //nextButton
        let nextButtonTemp = SKSpriteNode(imageNamed: "RightButtonGray")
        nextButtonTemp.position = CGPoint(x: nodeSize.width - 50 - 50, y: 50)
        nextButtonTemp.scale(to: CGSize(width: 50, height: 50))
        nextButtonTemp.zPosition = 2
        nextButtonTemp.name = "nextButtonGray"
        addChild(nextButtonTemp)
        changeButtonColor(button: nextButtonTemp)
        
        self.name = "chat"
        self.alpha = 0
        self.run(SKAction.fadeIn(withDuration: 2))

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func changeButtonColor(button: SKSpriteNode) {
        let wait = SKAction.wait(forDuration: 2)
        button.run(wait){
            button.texture = SKTexture(imageNamed: "RightButton")
            button.name = "nextButtonGreen"
        }
    }
    func changeText(text: String) {
        self.textLabel.text = text
        textLabel.position = CGPoint(x: 40, y: nameLabel.position.y - 56)
        let labelHeight = textLabel.calculateAccumulatedFrame().height
        
        textLabel.position.y -= labelHeight / 2
       // let nLines = CGFloat((text.components(separatedBy: "\n")).count)
       // let offset:CGFloat = /*((nLines + 1) * 2) +*/ (textLabel.fontSize * 2 * (nLines)) - (nLines - 1) * 15
       // self.textLabel.position.y = nameLabel.position.y - offset
    }
}
