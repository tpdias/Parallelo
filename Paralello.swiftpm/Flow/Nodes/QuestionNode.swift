import SwiftUI
import SpriteKit

class QuestionNode: SKNode {
    var questions: [SingleQuestionNode]
    var size: CGSize    
    var relativePosition: CGPoint
    init(size: CGSize, position: CGPoint, questions: [String]) {
        self.size = size
        self.relativePosition = position
        self.questions = []
        super.init()
        for i in 0..<questions.count {
            let questionNode = SingleQuestionNode(size: size, position: position, label: questions[i], index: i)
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
    func addQuestions(questions: [String]) {
        for i in 0..<questions.count {
            let questionNode = SingleQuestionNode(size: self.size, position: self.relativePosition, label: questions[i], index: i)
            questionNode.name = "singleQuestionNode" + String(i)
            self.addChild(questionNode)
            self.questions.append(questionNode)
        }
    }
}

class SingleQuestionNode: SKNode {
    let backgroundSize: CGSize
    let background: SKSpriteNode
    init(size: CGSize, position: CGPoint, label: String, index: Int) {
        self.backgroundSize = size
        
        background = SKSpriteNode(imageNamed: "ChatBackground")
        background.position = CGPoint(x: position.x / 2, y: position.y / 1.7 - CGFloat(70 * index))
        background.scale(to: CGSize(width: size.width/2, height: size.height/10))
        background.zPosition = 4
        background.name = "questionBackground" + String(index)
        
        super.init()
       
        addChild(background)
        
        let label = SKLabelNode(text: label)
        label.position = CGPoint(x: background.position.x, y: background.position.y - 5)
        label.fontName = AppManager.shared.appFont
        label.fontColor = .white
        label.zPosition = 5
        label.fontSize = 24
        label.name = "questionLabel" + String(index)
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
