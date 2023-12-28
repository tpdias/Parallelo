import SwiftUI
import SpriteKit

class OptionsScene: SKScene {
    var toggleState: Bool = false
    override func didMove(to view: SKView) {

        //Background
        let background = SKSpriteNode(imageNamed: "backgroundImage")
        background.scale(to: size)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        addChild(background)        
        
        // Options Label
        let titleOptions = SKSpriteNode(imageNamed: "titleOptions")
        titleOptions.scale(to: CGSize(width: 200, height: 100))
        titleOptions.position = CGPoint(x: size.width / 2, y: size.height / 2 + 200)
        titleOptions.zPosition = 1
        addChild(titleOptions)
        
        let toggle = SKSpriteNode(imageNamed: "ToggleOff")
        toggle.scale(to: CGSize(width: 192, height: 96))
        toggle.position = CGPoint(x: size.width/2, y: size.height/2)
        toggle.zPosition = 1
        toggle.name = "toggle"
        addChild(toggle)
        
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
                    SoundManager.shared.playSound(soundName: "A0", fileType: "mp3")
                    if let backButton = touchedNode as? SKSpriteNode {
                        let menuScene = MenuScene(size: size)
                        menuScene.scaleMode = scaleMode
                        performTransition(nextScene: menuScene, button: backButton)
                    }
                }
                else if name == "toggle" {
                    if let toggleButton = touchedNode as? SKSpriteNode {
                        animateToggle(toggle: toggleButton)
                        self.toggleState.toggle()
                    }
                }
            }
        }
    }
    func animateToggle(toggle: SKSpriteNode) {
        let transitionTexture = SKTexture(imageNamed: "ToggleTransition")
        var nextTexture = SKTexture()
        if(self.toggleState){
            nextTexture = SKTexture(imageNamed: "ToggleOff")
        } else {
            nextTexture = SKTexture(imageNamed: "ToggleOn")
        }
                
        let changeToTransition = SKAction.setTexture(transitionTexture)
        let wait = SKAction.wait(forDuration: 0.1)
        let changeToOn = SKAction.setTexture(nextTexture)
        
        let sequence = SKAction.sequence([changeToTransition, wait, changeToOn])
        
        toggle.run(sequence)
    }
    func performTransition(nextScene: SKScene, button: SKSpriteNode) {
        button.texture = SKTexture(imageNamed: "BackButtonPressed")
        let waitForAnimation = SKAction.wait(forDuration: 0.2)
        
#warning("lembrar de colocar um opacity aqui pra dar blur, um blur seria daora")
        // Run the action on the whole scene
        self.run(waitForAnimation) {
            // Transition to the next scene after the fade-out effect
            self.view?.presentScene(nextScene)
        }
    }
}
