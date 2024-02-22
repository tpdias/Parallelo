import SwiftUI
import SpriteKit

let steveTextst: [[String]] = [ 
[
    "Hi, I'm Steve",
    "Today I'm going to show you about one of the most important concepts of modern computation! High Performance Computing, with Paralelism!",
    "Come with me!"
],
[
    "It refers to the use of supercomputers and parallel processing techniques to increase computation speed, tasks that that used to take days, now can be completed in hours",
    "It plays a crucial role in climate modeling and simulations, also training and running complex AI algorithms, so HCP is everywhere",
    "The new Macbook M3 has 16 cores, so it can make 16 different processing operations at the same time!",
    "Let's see it in Practice..."
]]

class PresentationScene: SKScene {
    let nextButton: SKSpriteNode? = nil
    var pauseNode: PauseNode?
    var curText: Int = 0
    var curRow: Int = 0
    var waiting: Bool = false
    
    var steve: SKSpriteNode
    var keynoteImage: SKSpriteNode
    
    override init(size: CGSize) {
        //Steve
        steve = SKSpriteNode(imageNamed: "Steve0")
        steve.scale(to: CGSize(width: size.width/2, height: size.width/2))
        steve.position = CGPoint(x: size.width/2, y: size.height/2)
        steve.zPosition = 1
        steve.name = "steve"
        
        keynoteImage = SKSpriteNode(imageNamed: "KeynoteSlide0")
        keynoteImage.scale(to: CGSize(width: size.width/1.8, height: size.height/2))
        keynoteImage.position = CGPoint(x: size.width/2.5, y: size.height/1.65)
        keynoteImage.zPosition = 0
        
        
        super.init(size: size)
        addChild(steve)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {        
        pauseNode = PauseNode(size: self.size)
        if let pauseNode = pauseNode {
            addChild(pauseNode)
        }
        //chat
        generateChat(chat: steveTextst[curRow])
        
        //Background
        let background = SKSpriteNode(imageNamed: "RainbowBackground")
        background.scale(to: size)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        background.name = "background"
        addChild(background)
        
        
        let textures = [SKTexture(imageNamed: "Steve0"), SKTexture(imageNamed: "Steve1")]
        let action = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.7, resize: false, restore: true))
        steve.run(action)
        //aplauses
        if(AppManager.shared.soundStatus){
            SoundManager.shared.playLowSound(soundName: "Cheer", fileType: "mp3")
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            pauseNode?.checkPauseNodePressed(view: self, touchedNode: touchedNode)
            if let name = touchedNode.name {
                if(name.contains("Button") && AppManager.shared.soundStatus && !waiting) {
                    SoundManager.shared.playButtonSound()
                }
                if(name.contains("Toggle") && AppManager.shared.soundStatus) {
                    SoundManager.shared.playToggleSound()
                }
                switch name {
                case "nextButtonGreen":
                    if(!AppManager.shared.pauseStatus) {
                        if( !waiting) {
                            curText += 1
                        }
                        //get the chat node
                        if let chat = self.childNode(withName: "chat") {
                            //get the message node
                            if let message = chat.childNode(withName: "message") as? SKLabelNode {
    
                                if(curText >= steveTextst[0].count && curRow == 0) {
                                    goToKeynote()
                                } 
                                if(curText >= steveTextst[curRow].count && curRow == 1){ 
                                    gotoNextScene()
                                }
                                else {
                                    if(!waiting) {
                                        changeChatText(chat: message)
                                        if(curRow == 1) {
                                            changeKeynoteImage()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    break
                default:
                    break
                }
            }
        }
    }
    override func update(_ currentTime: TimeInterval) {
        
    }
    func goToKeynote() {
        if let background = self.childNode(withName: "background") as? SKSpriteNode {
            let fadeOut = SKAction.fadeOut(withDuration: 0.2)
            let changeBackground = SKAction.run {
                background.texture = SKTexture(imageNamed: "PresentationBackground")
                self.steve.position = CGPoint(x: self.size.width - self.steve.size.width/2, y: self.steve.position.y)
                self.addChild(self.keynoteImage)
            }
            let fadeIn = SKAction.fadeIn(withDuration: 0.2)
            removeChat()
            self.run(SKAction.sequence([fadeOut, changeBackground, fadeIn])) {
                self.curRow += 1
                self.curText = 0
                self.generateChat(chat: steveTextst[self.curRow])
            }
        }
    }
    func gotoNextScene() {
        let parallelGameScene = ParallelGameScene(size: self.size)
        parallelGameScene.scaleMode = self.scaleMode
        self.view?.presentScene(parallelGameScene)
    }
    func changeKeynoteImage() {
        if(curText < 3) {
            keynoteImage.texture = SKTexture(imageNamed: "KeynoteSlide" + String(curText))
        }
    }
    func changeChatText(chat: SKLabelNode) {
        if let chat = self.childNode(withName: "chat") as? ChatNode{
            if let nextButton = chat.childNode(withName: "nextButtonGreen") as? SKSpriteNode {
                //depois rever animacao de esperar 2 segundos antes de trocar
                nextButton.texture = SKTexture(imageNamed: "RightButtonGray")
                self.waiting = true
                let wait = SKAction.wait(forDuration: 1.5)
                self.run(wait) {
                    nextButton.texture = SKTexture(imageNamed: "RightButton")
                    self.waiting = false
                }
                if let message = chat.childNode(withName: "message") {
                    let fadeIn = SKAction.fadeIn(withDuration: 1)
                    message.alpha = 0
                    message.run(fadeIn)
                }
            }
            chat.changeText(text: steveTextst[curRow][curText])
        }
    }
    func removeChat() {
        if let chat = self.childNode(withName: "chat") {
            chat.removeFromParent()
        }
    }
    func generateChat(chat: [String]) {
        self.curText = 0
        let wait = SKAction.wait(forDuration: 1)
        self.run(wait) {
            let chat = ChatNode(nodeSize: CGSize(width: self.size.width, height: self.size.height / 4), name: "Steve Jobs", message: chat[self.curText])
            chat.name = "chat"
            chat.textLabel.position = CGPoint(x: 40, y: chat.nameLabel.position.y - 64)
            let labelHeight = chat.textLabel.calculateAccumulatedFrame().height
            
            chat.textLabel.position.y -= labelHeight / 2
            self.addChild(chat)
        }
    }
    
   
}
