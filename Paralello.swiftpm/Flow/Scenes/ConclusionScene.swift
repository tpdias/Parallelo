import SwiftUI
import SpriteKit

let conclusionText: [String] = [
"Let's review the concepts that we'd learn!",
"Why was the parallel execution, with two stations, faster?",
"That's right! And why did the deadlock happen?",
"Excelent! Thanks for playing! You can learn more about paralelism in the wikipedia website above!"
]
let parallelQuestions: [String] = ["The workers did their tasks faster", "Two workers could work at the same time", "With more stations, the workers can make less work", "The workers helped each other on their tasks"]
let deadlockQuestions: [String] = ["The workers were interrupted by the others","There was not enought stations for the workers","Two workers tried to use the same resource at the same time","The deadlock didn't happen"]

class ConclusionScene: SKScene {
    let background: SKSpriteNode
    var wikipedia: SKSpriteNode
    let steve: SKSpriteNode
    var waiting: Bool = false
    var correctIndex: Int = 1
    let pauseNode: PauseNode
    let questionNode: QuestionNode
    let chatNode: ChatNode
    var curText = 0
    
    override init(size: CGSize) {
        background = SKSpriteNode(imageNamed: "RainbowBackground")
        background.scale(to: size)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        background.name = "background"
        
        wikipedia = SKSpriteNode(imageNamed: "wikipedia")
        wikipedia.zPosition = 2
        wikipedia.position = CGPoint(x: size.width/2, y: size.height/2)
        wikipedia.scale(to: CGSize(width: size.width/4, height: size.width/4))
        wikipedia.name = "wikipedia"
        
    
        questionNode = QuestionNode(size: size, position: CGPoint(x: size.width, y: size.height), questions: [])
        questionNode.addQuestions(questions: parallelQuestions)
        //Steve
        steve = SKSpriteNode(imageNamed: "Steve0")
        steve.scale(to: CGSize(width: size.width/2, height: size.width/2))
        steve.position = CGPoint(x: size.width/2, y: size.height/2)
        steve.zPosition = 1
        steve.name = "steve"
        let textures = [SKTexture(imageNamed: "Steve0"), SKTexture(imageNamed: "Steve1")]
        let action = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.7, resize: false, restore: true))
        steve.run(action)
        
        pauseNode = PauseNode(size: size)
        
        chatNode = ChatNode(nodeSize: CGSize(width: size.width, height: size.height/4), name: "Steve Jobs", message: conclusionText[curText])
        
        
        super.init(size: size)
        addChild(background)
        addChild(steve)
        addChild(chatNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if let name = touchedNode.name {
                pauseNode.checkPauseNodePressed(view: self, touchedNode: touchedNode)
                if name == "nextButtonGreen" && !waiting{
                    if(curText < conclusionText.count) {
                        curText += 1
                    }
                    if(correctIndex == 2) {
                        let MenuScene = MenuScene(size: self.size)
                        MenuScene.scaleMode = self.scaleMode
                        self.view?.presentScene(MenuScene)
                    } else {
                        chatNode.changeText(text: conclusionText[curText])
                        chatNode.nextButtonTemp.removeFromParent()
                        addChild(questionNode)
                    }
                }
                if(name == "wikipedia") {
                    if let url = URL(string: "https://en.wikipedia.org/wiki/Parallel_computing") {
                        UIApplication.shared.open(url)
                    }
                }
                if(name.contains("questionBackground") || name.contains("questionLabel")) {
                    
                    var texture = SKTexture(imageNamed: "ChatWrongBackground")
                    if(name.contains(String(correctIndex))) {
                        texture = SKTexture(imageNamed: "ChatRightBackground")
                    }
                    if let last = name.last {
                        print(name)
                        if let index = Int(last.description) {
                            self.questionNode.questions[index].background.texture = texture
                            
                            if(index == correctIndex) {
                                SoundManager.shared.playAudio(audio: "Achievement", loop: false, volume: 0.1)
                                let fadeOut = SKAction.fadeOut(withDuration: 1)
                                if(correctIndex == 2) {
                                    self.questionNode.run(fadeOut) {
                                        self.questionNode.removeFromParent()
                                        self.curText += 1
                                        self.changeText()
                                        self.addChild(self.chatNode.nextButtonTemp)
                                        self.addChild(self.wikipedia)
                                    }
                                } else {
                                
                                    self.questionNode.run(fadeOut) {
                                        self.correctIndex = 2
                                        self.questionNode.removeQuestions()
                                        self.questionNode.addQuestions(questions: deadlockQuestions)
                                        self.curText += 1
                                        self.changeText()
                                        self.questionNode.run(SKAction.fadeIn(withDuration: 1))
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        }
        
    }
    
    func changeText() {
        chatNode.nextButtonTemp.texture = SKTexture(imageNamed: "RightButtonGray")
        self.waiting = true
        let wait = SKAction.wait(forDuration: 1)
        self.run(wait) {
            self.chatNode.nextButtonTemp.texture = SKTexture(imageNamed: "RightButton")
            self.waiting = false
        }
        chatNode.textLabel.alpha = 0
        chatNode.textLabel.text = conclusionText[curText]
        chatNode.textLabel.run(SKAction.fadeIn(withDuration: 0.5))
    }
    
}
