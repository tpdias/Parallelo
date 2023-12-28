import SwiftUI
import SpriteKit

let playerTextSize = 5

class Player {
    var sprite: SKSpriteNode
    var textures: [SKTexture] = []
    
    init() {
        //initialize player texture
        for i in 0..<playerTextSize {
            self.textures.append(SKTexture(imageNamed: "playerTexture\(i)"))
        }
        
        //initialize player sprite
        let sprite = SKSpriteNode(texture: SKTexture(imageNamed: "playerTexture0"))
        sprite.name = "player"
        sprite.position = CGPoint(x: 0, y: 0)
        self.sprite = sprite
    }
}
