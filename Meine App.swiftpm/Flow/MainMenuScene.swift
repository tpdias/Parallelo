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
        
        // Título do menu
        let titleLabel = SKLabelNode(fontNamed: "Arial")
        titleLabel.text = "Menu"
        titleLabel.fontSize = 50
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height - 100)
        addChild(titleLabel)
        
        // Botão "Jogar"
        let playButton = SKLabelNode(fontNamed: "Arial")
        playButton.text = "Jogar"
        playButton.fontSize = 40
        playButton.fontColor = .blue
        playButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
        playButton.name = "playButton"
        addChild(playButton)
        
        // Botão "Créditos"
        let creditsButton = SKLabelNode(fontNamed: "Arial")
        creditsButton.text = "Créditos"
        creditsButton.fontSize = 40
        creditsButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 100)
        creditsButton.name = "creditsButton"
        addChild(creditsButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if let name = touchedNode.name {
                if name == "playButton" {
                    // Ação para iniciar o jogo
                    print("Iniciar jogo...")
                    // Exemplo: Transição para a cena do jogo
                    let gameScene = GameScene(size: size)
                    gameScene.scaleMode = scaleMode
                    view?.presentScene(gameScene)
                } else if name == "creditsButton" {
                    // Ação para mostrar os créditos
                    print("Mostrar créditos...")
                    // Exemplo: Transição para a cena de créditos
                    let creditsScene = CreditsScene(size: size)
                    creditsScene.scaleMode = scaleMode
                    view?.presentScene(creditsScene)
                }
            }
        }
    }
}

