import SwiftUI
import SpriteKit

class PauseNode: SKNode {
    var pauseButton: SKSpriteNode
    var resumeButton: SKSpriteNode
    var homeButton: SKSpriteNode
    var configButton: SKSpriteNode
    var optionNode: OptionsNode?

    init(size: CGSize) {
        //pause button
        let pauseButton = SKSpriteNode(imageNamed: "PauseButton")
        pauseButton.scale(to: CGSize(width: 48, height: 48))
        pauseButton.position = CGPoint(x: size.width - 100, y: size.height - 100)
        pauseButton.zPosition = 6
        pauseButton.name = "pauseButton"
        self.pauseButton = pauseButton
        
        //resume button
        let resumeButton = SKSpriteNode(imageNamed: "ResumeButton")
        resumeButton.scale(to: CGSize(width: 144, height: 144))
        resumeButton.position = CGPoint(x: size.width/2, y: size.height/2)
        resumeButton.zPosition = 6
        resumeButton.name = "resumeButton"
        self.resumeButton = resumeButton
        
        //home button
        let homeButton = SKSpriteNode(imageNamed: "HomeButton")
        homeButton.scale(to: CGSize(width: 96, height: 96))
        homeButton.position = CGPoint(x: size.width/2 - 200, y: size.height/2 - 48)
        homeButton.zPosition = 6
        homeButton.name = "homeButton"
        self.homeButton = homeButton
        //configuration button
        let configButton = SKSpriteNode(imageNamed: "ConfigButton")
        configButton.scale(to: CGSize(width: 96, height: 96))
        configButton.position = CGPoint(x: size.width/2 + 200, y: size.height/2 - 48)
        configButton.zPosition = 6
        configButton.name = "configButton"
        self.configButton = configButton
        
        super.init()
        self.addChild(pauseButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateResumeButton() {
        resumeButton.texture = SKTexture(imageNamed: "ResumeButtonPressed")
        let waitForAnimation = SKAction.wait(forDuration: 0.2)   
        let sequence = SKAction.sequence([waitForAnimation])
        resumeButton.run(sequence) { 
            AppManager.shared.changePauseStatus(pauseNode: self)
            self.resumeButton.texture = SKTexture(imageNamed: "ResumeButton")
        }
    }
    func animatePauseButton() {
        pauseButton.texture = SKTexture(imageNamed: "PauseButtonPressed")
        let wait = SKAction.wait(forDuration: 0.2)
        pauseButton.run(wait) {
            AppManager.shared.changePauseStatus(pauseNode: self)
            self.pauseButton.texture = SKTexture(imageNamed: "PauseButton")
        }
    }
    
    func animateConfigButton(size: CGSize) {
        configButton.texture = SKTexture(imageNamed: "ConfigButtonPressed")
        let wait = SKAction.wait(forDuration: 0.2)
        configButton.run(wait) {
            let optionsNode = OptionsNode(size: CGSize(width: size.width, height: size.height))
            optionsNode.name = "optionsNode"
            optionsNode.position = CGPoint(x: size.width/2, y: size.height/2)
            optionsNode.zPosition = 2
            self.addChild(optionsNode)
            self.configButton.texture = SKTexture(imageNamed: "ConfigButton")
        }
    }
    
    func animateHomeButton(view: SKScene) {
        homeButton.texture = SKTexture(imageNamed: "HomeButtonPressed")
        let waitForAnimation = SKAction.wait(forDuration: 0.2)   
        let fadeOut = SKAction.fadeOut(withDuration: 0.4)
        let sequence = SKAction.sequence([waitForAnimation, fadeOut])
        view.run(sequence) { 
            AppManager.shared.changePauseStatus(pauseNode: self)
            let menuScene = MenuScene(size: view.size)
            menuScene.scaleMode = view.scaleMode
            view.view?.presentScene(menuScene)    
        }
    }
    
    
    func checkPauseNodePressed(view: SKScene, touchedNode: SKNode) {
        switch touchedNode.name {
        case "pauseButton":  
            animatePauseButton()    
            break
        case "resumeButton":
            animateResumeButton()
            break
        case "homeButton":
            animateHomeButton(view: view)
            break
        case "configButton":
            animateConfigButton(size: view.size)                   
            break
        case "closeButton":
            if let optionNode = self.childNode(withName: "optionsNode") {
                if let closeButton = touchedNode as? SKSpriteNode {
                    AppManager.shared.animateButton(button: closeButton, textureName: "CloseButton")
                    let wait = SKAction.wait(forDuration: 0.3)
                    self.run(wait) {
                        optionNode.removeFromParent()
                    }
                }
            }
            break
        case "soundToggle":
            if let soundToggle = touchedNode as? SKSpriteNode {
                AppManager.shared.changeSoundStatus()
                AppManager.shared.animateToggle(toggle: soundToggle, toggleState: AppManager.shared.soundStatus)
            }
            break
        case "fontToggle":
            if let fontToggle = touchedNode as? SKSpriteNode {
                AppManager.shared.changeFont()
                AppManager.shared.animateToggle(toggle: fontToggle, toggleState: AppManager.shared.openDyslexicStatus)
            }
        default:
            break
        }
    }
}
