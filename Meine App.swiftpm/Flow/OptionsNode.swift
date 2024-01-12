import SpriteKit

class OptionsNode: SKNode {
    let nodeSize: CGSize
    
    init(size: CGSize) {
        // Ajuste do tamanho do node
        nodeSize = CGSize(width: size.width / 2, height: size.height / 2)
        super.init()
        
        let optionsLabel = SKLabelNode(text: "OPTIONS")
        optionsLabel.fontSize = 42
        optionsLabel.fontColor = .white
        optionsLabel.zPosition = 3
        optionsLabel.position = CGPoint(x: 0, y: 150)
        optionsLabel.fontName = AppManager.shared.appFont
        addChild(optionsLabel)
        
        let closeButton = SKSpriteNode(imageNamed: "closeButton") 
        closeButton.scale(to: CGSize(width: 50, height: 50))
        closeButton.name = "closeButton"
        closeButton.zPosition = 3
        closeButton.position = CGPoint(x: nodeSize.width / 2 - 50, y: nodeSize.height / 2 - 50)
        addChild(closeButton)
        
        
        let soundLabel = SKLabelNode(text: "Sound")
        soundLabel.fontSize = 20
        soundLabel.fontColor = .white
        soundLabel.fontName = AppManager.shared.appFont
        soundLabel.position = CGPoint(x: -200, y: 50)
        soundLabel.zPosition = 3
        addChild(soundLabel)
        
        let soundSprite = SKSpriteNode(imageNamed: "ToggleOff")
        if(AppManager.shared.soundStatus) {
            soundSprite.texture = SKTexture(imageNamed: "ToggleOn")
        }
        soundSprite.position = CGPoint(x: -200, y: -50)
        soundSprite.zPosition = 3
        soundSprite.scale(to: CGSize(width: 96, height: 48))
        soundSprite.name = "soundToggle"
        addChild(soundSprite)
        
        let voiceOverLabel = SKLabelNode(text: "Voice Over")
        voiceOverLabel.fontSize = 20
        voiceOverLabel.fontName = AppManager.shared.appFont
        voiceOverLabel.fontColor = .white
        voiceOverLabel.position = CGPoint(x: 200, y: 50)
        voiceOverLabel.zPosition = 3
        addChild(voiceOverLabel)
        
        let voiceOverSprite = SKSpriteNode(imageNamed: "ToggleOff")
        if(AppManager.shared.voiceOverStatus) {
            voiceOverSprite.texture = SKTexture(imageNamed: "ToggleOn")
        }
        voiceOverSprite.position = CGPoint(x: 200, y: -50)
        voiceOverSprite.name = "voiceOverToggle"
        voiceOverSprite.scale(to: CGSize(width: 96, height: 48))
        voiceOverSprite.zPosition = 3
        addChild(voiceOverSprite)
        
        let background = SKSpriteNode(color: .black, size: nodeSize)
        addChild(background)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
