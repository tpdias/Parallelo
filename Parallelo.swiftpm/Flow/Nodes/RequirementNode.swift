import SwiftUI
import SpriteKit

class RequirementNode: SKNode {
    var background: SKSpriteNode
    var type: Int
    var isMet: Bool = false
    var requirement: SKSpriteNode
    init(size: CGSize, pos: CGPoint, type: Int) {
        background = SKSpriteNode(imageNamed: "RequirementBackground")
        background.position = pos
        background.zPosition = 1
        background.size = CGSize(width: size.width * 2, height: size.height * 2)
        self.type = type
        var imgName = ""
        switch type {
        case 0:
            imgName = "Screwdriver"
        case 1:
            imgName = "SolderingIron"
        default:
            imgName = "SolderingIron"
            break
        }
        requirement = SKSpriteNode(imageNamed: imgName)
        requirement.scale(to: CGSize(width: size.width, height: size.height))
        requirement.zPosition = 2
        requirement.position = pos
        
        super.init()
        addChild(background)
        addChild(requirement)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
