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
        appleBackground.position = CGPoint(x: size.width/2, y: -20)
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
                    SoundManager.shared.playSound(soundName: "A0", fileType: "mp3")
                }
                switch name {                
                case "appleBackground":
                    if(!AppManager.shared.pauseStatus){
                        guard let background = self.childNode(withName: "appleBackground"),
                              let label = self.childNode(withName: "labelTap") else { return }
                        animateScale(node: background)
                        animateScale(node: label)
                        transitionToPresentationScene()
                    }
                    break
                default:
                    break
                }
            }
        }
    }
    func animateScale(node: SKNode) {
        let scale = SKAction.scale(by: 2, duration: 2)
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
        let label = SKLabelNode(text: "Let's go to the Apple Park!\n       Tap on the Screen!")
        label.fontName = AppManager.shared.appFont
        label.fontSize = 64
        label.numberOfLines = 2
        label.fontColor = .white
        label.position = CGPoint(x: self.size.width/2, y: self.size.height/9)
        label.alpha = 0
        label.zPosition = 3
        label.name = "labelTap"
        

        self.addChild(label)
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

    }
   
    
}
