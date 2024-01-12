import SwiftUI
import SpriteKit

class CreditsScene: SKScene {
    override func didMove(to view: SKView) {        
        //Background
        let background = SKSpriteNode(imageNamed: "backgroundImage")
        background.scale(to: size)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        addChild(background)
        
        // Credits Label
        let titleCredits = SKSpriteNode(imageNamed: "titleCredits")
        titleCredits.scale(to: CGSize(width: 200, height: 100))
        titleCredits.position = CGPoint(x: size.width / 2, y: size.height / 2 + 200)
        titleCredits.zPosition = 1
        addChild(titleCredits)
        
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
                        SoundManager.shared.playSound(soundName: "A0", fileType: "mp3")
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
