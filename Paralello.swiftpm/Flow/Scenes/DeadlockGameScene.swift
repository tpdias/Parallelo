import SwiftUI
import SpriteKit

let deadlockTxt: [String] = [
"Oh no, both workers want to use the Hammer and the Screwdriver at the same time!",
"This is a deadlock, when the processes are competing for a resource, so they wait until the other releases it, but they never release, so they wait forever",
"To solve this, we can use the CRITICAL SECTION! Only One process ( worker ) can work at a time when we use a shared resource",
"lets reset it and use the critical section!"
]

let deadlockTxt2: [String] = [
"Now the worker needs to get all the shared resources he wants to use before start working. Give one of the workers both tools",
"Well done! Now the other worker need the tools",
"Good job!"
]

class DeadlockGameScene: SKScene {
    var pauseNode: PauseNode

    var background: SKSpriteNode
    var workers: [Worker] = []
    var stations: [Station] = []
    var tools: [Tool] = []
    
    var instructionNode: InstructionNode
    
    var chatNode: ChatNode
    var curText: Int = 0
    var waiting = false
    
    var selectedTool: Tool?
    var curWorker: Worker?
    var macintosh: SKSpriteNode
    
    var initialTouchPosition: CGPoint
    
    var start: Bool = false
    var lvl = 0
    
