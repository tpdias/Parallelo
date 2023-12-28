import SpriteKit
import SwiftUI

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
        self.size = view.bounds.size // Adjusts the scene size to match the view's size
        createMenu()
    }
    
    override var size: CGSize {
        get {
            return self.initialSize // Retorna o tamanho armazenado
        }
        set {
            // Define o tamanho somente na inicialização
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
        let background = SKSpriteNode(imageNamed: "backgroundImage")
        background.scale(to: size)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        addChild(background)
        
        //Sound Button
        let soundButton = SKSpriteNode(imageNamed: "SoundButton")
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
        
        // Button "Credits"
        let creditsButton = SKSpriteNode(imageNamed: "Button")
        creditsButton.scale(to: CGSize(width: 192, height: 96))
        creditsButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 190)
        creditsButton.name = "creditsButton"
        addChild(creditsButton)
        
        // Button "Configurations"
        let optionsButton = SKSpriteNode(imageNamed: "Button")
        optionsButton.scale(to: CGSize(width: 192, height: 96))
        optionsButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 310)
        optionsButton.name = "optionsButton"
        addChild(optionsButton)

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if let name = touchedNode.name {
                if(name.contains("Button")) {
                    SoundManager.shared.playSound(soundName: "A0", fileType: "mp3")
                }
                switch name {
                case "playButton":
                    if let playButton = touchedNode as? SKSpriteNode {
                        let gameScene = GameScene(size: self.size)
                        gameScene.scaleMode = self.scaleMode
                        performTransition(nextScene: gameScene, button: playButton)    
                        SoundManager.shared.playSound(soundName: "A0", fileType: "mp3")
                    }
                    break
                case "creditsButton":
                    if let creditsButton = touchedNode as? SKSpriteNode {
                        let creditsScene = CreditsScene(size: self.size)
                        creditsScene.scaleMode = self.scaleMode
                        performTransition(nextScene: creditsScene, button: creditsButton)
                    }
                    break
                case "optionsButton":
                    if let optionsButton = touchedNode as? SKSpriteNode {
                        let optionsScene = OptionsScene(size: self.size)
                        optionsScene.scaleMode = self.scaleMode
                        performTransition(nextScene: optionsScene, button: optionsButton)
                    }
                    
                    break
                case "soundButton":  
                    if let soundButton = touchedNode as? SKSpriteNode {
                        animateSoundButtonPressed(button: soundButton)    
                    }
                    break
                default:
                    break
                }
            }
        }
    }
    func performTransition(nextScene: SKScene, button: SKSpriteNode) {
        button.texture = SKTexture(imageNamed: "ButtonPressed")
        let waitForAnimation = SKAction.wait(forDuration: 0.2)
        
    #warning("lembrar de colocar um opacity aqui pra dar blur, um blur seria daora")
        // Run the action on the whole scene
        self.run(waitForAnimation) {
            // Transition to the next scene after the fade-out effect
            self.view?.presentScene(nextScene)
        }
    }
    func animateSoundButtonPressed(button: SKSpriteNode) {
        let soundButtonPressedTexture = SKTexture(imageNamed: "SoundButtonPressed")
        let soundButtonTexture = SKTexture(imageNamed: "SoundButton")
        
        let changeToPressed = SKAction.setTexture(soundButtonPressedTexture)
        let wait = SKAction.wait(forDuration: 0.2)
        let changeToNormal = SKAction.setTexture(soundButtonTexture)
        
        let sequence = SKAction.sequence([changeToPressed, wait, changeToNormal])
        
        button.run(sequence)
    }
}

