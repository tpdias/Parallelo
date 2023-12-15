import SwiftUI
import SpriteKit

class CreditsScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        
        let creditsLabel = SKLabelNode(fontNamed: "Arial")
        creditsLabel.text = "Créditos"
        creditsLabel.fontSize = 50
        creditsLabel.position = CGPoint(x: size.width / 2, y: size.height - 100)
        addChild(creditsLabel)
        
        let backButton = SKLabelNode(fontNamed: "Arial")
        backButton.text = "Voltar"
        backButton.fontSize = 40
        backButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
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
                    let menuScene = MenuScene(size: size)
                    menuScene.scaleMode = scaleMode
                    view?.presentScene(menuScene)
                }
            }
        }
    }
}