    var resetButton: SKSpriteNode
    override init(size: CGSize) {
        instructionNode = InstructionNode(instruction: "Processes can depend on certain resources to perform their tasks, much like a worker depends on their tools, so they wait until the operating system gives them its resource", title: "Concurrency", size: size)
        instructionNode.zPosition = 5
        pauseNode = PauseNode(size: size)
        pauseNode.zPosition = 6
        initialTouchPosition = .zero
        background = SKSpriteNode(imageNamed: "FactoryFloor")
        background.scale(to: size)
        background.zPosition = -1
        background.name = "background"
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        
        
        macintosh = SKSpriteNode(imageNamed: "Macintosh")
        macintosh.scale(to: CGSize(width: size.width/2.5, height: size.width/2.5))
        macintosh.position = CGPoint(x: size.width/2, y: size.height/2)
        macintosh.zPosition = 3
        macintosh.alpha = 0

        
        chatNode = ChatNode(nodeSize: CGSize(width: size.width, height: size.height / 4), name: "Steve Jobs", message: deadlockTxt[0])
        chatNode.name = "chat"
        chatNode.textLabel.position = CGPoint(x: 40, y: chatNode.nameLabel.position.y - 64)
        let labelHeight = chatNode.textLabel.calculateAccumulatedFrame().height
        chatNode.textLabel.position.y -= labelHeight / 2
        
        
        resetButton = SKSpriteNode(imageNamed: "RestartButton")
        resetButton.name = "resetButton"
        resetButton.position = CGPoint(x: size.width - 100, y: 50)
        resetButton.size = CGSize(width: size.width/25, height: size.width/25)
        resetButton.zPosition = 3
        
        super.init(size: size)
        
        
        //station and workers initiale
        for i in 0..<2 {
            let newStation = SKSpriteNode(imageNamed: "StationEmpty")
            let newWorker = SKSpriteNode(imageNamed: "workerSTD0")
            newStation.scale(to: CGSize(width: size.width/4, height: size.height/4))
            newWorker.scale(to: CGSize(width: size.width/11, height: 1.5 * size.width/11))
            newStation.position = CGPoint(x: size.width / 4 + (size.width / 4 * CGFloat(i * 2)), y: size.height/2)
            newWorker.position = newStation.position
            newStation.zPosition = 1
            newWorker.zPosition = 2
            newStation.name = "station" + String(i)
            newWorker.name = "worker" + String(i)
            self.addChild(newStation)
            self.addChild(newWorker)
            stations.append(Station(sprite: newStation))
            workers.append(Worker(type: i, sprite: newWorker, requirement: i > 0 ? 0 : 1, secondRequirement: nil))

            if let requirement = workers[i].requirement {
                requirement.alpha = 0
            }
            let newTool = Tool(type: i, position: CGPoint(x: newWorker.position.x - newWorker.size.width, y: newWorker.position.y), size: CGSize(width: size.width/15, height: size.width/15), id: i)
            newTool.assignToWorker(position: newWorker.position)
            newTool.sprite.zPosition = 5
            workers[i].tool = newTool
            self.addChild(newTool.sprite)
            tools.append(newTool)
        }
        
        
        addChild(pauseNode)
        addChild(instructionNode)
        addChild(background)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if let name = touchedNode.name {
                pauseNode.checkPauseNodePressed(view: self, touchedNode: touchedNode)
                AppManager.shared.checkSounds(name: name)
                if(name == "startButton" || name == "startLabel") {
                    instructionNode.buttonPressed()
                    self.start = true
                    instructionNode.run(AppManager.shared.fadeOut) {
                        self.instructionNode.removeFromParent()
                        for worker in self.workers {
                            worker.workAndStop(duration: 3)
                        }
                        self.run(SKAction.wait(forDuration: 3)) {
                            for worker in self.workers {
                                if let requirement = worker.requirement {
                                    requirement.alpha = 1
                                }
                            }
                        }
                        self.run(SKAction.wait(forDuration: 5)) {
                            self.addChild(self.chatNode)
                        }
                    }
                }
                if(name.contains("tool")) {
                    for tool in tools {
                        if tool.sprite.name == name {
                            selectedTool = tool
                            initialTouchPosition = location
                        }
                    }
                }
                if(name == "nextButtonGreen") {
                    if(!AppManager.shared.pauseStatus) {
                        if(!waiting) {
                            curText += 1
                        }
                    
                        if(curText >= deadlockTxt.count - 1) {
                            changeChatText()
                            self.addChild(resetButton)  
                            chatNode.nextButtonTemp.removeFromParent()
                        } 
                        else {
                            if(!waiting) {
                                changeChatText()
                            }
                        }
                    }
                    
                    
                }
                if name == "resetButton" {
                    var i = 0
                    for worker in self.workers {
                        worker.sprite.removeAllChildren()
                        worker.progressBar.resetProgress()
                        if let tool = worker.tool {
                            tool.unassingTool()
                            tool.sprite.position = CGPoint(x: size.width/2, y: size.height/2 + tool.sprite.size.height * 2 * CGFloat(tool.type))
                            worker.requirement = nil
                            tool.isBeeingUsed = false
                            worker.secondRequirement = nil
                        }
                        worker.secondTool = nil
                        worker.tool = nil
                        workers[i].addRequirement(type: i > 0 ? 0 : 1)
                        workers[i].addSecondRequirement(type: i > 0 ? 1 : 0)
                        i += 1
                    }
                    self.resetButton.texture = SKTexture(imageNamed: "RestartButtonPressed")
                    self.run(SKAction.wait(forDuration: 0.2)) {
                        self.resetButton.removeFromParent()
                        self.curText = 0
                        self.lvl = 1
                        self.changeChatText()
                        self.chatNode.nextButtonTemp.removeFromParent()
                    }
                   
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let selectedTool = selectedTool else { return }
        let touchLocation = touch.location(in: self)
        let deltaX = touchLocation.x - initialTouchPosition.x
        let deltaY = touchLocation.y - initialTouchPosition.y
        
        let newX = selectedTool.sprite.position.x + deltaX
        let newY = selectedTool.sprite.position.y + deltaY
        
        let halfWidth = selectedTool.sprite.size.width / 2
        let halfHeight = selectedTool.sprite.size.height / 2
        let minX = halfWidth
        let maxX = self.size.width - halfWidth
        let minY = halfHeight
        let maxY = self.size.height - halfHeight
        
        if lvl >= 1 {
            if(!selectedTool.isBeeingUsed) {
                moveTool(tool: selectedTool, minX: minX, minY: minY, maxX: maxX, maxY: maxY, newX: newX, newY: newY)
            }
            for worker in workers {
                if(!selectedTool.isBeeingUsed) {
                    if selectedTool.sprite.intersects(worker.sprite) && !worker.finishedWorking {
                        if worker.tool != nil {
                            worker.secondTool = selectedTool
                            selectedTool.assignToWorker(position: CGPoint(x: worker.sprite.position.x - worker.sprite.size.width/4, y: worker.sprite.position.y))
                            if let secondRequirement = worker.secondRequirement {
                                if(secondRequirement.type == selectedTool.type) {
                                    secondRequirement.removeFromParent()
                                }
                            }
                            if let requirement = worker.requirement {
                                if(requirement.type == selectedTool.type) {
                                    requirement.removeFromParent()
                                }
                            }
                        } else {
                            if let curWorker {
                                if(worker.type != curWorker.type) {
                                    break
                                }
                            }
                            curWorker = worker
                            selectedTool.assignToWorker(position: CGPoint(x: worker.sprite.position.x + worker.sprite.size.width, y: worker.sprite.position.y))
                            worker.tool = selectedTool

                            if let secondRequirement = worker.secondRequirement {
                                if(secondRequirement.type == selectedTool.type) {
                                    secondRequirement.removeFromParent()
                                }
                            }
                            if let requirement = worker.requirement {
                                if(requirement.type == selectedTool.type) {
                                    requirement.removeFromParent()
                                }
                            }
                            worker.secondRequirement?.isMet = true
                        }
                        if(!worker.working && !worker.finishedWorking) {
                            if worker.tool != nil && worker.secondTool != nil {
                                worker.beginWork(duration: 3, newWidth: worker.sprite.size.width)
                                self.run(SKAction.wait(forDuration: 3)) {
                                    self.curText += 1
                                    self.changeChatText()
                                    self.curWorker = nil
                                    self.lvl += 1
                                    if(self.lvl >= 3) {
                                        SoundManager.shared.playAudio(audio: "Achievement", loop: false, volume: 0.1)
                                        self.addChild(self.macintosh)
                                        self.macintosh.run(SKAction.fadeIn(withDuration: 0.5))
                                        
                                        self.run(SKAction.sequence(
                                            [SKAction.wait(forDuration: 1),
                                             SKAction.fadeOut(withDuration: 1),
                                             SKAction.run {
                                            let conclusionScene = ConclusionScene(size: self.size)
                                            conclusionScene.scaleMode = self.scaleMode
                                            self.view?.presentScene(conclusionScene)
                                        }]))
                               
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
        }
        
        
        initialTouchPosition = touchLocation
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedTool = nil
        initialTouchPosition = .zero
    }
    
    override func update(_ currentTime: TimeInterval) {
    
    }
    
    func moveTool(tool: Tool, minX: CGFloat, minY:CGFloat, maxX: CGFloat, maxY: CGFloat, newX: CGFloat, newY: CGFloat) {
        tool.sprite.position.x = max(minX, min(maxX, newX))
        tool.sprite.position.y = max(minY, min(maxY, newY))
    }
    
   
    func changeChatText() {
            if let nextButton = chatNode.childNode(withName: "nextButtonGreen") as? SKSpriteNode {
                //depois rever animacao de esperar 2 segundos antes de trocar
                nextButton.texture = SKTexture(imageNamed: "RightButtonGray")
                self.waiting = true
                let wait = SKAction.wait(forDuration: 2.5)
                self.run(wait) {
                    nextButton.texture = SKTexture(imageNamed: "RightButton")
                    self.waiting = false
                }
                if let message = chatNode.childNode(withName: "message") {
                    let fadeIn = SKAction.fadeIn(withDuration: 1)
                    message.alpha = 0
                    message.run(fadeIn)
                }
            }
        if lvl == 0 {
            chatNode.changeText(text: deadlockTxt[curText])
        }
        else {
            chatNode.changeText(text: deadlockTxt2[curText])
        }
    }
    

} 

