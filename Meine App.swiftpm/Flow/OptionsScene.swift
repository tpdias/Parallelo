import SwiftUI
import SpriteKit

class OptionsScene: SKScene {
    override func didMove(to view: SKView) {
        
        //Background
        let background = SKSpriteNode(imageNamed: "ApplePark")
        background.scale(to: size)
        background.position = CGPoint(x: size.width/2, y: size.height/2 - 25)
        background.zPosition = -1
        addChild(background)        
        
        
        // First Line
        let firstLineLabel = SKLabelNode(text: "Options")
        firstLineLabel.fontName = AppManager.shared.appFont
        firstLineLabel.fontColor = .white
        firstLineLabel.fontSize = 48
        firstLineLabel.horizontalAlignmentMode = .center
        firstLineLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 200)
        firstLineLabel.zPosition = 2
        addChild(firstLineLabel)
        
        
        // First Line
        let firstLineLabelB = SKLabelNode(text: "Options")
        firstLineLabelB.fontName = AppManager.shared.appFont
        firstLineLabelB.fontColor = .black
        firstLineLabelB.fontSize = 48
        firstLineLabelB.horizontalAlignmentMode = .center
        firstLineLabelB.position = CGPoint(x: size.width / 2 - 8, y: size.height / 2 + 200 - 5)
        firstLineLabelB.zPosition = 1
        addChild(firstLineLabelB)
        
        
        //sound
        
        let soundLabel = SKLabelNode(text: "Sound")
        soundLabel.fontSize = 34
        soundLabel.fontColor = .white
        soundLabel.fontName = AppManager.shared.appFont
        soundLabel.position = CGPoint(x: size.width/2, y: size.height/2 + 50)
        soundLabel.zPosition = 1
        addChild(soundLabel)
        
        
        let soundSprite = SKSpriteNode(imageNamed: AppManager.shared.soundStatus ? "ToggleOn" : "ToggleOff")
        soundSprite.position = CGPoint(x: size.width/2, y: soundLabel.position.y - 50)
        soundSprite.zPosition = 1
        soundSprite.scale(to: CGSize(width: 96, height: 48))
        soundSprite.name = "soundToggle"
        addChild(soundSprite)
        
        //voice over
        
        let voiceOverLabel = SKLabelNode(text: "Voice Over")
        voiceOverLabel.fontSize = 34
        voiceOverLabel.fontName = AppManager.shared.appFont
        voiceOverLabel.fontColor = .white
        voiceOverLabel.position = CGPoint(x: size.width/2, y: soundSprite.position.y - 100)
        voiceOverLabel.zPosition = 1
        addChild(voiceOverLabel)
        
        let voiceOverSprite = SKSpriteNode(imageNamed: AppManager.shared.voiceOverStatus ? "ToggleOn" : "ToggleOff")
        voiceOverSprite.position = CGPoint(x: size.width/2, y: voiceOverLabel.position.y - 50)
        voiceOverSprite.name = "voiceOverToggle"
        voiceOverSprite.scale(to: CGSize(width: 96, height: 48))
        voiceOverSprite.zPosition = 1
        addChild(voiceOverSprite)
        
        let fontLabel = SKLabelNode(text: "OpenDyslexic Font")
        fontLabel.fontSize = 34
        fontLabel.fontName = AppManager.shared.appFont
        fontLabel.fontColor = .white
        fontLabel.position = CGPoint(x: size.width/2, y: voiceOverSprite.position.y - 100)
        fontLabel.zPosition = 1
        addChild(fontLabel)
        
        let fontSprite = SKSpriteNode(imageNamed: AppManager.shared.openDyslexicStatus ? "ToggleOn" : "ToggleOff")
        fontSprite.position = CGPoint(x: size.width/2, y: fontLabel.position.y - 50)
        fontSprite.name = "fontToggle"
        fontSprite.scale(to: CGSize(width: 96, height: 48))
        fontSprite.zPosition = 1
        addChild(fontSprite)
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
                    SoundManager.shared.playButtonSound()
                }
                if(name.contains("Toggle") && AppManager.shared.soundStatus) {
                    SoundManager.shared.playToggleSound()
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
                case "fontToggle":
                    if let fontToggle = touchedNode as? SKSpriteNode {
                        AppManager.shared.changeFont()
                        AppManager.shared.animateToggle(toggle: fontToggle, toggleState: AppManager.shared.openDyslexicStatus)
                        let scene = OptionsScene(size: self.size) 
                        scene.scaleMode = scaleMode
                        let wait = SKAction.wait(forDuration: 0.3)
                        self.run(wait){
                            self.view?.presentScene(scene)
                        }
                        
                        
                    }
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
