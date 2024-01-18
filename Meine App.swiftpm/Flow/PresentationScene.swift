import SwiftUI
import SpriteKit

let steveTextst: [String] = 
[
    "Hi, I'm Steve",
    "In this visit I'm going to show you about one of the most importants concepts of modern computation!",
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
    override func didMove(to view: SKView) {        
        pauseNode = PauseNode(size: self.size)
        if let pauseNode = pauseNode {
            addChild(pauseNode)
        }
        #warning("fazer a animacao dos botoes no app manager, so colocar um + \"pressed\" na texture e animar o nodo")
        //chat
        generateFirstChat()
        
        //Background
        let background = SKSpriteNode(imageNamed: "PresentationBackground")
        background.scale(to: size)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        background.name = "presentationBackground"
        addChild(background)
        
        //Steve
        let steve = SKSpriteNode(imageNamed: "SteveFront")
        steve.scale(to: CGSize(width: 196, height: 512))
        //aplauses
        //SoundManager.shared.playSound(soundName: "aplauses", fileType: "mp3")
        
        
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            pauseNode?.checkPauseNodePressed(view: self, touchedNode: touchedNode)
            if let name = touchedNode.name {
                if(name.contains("Button") && AppManager.shared.soundStatus) {
                    SoundManager.shared.playSound(soundName: "A0", fileType: "mp3")
                }
                switch name {
                case "nextButtonGreen":
                    if(!AppManager.shared.pauseStatus) {
                    curText += 1
                        if let chat = self.childNode(withName: "chat") {
                            if let message = chat.childNode(withName: "message") as? SKLabelNode {
                                if(curText >= steveTextst.count) {
                                    transitionToNextScene()
                                } else {
                                    changeChatText(chat: message) }
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
        if(curText == 1) {
            if let chat = self.childNode(withName: "chat") {
                if let nextButton = chat.childNode(withName: "nextButtonGreen") {
                    //depois rever animacao de esperar 2 segundos antes de trocar
                    nextButton.removeFromParent()
                    let wait = SKAction.wait(forDuration: 2.5)
                    self.run(wait) {
                        self.generateQuestionNode()
                    }
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
    
    func generateQuestionNode() {
        print("aqui")
    }
}
