import SwiftUI
import SpriteKit

class Station {
    var sprite: SKSpriteNode
    var isOccupied: Bool
    var workingWorker: Worker? = nil
    init(sprite: SKSpriteNode) {
        let scaleFactor = sprite.xScale
        self.sprite = sprite
        self.isOccupied = false
        let name = SKLabelNode(text: "Station")
        name.fontName = AppManager.shared.appFont
        name.fontSize = 24 / scaleFactor
        name.fontColor = .black
        name.position = CGPoint(x: 0, y: -sprite.size.height / scaleFactor / 2 - 10)
        name.zPosition = 2
        self.sprite = sprite
        self.sprite.addChild(name)
    }    
}
