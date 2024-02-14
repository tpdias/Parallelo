import SwiftUI
import SpriteKit

let steveTextst: [[String]] = [ 
[
    "Hi, I'm Steve",
    "Today I'm going to show you about one of the most important concepts of modern computation! High Performance Computing, with Paralelism!",
    "How are you feeling?",
    "Alright, come with me!"
],
[
    "It refers to the use of supercomputers and parallel processing techniques to increase computation speed, tasks that that used to take 2 days, now can be completed in 2 hours",
    "plays a crucial role in climate modeling and simulations, also training and running complex AI algorithms, so HCP is everywhere",
    "The new Macbook M3 has 8 cores, so it can make 8 different processing operations at the same time",
    "Come with me to see it on practice!"
]]
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
    var curRow: Int = 0
    var waiting: Bool = false
    var answered: Bool = true
    
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
        
        //Steve
        let steve = SKSpriteNode(imageNamed: "SteveFront")
        steve.scale(to: CGSize(width: 196, height: 512))
        steve.position = CGPoint(x: size.width/2, y: size.height/2.3)
        steve.zPosition = 1
        steve.name = "steve"
        addChild(steve)
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
                                if(curText == 2 && answered && curRow == 0) {
                                    let questionNode = QuestionNode(size: self.size, position: CGPoint(x: self.size.width, y: self.size.height), questions: feelingQuestion)
                                    questionNode.name = "questionNode"
                                    self.addChild(questionNode)
                                    answered = false
                                }
                                if(curText >= steveTextst[0].count) {
                                    goToKeynote()
                                } 
                                if(curText >= steveTextst[curRow].count && curRow == 1){ 
                                    gotoNextScene()
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
    func goToKeynote() {
        if let background = self.childNode(withName: "background") as? SKSpriteNode {
            let fadeOut = SKAction.fadeOut(withDuration: 0.2)
            let changeBackground = SKAction.run {
                background.texture = SKTexture(imageNamed: "PresentationBackground")
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
    func changeChatText(chat: SKLabelNode) {
        if let chat = self.childNode(withName: "chat") as? ChatNode{
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
        let wait = SKAction.wait(forDuration: 2)
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