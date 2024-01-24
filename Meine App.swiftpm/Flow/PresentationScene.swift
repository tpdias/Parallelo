import SwiftUI
import SpriteKit

let steveTextst: [String] = 
[
    "Hi, I'm Steve",
    "Today I'm going to show you about one of the most importants concepts of modern computation!",
    "How are you feeling?",
    "Alright, come with me!"
]

let feelingQuestion: [String] = 
[
    "I'm feeling good!",
    "A little nervous",
    "I'm super exited!"
]

class PresentationScene: SKScene {
    let nextButton: SKSpriteNode? = nil
    var pauseNode: PauseNode?
    var curText: Int = 0
    var waiting: Bool = false
    var answered: Bool = true
    override func didMove(to view: SKView) {        
        pauseNode = PauseNode(size: self.size)
        if let pauseNode = pauseNode {
            addChild(pauseNode)
        }
        //chat
        generateFirstChat()
        
        //Background
        let background = SKSpriteNode(imageNamed: "RainbowBackground")
        background.scale(to: size)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        background.name = "rainbowBackground"
        addChild(background)
        
        //Steve
        let steve = SKSpriteNode(imageNamed: "SteveFront")
        steve.scale(to: CGSize(width: 196, height: 512))
        steve.position = CGPoint(x: size.width/2, y: size.height/2.3)
        steve.zPosition = 1
        steve.name = "steve"
        addChild(steve)
        //aplauses
        SoundManager.shared.playLowSound(soundName: "Cheer", fileType: "mp3")
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            pauseNode?.checkPauseNodePressed(view: self, touchedNode: touchedNode)
            if let name = touchedNode.name {
                if(name.contains("Button") && AppManager.shared.soundStatus && !waiting && answered) {
                    SoundManager.shared.playButtonSound()
                }
                if(name.contains("Toggle") && AppManager.shared.soundStatus) {
                    SoundManager.shared.playToggleSound()
                }
                if(name.contains("questionBackground")) {
                    answered = true
                    if let questionNode = self.childNode(withName: "questionNode"){
                        
                        let fadeOut = SKAction.fadeOut(withDuration: 1)
                        if let touchedNode = touchedNode as? SKSpriteNode {
                            touchedNode.texture = SKTexture(imageNamed: "ChatRightBackground")
                        }
                        questionNode.run(fadeOut) {
                            questionNode.removeFromParent()
                        }
                    }
                    curText += 1
                    if let chat = childNode(withName: "chat") {
                        if let message = chat.childNode(withName: "message") as? SKLabelNode{
                            changeChatText(chat: message)                            
                        }
                    }
                }
                switch name {
                case "nextButtonGreen":
                    if(!AppManager.shared.pauseStatus) {
                        if(answered && !waiting) {
                            curText += 1
                        }
                        //get the chat node
                        if let chat = self.childNode(withName: "chat") {
                            //get the message node
                            if let message = chat.childNode(withName: "message") as? SKLabelNode {
                                if(curText == 2 && answered) {
                                    let questionNode = QuestionNode(size: self.size, questions: feelingQuestion)
                                    questionNode.name = "questionNode"
                                    self.addChild(questionNode)
                                    answered = false
                                }
                                if(curText >= steveTextst.count) {
                                    transitionToNextScene()
                                } 
                                else {
                                    if(!waiting) {
                                        changeChatText(chat: message)
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
    func transitionToNextScene() {
        let nextScene = MenuScene(size: self.size)
        nextScene.scaleMode = self.scaleMode
        self.view?.presentScene(nextScene)
    }
    func changeChatText(chat: SKLabelNode) {
        if let chat = self.childNode(withName: "chat") {
            if let nextButton = chat.childNode(withName: "nextButtonGreen") as? SKSpriteNode {
                //depois rever animacao de esperar 2 segundos antes de trocar
                nextButton.texture = SKTexture(imageNamed: "RightButtonGray")
                self.waiting = true
                let wait = SKAction.wait(forDuration: 2.5)
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
            
        }
        chat.text = steveTextst[curText]
    }
    func generateFirstChat() {
        let wait = SKAction.wait(forDuration: 2)
        self.run(wait) {
            let chat = ChatNode(nodeSize: CGSize(width: self.size.width, height: self.size.height / 4), name: "Steve Jobs", message: steveTextst[self.curText])
            chat.name = "chat"
            self.addChild(chat)
        }
    }
    
   
}
