import SpriteKit

class OptionsNode: SKNode {
    let nodeSize: CGSize
    
    init(size: CGSize) {
        // Ajuste do tamanho do node
        nodeSize = CGSize(width: size.width / 1.3, height: size.height / 1.5)
        super.init()
        
        let optionsLabel = SKLabelNode(text: "OPTIONS")
        optionsLabel.fontSize = 42
        optionsLabel.fontColor = .white
        optionsLabel.zPosition = 8
        optionsLabel.position = CGPoint(x: 0, y: 150)
        optionsLabel.fontName = AppManager.shared.appFont
        addChild(optionsLabel)
        
        let closeButton = SKSpriteNode(imageNamed: "CloseButton") 
        closeButton.scale(to: CGSize(width: 50, height: 50))
        closeButton.name = "closeButton"
        closeButton.zPosition = 8
        closeButton.position = CGPoint(x: nodeSize.width / 2 - 100, y: nodeSize.height / 2 - 50)
        addChild(closeButton)
        
        
        let soundLabel = SKLabelNode(text: "Sound")
        soundLabel.fontSize = 20
        soundLabel.fontColor = .white
        soundLabel.fontName = AppManager.shared.appFont
        soundLabel.position = CGPoint(x: -250, y: 50)
        soundLabel.zPosition = 8
        addChild(soundLabel)
        
        let soundSprite = SKSpriteNode(imageNamed: "ToggleOff")
        if(AppManager.shared.soundStatus) {
            soundSprite.texture = SKTexture(imageNamed: "ToggleOn")
        }
        soundSprite.position = CGPoint(x: soundLabel.position.x, y: -50)
        soundSprite.zPosition = 8
        soundSprite.scale(to: CGSize(width: 96, height: 48))
        soundSprite.name = "soundToggle"
        addChild(soundSprite)
        
        
        let fontLabel = SKLabelNode(text: "OpenDyslexic Font")
        fontLabel.fontSize = 20
        fontLabel.fontName = AppManager.shared.appFont
        fontLabel.numberOfLines = 2
        fontLabel.fontColor = .white
        fontLabel.position = CGPoint(x: 250, y: 50)
        fontLabel.zPosition = 8
        addChild(fontLabel)
        
        let fontSprite = SKSpriteNode(imageNamed: AppManager.shared.openDyslexicStatus ? "ToggleOn" : "ToggleOff")
        fontSprite.position = CGPoint(x: fontLabel.position.x, y: -50)
        fontSprite.name = "fontToggle"
        fontSprite.scale(to: CGSize(width: 96, height: 48))
        fontSprite.zPosition = 8
        addChild(fontSprite)
        
        let background = SKSpriteNode(imageNamed: "OptionsBackground")
        background.scale(to: CGSize(width: nodeSize.width, height: nodeSize.height))
        background.zPosition = 7
        addChild(background)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
