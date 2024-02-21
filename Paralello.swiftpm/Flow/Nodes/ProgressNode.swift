import SwiftUI
import SpriteKit

class ProgressNode: SKNode {
    var background: SKSpriteNode
    var progressIndicator: SKSpriteNode
    var progressWidth: CGFloat = 0
    
    init(size: CGSize, indicatorColor: UIColor, position: CGPoint) {
        // Create background sprite with texture
        background = SKSpriteNode(imageNamed: "ChatBackground")
        background.scale(to: CGSize(width: size.width, height: size.height / 4))
        background.anchorPoint = CGPoint(x: 0, y: 0.5)
        background.position = position
        background.zPosition = 2

        // Create progress indicator
        progressIndicator = SKSpriteNode(color: indicatorColor, size: CGSize(width: 0, height: size.height / 4 - 10))
        progressIndicator.anchorPoint = CGPoint(x: 0, y: 0.5)
        progressIndicator.zPosition = 3
        progressIndicator.position = CGPoint(x: position.x + 5, y: position.y)

        super.init()
        
        addChild(background)
        addChild(progressIndicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func increaseProgress(toWidth width: CGFloat, duration: TimeInterval) {
        let newWidth = min(width, background.size.width)
        self.progressWidth = newWidth
        let resizeAction = SKAction.resize(toWidth: newWidth - 10, duration: duration)
        progressIndicator.run(resizeAction){
        }
    }
    func resetProgress() {
        progressIndicator.size.width = 0
        progressWidth = 0
    }
}

