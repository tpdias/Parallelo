import SwiftUI
import SpriteKit

class CreditsScene: SKScene {
    override func didMove(to view: SKView) {        
        //Background
        let background = SKSpriteNode(imageNamed: "ApplePark")
        background.scale(to: size)
        background.position = CGPoint(x: size.width/2, y: size.height/2 - 25)
        background.zPosition = -1
        addChild(background)
        
        // First Line
        let firstLineLabel = SKLabelNode(text: "Credits")
        firstLineLabel.fontName = AppManager.shared.appFont
        firstLineLabel.fontColor = .white
        firstLineLabel.fontSize = 48
        firstLineLabel.horizontalAlignmentMode = .center
        firstLineLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 200)
        firstLineLabel.zPosition = 2
        addChild(firstLineLabel)
        
        
        // First Line
        let firstLineLabelB = SKLabelNode(text: "Credits")
        firstLineLabelB.fontName = AppManager.shared.appFont
        firstLineLabelB.fontColor = .black
        firstLineLabelB.fontSize = 48
        firstLineLabelB.horizontalAlignmentMode = .center
        firstLineLabelB.position = CGPoint(x: size.width / 2 - 8, y: size.height / 2 + 200 - 5)
        firstLineLabelB.zPosition = 1
        addChild(firstLineLabelB)
        
        
        //Back Button, return to menu on click
        let backButton = SKSpriteNode(imageNamed: "BackButton")
        backButton.scale(to: CGSize(width: 50, height: 50))
        backButton.position = CGPoint(x: 100, y: size.height - 100)
        backButton.zPosition = 1
        backButton.name = "backButton"
        addChild(backButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if let name = touchedNode.name {
                if name == "backButton" {
                    // Voltar para o menu principal
                    if(AppManager.shared.soundStatus){
                        SoundManager.shared.playButtonSound()
                    }
                    if let backButton = touchedNode as? SKSpriteNode {
                        let menuScene = MenuScene(size: size)
                        menuScene.scaleMode = scaleMode
                        performTransition(nextScene: menuScene, button: backButton)
                    }
                }
            }
        }
    }
    func performTransition(nextScene: SKScene, button: SKSpriteNode) {
        button.texture = SKTexture(imageNamed: "BackButtonPressed")
        let waitForAnimation = SKAction.wait(forDuration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.4)
        
        let sequence = SKAction.sequence([waitForAnimation, fadeOut])
        
        // Run the action on the whole scene
        self.run(sequence) {
            // Transition to the next scene after the fade-out effect
            self.view?.presentScene(nextScene)
        }
    }
}
