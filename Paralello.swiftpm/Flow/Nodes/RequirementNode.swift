import SwiftUI
import SpriteKit

class RequirementNode: SKNode {
    var background: SKSpriteNode
    var type: Int
    var isMet: Bool = false
    var requirement: SKSpriteNode
    init(size: CGSize, pos: CGPoint, type: Int) {
        if(pos.x < 0) {
            background = SKSpriteNode(imageNamed: "CloudI")
        } else {
            background = SKSpriteNode(imageNamed: "Cloud")
        }
        background.position = pos
        background.zPosition = 1
        background.size = CGSize(width: size.width * 2, height: size.height * 2)
        self.type = type
        let texture = ToolType(type: type).rawValue 
        requirement = SKSpriteNode(imageNamed: texture)
        requirement.scale(to: CGSize(width: size.width, height: size.height))
        requirement.zPosition = 2
        requirement.position = CGPoint(x: pos.x * 1.1, y: pos.y * 1.2)
        
        super.init()
        addChild(background)
        addChild(requirement)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
