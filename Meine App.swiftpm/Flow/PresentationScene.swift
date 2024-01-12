import SwiftUI
import SpriteKit

class PresentationScene: SKScene {
    let nextButton: SKSpriteNode? = nil
    override func didMove(to view: SKView) {        
        #warning("fazer a animacao dos botoes no app manager, so colocar um + \"pressed\" na texture e animar o nodo")
        //chat
        generateFirstChat()
        //Steve
        
        //aplauses
        //SoundManager.shared.playSound(soundName: "aplauses", fileType: "mp3")
        
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
                case "nextButtonGreen":
                    break
                default:
                    break
                }
            }
        }
    }
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func generateFirstChat() {
        let wait = SKAction.wait(forDuration: 2)
        self.run(wait) {
            let chat = ChatNode(nodeSize: CGSize(width: self.size.width, height: self.size.height / 4), name: "Steve Jobs", message: "Hi, I'm Steve!")
            self.addChild(chat)
        }
    }
}
