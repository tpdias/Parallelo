import SwiftUI
import SpriteKit

class GameScene: SKScene {
    //characters
    #warning("depois reolhar se precisa do player")
    //var player: Player = Player()   
    
    //pause
    var pauseStatus: Bool = false
    var pauseButton: SKSpriteNode? = nil
    var resumeButton: SKSpriteNode? = nil
    var homeButton: SKSpriteNode? = nil
    var configButton: SKSpriteNode? = nil
    
    
    override func didMove(to view: SKView) {
       
        //Background
        let appleBackground: SKSpriteNode = SKSpriteNode(imageNamed: "Background")
        appleBackground.scale(to: size)
        appleBackground.position = CGPoint(x: size.width/2, y: 0)
        appleBackground.name = "appleBackground"
        appleBackground.zPosition = 0
        appleBackground.anchorPoint = CGPoint(x: 0.5, y: 0)
        addChild(appleBackground)
        
        let factory: SKSpriteNode = SKSpriteNode(imageNamed: "Factory")
        factory.scale(to: CGSize(width: 750, height: 500))
        factory.position = CGPoint(x: size.width/2, y: size.height/4)
        factory.anchorPoint = CGPoint(x: 0.5, y: 0)
        factory.name = "factory"
        addChild(factory)
        
        //door
        let door: SKSpriteNode = SKSpriteNode(imageNamed: "MainDoor")
        door.scale(to: CGSize(width: 48, height: 64))
        door.position = CGPoint(x: factory.position.x, y: factory.position.y)
        door.zPosition = 1
        door.name = "mainDoor"
        door.anchorPoint = CGPoint(x: 0.5, y: 0)
        addChild(door)
        
        //pause button
        let pauseButton = SKSpriteNode(imageNamed: "pauseButton")
        pauseButton.scale(to: CGSize(width: 48, height: 48))
        pauseButton.position = CGPoint(x: size.width - 100, y: size.height - 100)
        pauseButton.zPosition = 1
        pauseButton.name = "pauseButton"
        self.pauseButton = pauseButton
        addChild(pauseButton)
        
        //resume button
        let resumeButton = SKSpriteNode(imageNamed: "resumeButton")
        resumeButton.scale(to: CGSize(width: 144, height: 144))
        resumeButton.position = CGPoint(x: size.width/2, y: size.height/2)
        resumeButton.zPosition = 1
        resumeButton.name = "resumeButton"
        self.resumeButton = resumeButton
        
        //home button
        let homeButton = SKSpriteNode(imageNamed: "homeButton")
        homeButton.scale(to: CGSize(width: 96, height: 96))
        homeButton.position = CGPoint(x: size.width/2 - 200, y: size.height/2 - 48)
        homeButton.zPosition = 1
        homeButton.name = "homeButton"
        self.homeButton = homeButton
        //configuration button
        let configButton = SKSpriteNode(imageNamed: "SoundButton")
        if(!AppManager.shared.soundStatus) {
            configButton.texture = SKTexture(imageNamed: "SoundButtonOff")
        }
        configButton.scale(to: CGSize(width: 96, height: 96))
        configButton.position = CGPoint(x: size.width/2 + 200, y: size.height/2 - 48)
        configButton.zPosition = 1
        configButton.name = "configButton"
        self.configButton = configButton
        
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
                case "pauseButton":  
                    changePauseStatus()
                    if let pauseButton = touchedNode as? SKSpriteNode {
                        //animatePauseButton(button: pauseButton)    
                    }
                    break
                case "resumeButton":
                    if let resumeButton = touchedNode as? SKSpriteNode {
                        animateResumeButton(button: resumeButton)
                    }
                    break
                case "homeButton":
                    if let homeButton = touchedNode as? SKSpriteNode {
                        animateHomeButton(button: homeButton)
                    }
                    break
                case "configButton":
//                    if let soundButton = touchedNode as? SKSpriteNode {
//                        animateSoundButton(button: soundButton)
//                    }
                    let optionsNode = OptionsNode(size: CGSize(width: self.size.width, height: self.size.height))
                    optionsNode.name = "optionsNode"
                    optionsNode.position = CGPoint(x:self.size.width/2, y: self.size.height/2)
                    optionsNode.zPosition = 2
                    self.addChild(optionsNode)
                    
                    break
                case "closeButton":
                    if let optionNode = self.childNode(withName: "optionsNode") {
                        optionNode.removeFromParent()
                    }
                    break
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
                case "mainDoor":
                    guard let door = touchedNode as? SKSpriteNode,
                          let background = self.childNode(withName: "appleBackground") as? SKSpriteNode,
                          let factory = self.childNode(withName: "factory") as? SKSpriteNode else { return }
                    animateOpenDoor(node: door)
                    animateScaling(node: background)
                    animateScaling(node: factory)
                    transitionToPresentationScene()
                    break
                default:
                    break
                }
            }
        }
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
    func animateResumeButton(button: SKSpriteNode) {
        button.texture = SKTexture(imageNamed: "resumeButtonPressed")
        let waitForAnimation = SKAction.wait(forDuration: 0.2)   
        let sequence = SKAction.sequence([waitForAnimation])
        self.run(sequence) { 
            self.changePauseStatus()
        }
    }
    func animateHomeButton(button: SKSpriteNode) {
        button.texture = SKTexture(imageNamed: "homeButtonPressed")
        let waitForAnimation = SKAction.wait(forDuration: 0.2)   
        let fadeOut = SKAction.fadeOut(withDuration: 0.4)
        let sequence = SKAction.sequence([waitForAnimation, fadeOut])
        self.run(sequence) { 
            self.changePauseStatus()
            let menuScene = MenuScene(size: self.size)
            menuScene.scaleMode = self.scaleMode
            self.view?.presentScene(menuScene)    
        }
    }
    
    func animateScaling(node: SKSpriteNode) {
        let scale = SKAction.scale(by: 2, duration: 2)
        let fade = SKAction.fadeOut(withDuration: 2)
        let actionGroup = SKAction.group([scale, fade])
        node.run(actionGroup)
    }
    func animateOpenDoor(node: SKSpriteNode) {
        let scale = SKAction.scale(by: 2,duration: 2)
        let fade = SKAction.fadeOut(withDuration: 2)
        let changeTexture = SKAction.run {
            node.texture = SKTexture(imageNamed: "DoorOpening")
        }
        let changeScaleFade = SKAction.group([scale, fade, changeTexture])
        node.run(changeScaleFade)
    }
    func changePauseStatus() {
        self.pauseStatus.toggle()
        guard let resumeButton = self.resumeButton,
              let homeButton = self.homeButton,
              let configButton = self.configButton
        else { return }
        if(pauseStatus) {
            if let pauseButton = self.pauseButton {
                pauseButton.removeFromParent()
            }
            addChild(resumeButton)
            addChild(homeButton)
            addChild(configButton)
            
        } else {
            if let pauseButton = self.pauseButton {
                addChild(pauseButton)
            }
            resumeButton.removeFromParent()
            homeButton.removeFromParent()
            configButton.removeFromParent()
        }
    }
    
}
