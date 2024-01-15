import SpriteKit
import SwiftUI
import UIKit

struct MainMenuView: View {
    var body: some View {
        GeometryReader { geometry in 
            SpriteKitView(scene: MenuScene(size: CGSize(width: geometry.size.width, height: geometry.size.height)), size: geometry.size)
        }
        .ignoresSafeArea()
    }
}

struct SpriteKitView: UIViewRepresentable {
    typealias UIViewType = SKView
    let scene: SKScene
    let size: CGSize
    
    init(scene: SKScene, size: CGSize) {
        self.scene = scene
        self.size = size
    }
    
    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        skView.presentScene(scene)
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // Update the view if needed
    }
}

class MenuScene: SKScene {
    var initialSize: CGSize = .zero
    
    override func didMove(to view: SKView) {
        self.size = view.bounds.size
        createMenu()
        
        //check the orientation
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override var size: CGSize {
        get {
            return self.initialSize // Return the size
        }
        set {
            // define the size
            if self.initialSize == .zero {
                self.initialSize = newValue
            }
        }
    }
    
    func createMenu() {
        guard let viewSize = view?.bounds.size else { return }
        self.size = viewSize
        backgroundColor = SKColor.black
        
        //Background
        let background = SKSpriteNode(imageNamed: "ApplePark")
        background.scale(to: size)
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.position = CGPoint(x: 0, y: -20)
        background.zPosition = -1
        addChild(background)
        
        //Sound Button
        let soundButton = SKSpriteNode(imageNamed: "SoundButton")
        if(!AppManager.shared.soundStatus) {
            soundButton.texture = SKTexture(imageNamed: "SoundButtonOff")
        }
        soundButton.scale(to: CGSize(width: 48, height: 48))
        soundButton.position = CGPoint(x: size.width - 100, y: size.height - 100)
        soundButton.zPosition = 1
        soundButton.name = "soundButton"
        addChild(soundButton)
        
        
        // Title
        let titleMenu = SKSpriteNode(imageNamed: "TitleMenu")
        titleMenu.scale(to: CGSize(width: 192, height: 96))
        titleMenu.position = CGPoint(x: size.width / 2, y: size.height / 2 + 192)
        titleMenu.zPosition = 1
        addChild(titleMenu)
        
        // Botton "Play"
        let playButton = SKSpriteNode(imageNamed: "Button")
        playButton.scale(to: CGSize(width: 192, height: 96))
        playButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 70)
        playButton.name = "playButton"
        addChild(playButton)
        
        //play Text
        let playLabel = SKLabelNode(text: "START")
        playLabel.fontSize = 24
        playLabel.position = playButton.position
        playLabel.fontColor = .black
        playLabel.fontName = AppManager.shared.appFont
        playLabel.name = "playLabel"
        addChild(playLabel)
        
        // Button "Configurations"
        let optionsButton = SKSpriteNode(imageNamed: "Button")
        optionsButton.scale(to: CGSize(width: 192, height: 96))
        optionsButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 190)
        optionsButton.name = "optionsButton"
        addChild(optionsButton)
        
        let optionsLabel = SKLabelNode(text: "OPTIONS")
        optionsLabel.fontSize = 24
        optionsLabel.fontColor = .black
        optionsLabel.fontName = AppManager.shared.appFont
        optionsLabel.position = optionsButton.position
        optionsLabel.name = "optionsLabel"
        addChild(optionsLabel)
        
        // Button "Credits"
        let creditsButton = SKSpriteNode(imageNamed: "Button")
        creditsButton.scale(to: CGSize(width: 192, height: 96))
        creditsButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 310)
        creditsButton.name = "creditsButton"
        addChild(creditsButton)
        
        let creditsLabel = SKLabelNode(text: "CREDITS")
        creditsLabel.fontSize = 24
        creditsLabel.fontColor = .black
        creditsLabel.position = creditsButton.position
        creditsLabel.fontName = AppManager.shared.appFont
        creditsLabel.name = "creditsLabel"
        addChild(creditsLabel)
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
                case "playButton":
                    if let playButton = touchedNode as? SKSpriteNode {
                        let gameScene = GameScene(size: self.size)
                        gameScene.scaleMode = self.scaleMode
                        if let label = childNode(withName: "playLabel") as? SKLabelNode {
                            performTransition(nextScene: gameScene, button: playButton, label: label)    
                        }
                    }
                    break
                case "creditsButton":
                    if let creditsButton = touchedNode as? SKSpriteNode {
                        let creditsScene = CreditsScene(size: self.size)
                        creditsScene.scaleMode = self.scaleMode
                        if let label = childNode(withName: "creditsLabel") as? SKLabelNode {
                            performTransition(nextScene: creditsScene, button: creditsButton, label: label)
                        }
                    }
                    break
                case "optionsButton":
                    if let optionsButton = touchedNode as? SKSpriteNode {
                        let optionsScene = OptionsScene(size: self.size)
                        optionsScene.scaleMode = self.scaleMode
                        if let label = childNode(withName: "optionsLabel") as? SKLabelNode {
                            performTransition(nextScene: optionsScene, button: optionsButton, label: label)
                        }
                    }
                    
                    break
                case "soundButton":  
                    if let soundButton = touchedNode as? SKSpriteNode {
                        AppManager.shared.animateSoundButton(button: soundButton)    
                    }
                    break
                default:
                    break
                }
            }
        }
    }
    func performTransition(nextScene: SKScene, button: SKSpriteNode, label: SKLabelNode) {
        button.texture = SKTexture(imageNamed: "ButtonPressed")
        label.position.y -= 10
        let waitForAnimation = SKAction.wait(forDuration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.4)
        
        let sequence = SKAction.sequence([waitForAnimation, fadeOut])

        // Run the action on the whole scene
        self.run(sequence) {
            // Transition to the next scene after the fade-out effect
            self.view?.presentScene(nextScene)
        }
    }
    
    @objc func orientationDidChange() {
        // Função chamada quando a orientação do dispositivo muda
        if UIDevice.current.orientation.isPortrait {
            print("Orientação: Retrato")
        } else if UIDevice.current.orientation.isLandscape {
            print("Orientação: Paisagem")
        } else {
            print("Orientação: Desconhecida")
        }
    }

//    func animateSoundButtonPressed(button: SKSpriteNode) {
//        let soundButtonPressedTexture = SKTexture(imageNamed: "SoundButtonPressed")
//        var soundButtonImage = "SoundButton"
//        if(!AppManager.shared.soundStatus) {
//            soundButtonImage += "Off"
//        }
//        let soundButtonTexture = SKTexture(imageNamed: soundButtonImage)
//        let changeToPressed = SKAction.setTexture(soundButtonPressedTexture)
//        let wait = SKAction.wait(forDuration: 0.2)
//        let changeToNormal = SKAction.setTexture(soundButtonTexture)
//        
//        let sequence = SKAction.sequence([changeToPressed, wait, changeToNormal])
//        
//        button.run(sequence)
//    }
}

