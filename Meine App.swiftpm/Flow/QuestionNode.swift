import SwiftUI
import SpriteKit

class QuestionNode: SKNode {
    init(size: CGSize, questions: [String]) {
        super.init()
        for i in 0..<feelingQuestion.count {
            let questionNode = SingleQuestionNode(size: size, label: feelingQuestion[i], index: i)
            questionNode.name = "singleQuestionNode" + String(i)
            self.addChild(questionNode)
        }
        self.alpha = 0
        let animation = SKAction.fadeIn(withDuration: 1)
        self.run(animation)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SingleQuestionNode: SKNode {
    let backgroundSize: CGSize
    init(size: CGSize, label: String, index: Int) {
        self.backgroundSize = size
        super.init()
        let background = SKSpriteNode(imageNamed: "ChatBackground")
        background.position = CGPoint(x: size.width/2, y: size.height/1.7 - CGFloat(110 * index))
        background.scale(to: CGSize(width: size.width/2, height: size.height/10))
        background.zPosition = 4
        background.name = "questionBackground" + String(index)
        addChild(background)
        
        let label = SKLabelNode(text: label)
        label.position = background.position
        label.fontName = AppManager.shared.appFont
        label.fontColor = .white
        label.zPosition = 5
        label.fontSize = 32
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
