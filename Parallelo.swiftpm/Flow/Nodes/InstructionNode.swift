import SwiftUI
import SpriteKit

class InstructionNode: SKNode {
    let background: SKSpriteNode
    var instructionTitle: SKLabelNode
    var instructionLabel: SKLabelNode
    let startButton: SKSpriteNode
    let startButtonLabel: SKLabelNode
    
    init(instruction: String, title: String, size: CGSize) {
        background = SKSpriteNode(imageNamed: "OptionsBackground")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.scale(to: CGSize(width: size.width/1.2, height: size.height/1.3))
        background.zPosition = 3
        
        instructionTitle = SKLabelNode(text: title)
        instructionTitle.fontName = AppManager.shared.appFont
        instructionTitle.fontSize = 32
        instructionTitle.position = CGPoint(x: background.position.x, y: background.position.y + background.size.height / 3)
        instructionTitle.zPosition = 4
    
        instructionLabel = SKLabelNode(text: instruction)
        instructionLabel.fontName = AppManager.shared.appFont
        instructionLabel.fontSize = 24
        instructionLabel.position = CGPoint(x: instructionTitle.position.x, y: instructionTitle.position.y - instructionTitle.frame.size.height * 2 - 200)
        instructionLabel.zPosition = 4
        instructionLabel.numberOfLines = 10
        instructionLabel.preferredMaxLayoutWidth = background.size.width - 200 
        
        startButton = SKSpriteNode(imageNamed: "Button")
        startButton.scale(to: CGSize(width: 192, height: 96))
        startButton.position = CGPoint(x: instructionLabel.position.x, y: instructionLabel.position.y - 300)
        startButton.name = "startButton"
        startButton.zPosition = 4
        
        startButtonLabel = SKLabelNode(text: "START")
        startButtonLabel.fontSize = 24
        startButtonLabel.position = startButton.position
        startButtonLabel.fontColor = .black
        startButtonLabel.fontName = AppManager.shared.appFont
        startButtonLabel.name = "startLabel"
        startButtonLabel.zPosition = 5
        
        
        super.init()
        addChild(background)
        addChild(instructionTitle)
        addChild(instructionLabel)
        addChild(startButton)
        addChild(startButtonLabel)


   
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeButtonText(text: String) {
        self.startButtonLabel.text = text    
        self.startButton.name = text.lowercased() + "Button"
        self.startButtonLabel.name = text.lowercased() + "Label"
    }
    
    func changeInstruction(instruction: String, instructionTitle: String) {
        self.instructionLabel.text = instruction
        self.instructionTitle.text = instructionTitle
        self.startButton.texture = SKTexture(imageNamed: "Button")
        self.startButtonLabel.position.y += 10
    }
    func buttonPressed(){
        startButton.texture = SKTexture(imageNamed: "ButtonPressed")
        startButtonLabel.position.y -= 10
    }
}
