import SwiftUI
import SpriteKit

class OptionsScene: SKScene {
    
    
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
        
        
        //sound
        
        let soundLabel = SKLabelNode(text: "Sound")
        soundLabel.fontSize = 34
        soundLabel.fontColor = .white
        soundLabel.fontName = "Calibri-Bold"
        soundLabel.position = CGPoint(x: size.width/2, y: size.height/2 + 50)
        soundLabel.zPosition = 1
        addChild(soundLabel)
        
        
        let soundSprite = SKSpriteNode(imageNamed: "ToggleOff")
        if(AppManager.shared.soundStatus) {
            soundSprite.texture = SKTexture(imageNamed: "ToggleOn")
        }
        soundSprite.position = CGPoint(x: size.width/2, y: soundLabel.position.y - 50)
        soundSprite.zPosition = 1
        soundSprite.scale(to: CGSize(width: 96, height: 48))
        soundSprite.name = "soundToggle"
        addChild(soundSprite)
        
        //voice over
        
        let voiceOverLabel = SKLabelNode(text: "Voice Over")
        voiceOverLabel.fontSize = 34
        voiceOverLabel.fontName = "Calibri-Bold"
        voiceOverLabel.fontColor = .white
        voiceOverLabel.position = CGPoint(x: size.width/2, y: soundSprite.position.y - 100)
        voiceOverLabel.zPosition = 1
        addChild(voiceOverLabel)
        
        let voiceOverSprite = SKSpriteNode(imageNamed: "ToggleOff")
        if(AppManager.shared.voiceOverStatus) {
            voiceOverSprite.texture = SKTexture(imageNamed: "ToggleOn")
        }
        voiceOverSprite.position = CGPoint(x: size.width/2, y: voiceOverLabel.position.y - 50)
        voiceOverSprite.name = "voiceOverToggle"
        voiceOverSprite.scale(to: CGSize(width: 96, height: 48))
        voiceOverSprite.zPosition = 1
        addChild(voiceOverSprite)
    
        
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
                if(name.contains("Button") && AppManager.shared.soundStatus) {
                    SoundManager.shared.playSound(soundName: "A0", fileType: "mp3")
                }
                switch name {
                case "backButton":
                    if let backButton = touchedNode as? SKSpriteNode {
                        let menuScene = MenuScene(size: size)
                        menuScene.scaleMode = scaleMode
                        performTransition(nextScene: menuScene, button: backButton)
                    }
                case "soundToggle":
                    if let soundToggle = touchedNode as? SKSpriteNode {
                        AppManager.shared.soundStatus.toggle()
                        AppManager.shared.animateToggle(toggle: soundToggle, toggleState: AppManager.shared.soundStatus)
                    }
                    break
                case "voiceOverToggle":
                    if let voiceOverToggle = touchedNode as? SKSpriteNode {
                        AppManager.shared.voiceOverStatus.toggle()
                        AppManager.shared.animateToggle(toggle: voiceOverToggle, toggleState: AppManager.shared.voiceOverStatus)
                    }
                    break
                default:
                    break
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
