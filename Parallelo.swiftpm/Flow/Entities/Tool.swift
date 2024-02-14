import SwiftUI
import SpriteKit


enum ToolType: String {
    case hammer = "Hammer"
    case screwDriver = "ScrewDriver"
    case wrench = "Wrench"
    
    init(type: Int) {
        switch type {
        case 0:
            self = .hammer
        case 1:
            self = .screwDriver
        case 2:
            self = .wrench
        default:
            self = .hammer
        }
    }
}


class Tool {
    var type: Int
    var sprite: SKSpriteNode
    var isBeeingUsed: Bool = false
    
    init(type: Int, position: CGPoint, size: CGSize, id: Int) {
        self.type = type
        let texture = ToolType(type: type).rawValue + String("Off")
        
        sprite = SKSpriteNode(imageNamed: texture)
        sprite.position = CGPoint(x: position.x, y: position.y)
        sprite.name = texture.lowercased()
        sprite.zPosition = 3
        sprite.scale(to: size)
        sprite.name = "tool" + String(id)
        
    }
    func assignToWorker(position: CGPoint) {
        isBeeingUsed = true
        sprite.position = CGPoint(x: position.x - sprite.size.width/2 - 20, y: position.y - 10)
        let textName = ToolType(type: type).rawValue + "On"
        sprite.texture = SKTexture(imageNamed: textName)
    }
    func unassingTool() {
        let textName = ToolType(type: type).rawValue + "Off"
        sprite.texture = SKTexture(imageNamed: textName)
    }
    
}
