import SpriteKit

class OptionsNode: SKNode {
    let nodeSize: CGSize
    
    init(size: CGSize) {
        // Ajuste do tamanho do node
        nodeSize = CGSize(width: size.width / 1.5, height: size.height / 1.5)
        super.init()
        
        let optionsLabel = SKLabelNode(text: "OPTIONS")
        optionsLabel.fontSize = 42
        optionsLabel.fontColor = .black
        optionsLabel.zPosition = 4
        optionsLabel.position = CGPoint(x: 0, y: 150)
        optionsLabel.fontName = AppManager.shared.appFont
        addChild(optionsLabel)
        
        let closeButton = SKSpriteNode(imageNamed: "closeButton") 
        closeButton.scale(to: CGSize(width: 50, height: 50))
        closeButton.name = "closeButton"
        closeButton.zPosition = 4
        closeButton.position = CGPoint(x: nodeSize.width / 2 - 50, y: nodeSize.height / 2 - 50)
        addChild(closeButton)
        
        
        let soundLabel = SKLabelNode(text: "Sound")
        soundLabel.fontSize = 20
        soundLabel.fontColor = .black
        soundLabel.fontName = AppManager.shared.appFont
        soundLabel.position = CGPoint(x: -250, y: 50)
        soundLabel.zPosition = 4
        addChild(soundLabel)
        
        let soundSprite = SKSpriteNode(imageNamed: "ToggleOff")
        if(AppManager.shared.soundStatus) {
            soundSprite.texture = SKTexture(imageNamed: "ToggleOn")
        }
        soundSprite.position = CGPoint(x: soundLabel.position.x, y: -50)
        soundSprite.zPosition = 4
        soundSprite.scale(to: CGSize(width: 96, height: 48))
        soundSprite.name = "soundToggle"
        addChild(soundSprite)
        
        let voiceOverLabel = SKLabelNode(text: "Voice Over")
        voiceOverLabel.fontSize = 20
        voiceOverLabel.fontName = AppManager.shared.appFont
        voiceOverLabel.fontColor = .black
        voiceOverLabel.position = CGPoint(x: 0, y: 50)
        voiceOverLabel.zPosition = 4
        addChild(voiceOverLabel)
        
        let voiceOverSprite = SKSpriteNode(imageNamed: AppManager.shared.voiceOverStatus ? "ToggleOn" : "ToggleOff")
        voiceOverSprite.position = CGPoint(x: voiceOverLabel.position.x, y: -50)
        voiceOverSprite.name = "voiceOverToggle"
        voiceOverSprite.scale(to: CGSize(width: 96, height: 48))
        voiceOverSprite.zPosition = 4
        addChild(voiceOverSprite)
        
        let fontLabel = SKLabelNode(text: "OpenDyslexic Font")
        fontLabel.fontSize = 20
        fontLabel.fontName = AppManager.shared.appFont
        fontLabel.numberOfLines = 2
        fontLabel.fontColor = .black
        fontLabel.position = CGPoint(x: 250, y: 50)
        fontLabel.zPosition = 4
        addChild(fontLabel)
        
        let fontSprite = SKSpriteNode(imageNamed: AppManager.shared.openDyslexicStatus ? "ToggleOn" : "ToggleOff")
        fontSprite.position = CGPoint(x: fontLabel.position.x, y: -50)
        fontSprite.name = "fontToggle"
        fontSprite.scale(to: CGSize(width: 96, height: 48))
        fontSprite.zPosition = 4
        addChild(fontSprite)
        
        let background = SKSpriteNode(imageNamed: "OptionsBackground")
        background.scale(to: CGSize(width: nodeSize.width, height: nodeSize.height))
        background.zPosition = 3
        addChild(background)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
