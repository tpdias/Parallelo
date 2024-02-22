import SwiftUI
import SpriteKit

class CreditsScene: SKScene {
    var about: SKLabelNode
    var aboutText: SKLabelNode
    var creditsText: SKLabelNode
    var creditsImage: SKSpriteNode
    var copyright: SKLabelNode
    var copyrightText: SKLabelNode
    
    override init(size: CGSize) {
        let titleFont:CGFloat = 28
        let textFont:CGFloat = 24
        creditsText = SKLabelNode(text: "Hi I'm Thiago, a 23 years old Computer Engineering Student from Brazil. I'm an iOS Developer at Apple Developer Academy POA and I love to work on projects that I'm passionate about.")
        creditsText.preferredMaxLayoutWidth = size.width / 1.3
        creditsText.numberOfLines = -1
        creditsText.position = CGPoint(x: size.width/2, y: size.height/2 + 180 - creditsText.frame.size.height)
        creditsText.zPosition = 1
        creditsText.fontName = AppManager.shared.appFont
        creditsText.fontSize = textFont
        creditsText.fontColor = .white
        
        
        about = SKLabelNode(text: "About")
        about.position = CGPoint(x: size.width / 2 , y: creditsText.position.y - 50)
        about.fontColor = .mainGreen
        about.fontSize = titleFont
        about.fontName = AppManager.shared.appFont
        
        aboutText = SKLabelNode(text: "Parallelo is a game that teaches parallelism in a playful way, explaining the main concepts such as concurrency, deadlock and speedup. The main character is guided through Apple Park by Steve Jobs on this super fun journey!")
        aboutText.numberOfLines = -1
        aboutText.preferredMaxLayoutWidth = size.width / 1.3
        aboutText.zPosition = 1
        aboutText.fontName = AppManager.shared.appFont
        aboutText.fontSize = textFont
        aboutText.fontColor = .white
        aboutText.position = CGPoint(x: size.width/2, y: about.position.y - 100 - aboutText.frame.size.height / 2)

        
        
        
        copyright = SKLabelNode(text: "Copyright")
        copyright.position = CGPoint(x: size.width / 2 , y: aboutText.position.y - 50)
        copyright.fontColor = .mainGreen
        copyright.fontName = AppManager.shared.appFont
        copyright.fontSize = titleFont
        
        copyrightText = SKLabelNode(text: "Soundtrack: A Night Of Dizzy Spells by Eric Skiff\nPrimary Font: Retro Gaming: https://www.dafont.com/retro-gaming.font\nSecondary Font: OpenDyslexic - https://opendyslexic.org/")
        copyrightText.numberOfLines = -1
        copyrightText.position = CGPoint(x: size.width / 2 , y: copyright.position.y - 100 - copyrightText.frame.size.height / 2)
        copyrightText.fontColor = .white
        copyrightText.preferredMaxLayoutWidth = size.width / 1.3
        copyrightText.fontName = AppManager.shared.appFont
        copyrightText.fontSize = textFont
        
        creditsImage = SKSpriteNode(imageNamed: "Thiago")
        creditsImage.position = CGPoint(x: size.width - size.width/6, y: size.height - 150)
        creditsImage.scale(to: CGSize(width: size.width/6, height: size.width/6))
        creditsImage.zPosition = 2
        
        super.init(size: size)
        
        addChild(creditsText)
        addChild(about)
        addChild(aboutText)
        addChild(copyright)
        addChild(copyrightText)
        addChild(creditsImage)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {        
        //Background
        let background = SKSpriteNode(imageNamed: "ApplePark")
        background.scale(to: size)
        background.position = CGPoint(x: size.width/2, y: size.height/2 - 25)
        background.zPosition = -1
        background.alpha = 0.3
        addChild(background)
        
        // First Line
        let firstLineLabel = SKLabelNode(text: "Credits")
        firstLineLabel.fontName = AppManager.shared.appFont
        firstLineLabel.fontColor = .white
        firstLineLabel.fontSize = 48
        firstLineLabel.horizontalAlignmentMode = .center
        firstLineLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 250)
        firstLineLabel.zPosition = 2
        addChild(firstLineLabel)
        
        
        // First Line
        let firstLineLabelB = SKLabelNode(text: "Credits")
        firstLineLabelB.fontName = AppManager.shared.appFont
        firstLineLabelB.fontColor = .black
        firstLineLabelB.fontSize = 48
        firstLineLabelB.horizontalAlignmentMode = .center
        firstLineLabelB.position = CGPoint(x: size.width / 2 - 8, y: size.height / 2 + 250 - 5)
        firstLineLabelB.zPosition = 1
        addChild(firstLineLabelB)
        
        
        //Back Button, return to menu on click
        let backButton = SKSpriteNode(imageNamed: "BackButton")
        backButton.scale(to: CGSize(width: 50, height: 50))
        backButton.position = CGPoint(x: 100, y: size.height - 100)
        backButton.zPosition = 1
        backButton.name = "backButton"
        addChild(backButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if let name = touchedNode.name {
                if name == "backButton" {
                    // Voltar para o menu principal
                    if(AppManager.shared.soundStatus){
                        SoundManager.shared.playButtonSound()
                    }
                    if let backButton = touchedNode as? SKSpriteNode {
                        let menuScene = MenuScene(size: size)
                        menuScene.scaleMode = scaleMode
                        performTransition(nextScene: menuScene, button: backButton)
                    }
                }
            }
        }
    }
    func performTransition(nextScene: SKScene, button: SKSpriteNode) {
        button.texture = SKTexture(imageNamed: "BackButtonPressed")
        let waitForAnimation = SKAction.wait(forDuration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.4)
        
        let sequence = SKAction.sequence([waitForAnimation, fadeOut])
        
        // Run the action on the whole scene
        self.run(sequence) {
            // Transition to the next scene after the fade-out effect
            self.view?.presentScene(nextScene)
        }
    }
}
