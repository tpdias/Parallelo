import SwiftUI
import SpriteKit


class DependencyGameScene: SKScene {
    var pauseNode: PauseNode
    
    var background: SKSpriteNode
    var workers: [Worker] = []
    var stations: [Station] = []
    var tools: [Tool] = []
    var progressBar: ProgressNode
    
    var instructionNode: InstructionNode
    var selectedTool: Tool?
    
    var initialTouchPosition: CGPoint
    
    var start: Bool = false
    var lvl: Int = 0
    
    override init(size: CGSize) {
        instructionNode = InstructionNode(instruction: "Now we're going to learn about Dependency, process can depend of some resource to perform their tasks, like a worker depending of his/hers tools, so they wait until the operational sistem gives it its resource", title: "Dependency", size: size)
        instructionNode.changeButtonText(text: "Next")
        instructionNode.zPosition = 5
        pauseNode = PauseNode(size: size)
        pauseNode.zPosition = 6
        initialTouchPosition = .zero
        background = SKSpriteNode(imageNamed: "FactoryFloor")
        background.scale(to: size)
        background.zPosition = -1
        background.name = "background"
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        
        progressBar = ProgressNode(size: CGSize(width: size.width - 200, height: size.height/6), indicatorColor: UIColor.mainGreen, position: CGPoint(x: 100, y: 100))
        super.init(size: size)

        //station and workers initiale
        for i in 0..<3 {
            let newStation = SKSpriteNode(imageNamed: "StationEmpty")
            let newWorker = SKSpriteNode(imageNamed: "workerSTD0")
            newStation.scale(to: CGSize(width: size.width/4, height: size.height/4))
            newWorker.scale(to: CGSize(width: size.width/11, height: 1.5 * size.width/11))
            var pos = CGPoint(x: size.width/4, y: size.height/2.5)
            switch i {
            case 1:
                pos.x = size.width/1.25
              //  let newSign = SignNode(spriteName: "Processor", text: "M3 Processor", position: CGPoint(x: pos.x + newStation.size.width/2 + 50, y: pos.y), size: CGSize(width: size.width/15, height: size.height/15))
              //  newSign.zPosition = 2
             //   self.addChild(newSign)
            case 2:
                pos.y = size.height/1.5
                pos.x = size.width/2
//                 let newSign = SignNode(spriteName: "Keyboard", text: "keyboard", position: CGPoint(x: pos.x + newStation.size.width/2 + 50, y: pos.y), size: CGSize(width: size.width/15, height: size.height/15))
//                newSign.zPosition = 2
//                self.addChild(newSign)
            default:
//                 let newSign = SignNode(spriteName: "Screen", text: "Screen", position: CGPoint(x: pos.x + newStation.size.width/2 + 50, y: pos.y), size: CGSize(width: size.width/15, height: size.height/15))
//                newSign.zPosition = 2
//                self.addChild(newSign)
                break
            }
            newStation.position = pos
            newWorker.position = pos
            newStation.zPosition = 1
            newWorker.zPosition = 2
            newStation.name = "station" + String(i)
            newWorker.name = "worker" + String(i)
            self.addChild(newStation)
            self.addChild(newWorker)
            stations.append(Station(sprite: newStation))
            if(i == 1) {
                workers.append(Worker(type: i, sprite: newWorker, requirement: 1, secondRequirement: nil))
            } else {
                workers.append(Worker(type: i, sprite: newWorker, requirement: nil, secondRequirement: nil))
            }
        }
        let newWrench = Tool(type: 1, position: CGPoint(x: size.width/2 - 100, y: progressBar.position.y + size.height/8 + progressBar.background.size.height), size: CGSize(width: size.width/15, height: size.width/15), id: 0)
        tools.append(newWrench)
        let newHammer = Tool(type: 0, position: CGPoint(x: size.width/2 + 100, y: progressBar.position.y + size.height/8 + progressBar.background.size.height), size: CGSize(width: size.width/15, height: size.width/15), id: 1)
        tools.append(newHammer)

        
        addChild(progressBar)
        addChild(pauseNode)
        addChild(instructionNode)
        addChild(background)
        addChild(newWrench.sprite)
        addChild(newHammer.sprite)
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
                       // self.workers[2].workAndStop()
                    }
                }
                if(name == "nextButton" || name == "nextLabel") {
                    instructionNode.buttonPressed()
                    self.run(AppManager.shared.wait) { 
                        self.instructionNode.changeInstruction(instruction: "We need to be careful to not cause deadlocks, when we create a cycle of dependencies, where all the process are waiting for resources that are been held by another process in the cycle", instructionTitle: "Deadlock")
                        self.instructionNode.changeButtonText(text: "Start")
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
        
        
        if(lvl == 0) {
            if(!AppManager.shared.pauseStatus && !selectedTool.isBeeingUsed) {
                moveTool(tool: selectedTool, minX: minX, minY: minY, maxX: maxX, maxY: maxY, newX: newX, newY: newY)
            }
            for worker in workers {
                if(selectedTool.sprite.intersects(worker.sprite) && !worker.finishedWorking && !worker.working) {
                    if worker.tool == nil {
                        if let requirement = worker.requirement {
                            if requirement.type != selectedTool.type {
                                break
                            }
                        }
                        selectedTool.assignToWorker(position: worker.sprite.position)
                        worker.tool = selectedTool
                        
                        if(worker.pausedWorking) {
                            worker.resumeWork()
                        } else {
                            worker.progressBar.increaseProgress(toWidth: worker.sprite.size.width / worker.scaleFactor, duration: 3)
                            worker.begginWork()
                        }
                        self.selectedTool = nil
                        self.initialTouchPosition = .zero
                    }
                    break  
                }
            }
        }
        else { 
            var count = 0
            for worker in workers {
                guard let requirement = worker.requirement,
                      let secondRequirement = worker.secondRequirement else { return }
                if(selectedTool.sprite.intersects(worker.sprite)) {
                    if(requirement.type == selectedTool.type){
                        count += 1
                        requirement.isMet = true
                        selectedTool.assignToWorker(position: worker.sprite.position)
                    } else {
                        if(secondRequirement.type == selectedTool.type) {
                            count += 1
                            secondRequirement.isMet = true
                            selectedTool.assignToWorker(position: CGPoint(x: worker.sprite.position.x + selectedTool.sprite.size.width, y: worker.sprite.position.y))
                        }
                    }
                   
                } else {
                    if(requirement.type == selectedTool.type) {
                        requirement.isMet = false
                    }
                    if(secondRequirement.type == selectedTool.type) {
                        secondRequirement.isMet = false
                    }
                } 
                if(count == 0) {
                    selectedTool.unassingTool()
                }
                if(!worker.working && !worker.finishedWorking) {
                    if(requirement.isMet && secondRequirement.isMet) {
                        worker.begginWork()
                    }
                    else {
                        moveTool(tool: selectedTool, minX: minX, minY: minY, maxX: maxX, maxY: maxY, newX: newX, newY: newY)
                    }
                } 
                if(worker.finishedWorking) {
                    moveTool(tool: selectedTool, minX: minX, minY: minY, maxX: maxX, maxY: maxY, newX: newX, newY: newY)
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
        for worker in workers {
            if(worker.finishedWorking) {
                worker.finishWorking()
                if let tool = worker.tool {
                    tool.unassingTool()
                }
                worker.progressBar.removeFromParent()
                if let tool = worker.tool {
                    tool.isBeeingUsed = false
                    worker.tool = nil
                }
                
                if(!worker.sleeping) {
                    progressBar.increaseProgress(toWidth: (progressBar.progressWidth + progressBar.background.size.width/3), duration: 1)
                    worker.sleeping = true
                }
            }
        }
        if(progressBar.progressWidth >= progressBar.background.size.width - 100) {
            progressBar.progressWidth = 0
            nextLevel()
        }
    }
    func moveTool(tool: Tool, minX: CGFloat, minY:CGFloat, maxX: CGFloat, maxY: CGFloat, newX: CGFloat, newY: CGFloat) {
        tool.sprite.position.x = max(minX, min(maxX, newX))
        tool.sprite.position.y = max(minY, min(maxY, newY))
    }
    func nextLevel() {
        let wait = SKAction.wait(forDuration: 2)
        instructionNode = InstructionNode(instruction: "\tDeadlock is a concept in programming where all the process are waiting for a resource that they never get, creating a cicle where no process is working, just waiting. One way to fix it is to not let the process hold the resources while not working, try to fix the deadlock removing resources from the workers that are not working and assigning them to other workers.", title: "Deadlock", size: size)
        instructionNode.alpha = 0
        addChild(instructionNode)
        self.run(wait){  
            self.progressBar.progressWidth = 0
            self.progressBar.progressIndicator.size.width = 0
            self.start = false
            let fadeIn = SKAction.fadeIn(withDuration: 1)           
            self.instructionNode.run(fadeIn)
            self.instructionNode.zPosition = 3
            self.resetWorkers()
            self.resetTools()
            self.initialTouchPosition = .zero
            self.selectedTool = nil
            self.lvl += 1
        }
        
    }
    func resetWorkers() {
        for i in 0..<workers.count {
            self.workers[i].type = i
            self.workers[i].resetWorker()
            self.workers[i].animateSTD()
        }
    }
    func resetTools() {
        for tool in tools {
            tool.sprite.removeFromParent()
        }
        self.tools = []
        for i in 0..<3 {
         
            let size = CGSize(width: size.width/15, height: size.width/15)
            let pos = CGPoint(x: workers[i].sprite.position.x + size.width, y: workers[i].sprite.position.y)
          
            let newTool = Tool(type: i, position: pos, size: size, id: i)
            tools.append(newTool)
            self.addChild(newTool.sprite)
        }
    }
}
