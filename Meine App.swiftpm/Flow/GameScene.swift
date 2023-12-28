import SwiftUI
import SpriteKit

class GameScene: SKScene {
    //characters
    var player: Player = Player() 
    
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
       
    }
}
