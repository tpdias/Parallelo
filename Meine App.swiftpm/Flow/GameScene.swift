import SwiftUI
import SpriteKit

class GameScene: SKScene {    
    //pause
    var pauseNode: PauseNode
    
    override init(size: CGSize) {
        self.pauseNode = PauseNode(size: size)
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
       
        //Background
        let appleBackground: SKSpriteNode = SKSpriteNode(imageNamed: "ApplePark")
        appleBackground.scale(to: size)
        appleBackground.position = CGPoint(x: size.width/2, y: -25)
        appleBackground.name = "appleBackground"
        appleBackground.zPosition = 0
        appleBackground.anchorPoint = CGPoint(x: 0.5, y: 0)
        addChild(appleBackground)
        
        addChild(pauseNode)

        
        createLabelTap()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if let name = touchedNode.name {
                pauseNode.checkPauseNodePressed(view: self, touchedNode: touchedNode)
                if(name.contains("Button") && AppManager.shared.soundStatus) {
                    SoundManager.shared.playButtonSound()
                }
                if(name.contains("Toggle") && AppManager.shared.soundStatus) {
                    SoundManager.shared.playToggleSound()
                }
                    if(!AppManager.shared.pauseStatus){
                        guard let background = self.childNode(withName: "appleBackground"),
                              let label = self.childNode(withName: "labelTap"),
                              let secondLabel = self.childNode(withName: "labelTap2") else { return }
                        animateScale(node: background)
                        animateScale(node: label)
                        animateScale(node: secondLabel)
                        transitionToPresentationScene()
                    }
            }
        }
    }
    func animateScale(node: SKNode) {
        let scale = SKAction.scale(by: 1.5, duration: 2)
        let fade = SKAction.fadeOut(withDuration: 2)
        let actionGroup = SKAction.group([scale, fade])
        node.run(actionGroup)
    }
    override func update(_ currentTime: TimeInterval) {
       
    }
    
    func transitionToPresentationScene() {
        let wait = SKAction.wait(forDuration: 2)
        self.run(wait) {
            let presentation = PresentationScene(size: self.size)
            presentation.scaleMode = self.scaleMode
            self.view?.presentScene(presentation)
        }
        
    }   
        
    func createLabelTap() {
        let label = SKLabelNode(text: "Let's go to the Apple Park!")
        label.fontName = AppManager.shared.appFont
        label.fontSize = 64
        label.numberOfLines = 2
        label.fontColor = .white
        label.position = CGPoint(x: self.size.width/2, y: self.size.height/7)
        label.alpha = 0
        label.zPosition = 3
        label.name = "labelTap"
        
        let secondLine = SKLabelNode(text: "Tap on the Screen!")
        secondLine.fontName = AppManager.shared.appFont
        secondLine.fontSize = 64
        secondLine.numberOfLines = 2
        secondLine.fontColor = .white
        secondLine.position = CGPoint(x: self.size.width/2, y: label.position.y - 100) 
        secondLine.alpha = 0
        secondLine.zPosition = 3
        secondLine.name = "labelTap2"

        self.addChild(label)
        self.addChild(secondLine)

        let wait = SKAction.wait(forDuration: 1)
        let fade = SKAction.fadeIn(withDuration: 0.5)
        let scaleUp = SKAction.scale(by: 1.2, duration: 1.5)
        let scaleDown = SKAction.scale(by: 1.0/1.2, duration: 1.5)
        let fadeOut = SKAction.fadeAlpha(to: 0.3, duration: 1.5)
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 1.5)
        let fadeSequence = SKAction.sequence([fadeOut, fadeIn])
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        let sequence = SKAction.sequence([wait, fade])
        let group = SKAction.group([SKAction.repeatForever(fadeSequence), SKAction.repeatForever(scaleSequence)])
        label.run(sequence) {
            label.run(group)
        }
        secondLine.run(sequence) {
            secondLine.run(group)
        }

    }
   
    
}
