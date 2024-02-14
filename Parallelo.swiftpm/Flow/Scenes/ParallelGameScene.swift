import SwiftUI
import SpriteKit

let instructions:[String] = [
"Add a worker by dragging one to a Station",
"Wait until they finished their task",
"Add a new Worker to the station",
"Nice! keep working until you craft a MacBook",
"Well done! You've build a MacBook M3 Pro!"
]


class ParallelGameScene: SKScene {
    var pauseNode: PauseNode
    var start: Bool
    var background: SKSpriteNode
    var instruction: SKLabelNode
    var instructionNode: InstructionNode
    var curInstruction = 0
    var stations: [Station] = []
    var workers: [Worker] = []

    var questionNode: QuestionNode
    var lvl: Int = 0
    
    //time controller
    var timerLabel: SKLabelNode
    var timer: Timer!
    var seconds = 0
    var singleCoreTime = 0
    var multiCoreTime = 0
    
    //variables to move the worker
    var selectedWorker: Worker?
    var initialTouchPosition: CGPoint = .zero
    
    //variables to controll the working worker
    var isAny1Working: Bool = false
    
    //progressBar
    var progressBar: ProgressNode
    var progress: Int = 0
    
    override init(size: CGSize) {
        background = SKSpriteNode(imageNamed: "FactoryFloor")
        background.size = size
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        background.name = "factoryBackground"
        self.pauseNode = PauseNode(size: size)
        pauseNode.zPosition = 4

        instruction = SKLabelNode(text: instructions[curInstruction])
        instruction.position = CGPoint(x: size.width/2, y: size.height - 48 * 2)
        instruction.fontSize = 28
        instruction.fontName = AppManager.shared.appFont
        instruction.fontColor = .black
        instruction.zPosition = 1
     
        progressBar = ProgressNode(size: CGSize(width: size.width - 200, height: size.height/6), indicatorColor: UIColor.mainGreen, position: CGPoint(x: 100, y: 100))
        
        
        timerLabel = SKLabelNode(text: String(seconds))
        timerLabel.position = CGPoint(x: 100, y: size.height - 100)
        timerLabel.fontSize = 32
        timerLabel.fontName = AppManager.shared.appFont
        timerLabel.fontColor = .black
        timerLabel.zPosition = 1
        
        start = false
        instructionNode = InstructionNode(instruction: "\tIn this analogy we have workers, in computation they would be process, we can create process to perfom tasks in programming, so we can do these tasks in parallel. Our computers execute numerous amounts of process at the same time. The station is the CPU Core, where the tasks are done, there can only be one task each time by station. So let's build ourselves a Macbook!", title: "Let's build a MacBook", size: size)
        instructionNode.zPosition = 3
        
        questionNode = QuestionNode(size: CGSize(width: size.width / 2.3 , height: size.height / 2.3), position: CGPoint(x: size.width, y: size.height - 200), questions: [])
        questionNode.zPosition = 5
        questionNode.name = "questionNode"
        
        super.init(size: size)
        
        let newStation = SKSpriteNode(imageNamed: "StationEmpty")
        newStation.position = CGPoint(x: size.width/2, y: size.height/2)
        newStation.zPosition = 1
        newStation.scale(to: CGSize(width: size.width/4, height: size.height/4))
        newStation.name = "station"
        self.addChild(newStation)
        self.stations.append(Station(sprite: newStation))
        
        resetWorkers()
        
        
        addChild(background)
        addChild(timerLabel)
        
        //instruction
        addChild(progressBar)
        addChild(instruction)
        addChild(pauseNode)
        addChild(instructionNode)
    }
    
    @objc func updateTimer() {
        if(!AppManager.shared.pauseStatus && start) {
            seconds += 1
            timerLabel.text = "\(seconds)"
        }
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
                if(name == "startButton" || name == "startLabel") {
                    instructionNode.buttonPressed()
                    self.start = true
                    let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                    instructionNode.run(fadeOut) {
                        if(self.timer == nil) {
                            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
                        }
                        self.instructionNode.removeFromParent()
                    }
                }
                if(name.contains("Button") && AppManager.shared.soundStatus) {
                    SoundManager.shared.playButtonSound()
                }
                if(name.contains("Toggle") && AppManager.shared.soundStatus) {
                    SoundManager.shared.playToggleSound()
                }
                if(name.contains("worker")) {
                    for worker in workers {
                        if(worker.sprite.name == name) {
                            self.selectedWorker = worker 
                            self.initialTouchPosition = location
                            break
                        }
                    }
                }
                if(name.contains("questionBackground") || name.contains("questionLabel")) {
                    
                    var texture = SKTexture(imageNamed: "ChatWrongBackground")
                    if(name.contains("1")) {
                        texture = SKTexture(imageNamed: "ChatRightBackground")
                    }
                    if let last = name.last {
                       
                        if let index = Int(last.description) {
                          
                            self.questionNode.questions[index].background.texture = texture
                            
                            if(index == 1) {
                                let fadeOut = SKAction.fadeOut(withDuration: 1)
                                self.run(fadeOut) {
                                    self.questionNode.removeFromParent()
                                    let dependencyGameScene = DependencyGameScene(size: self.size)
                                    dependencyGameScene.scaleMode = self.scaleMode
                                    self.view?.presentScene(dependencyGameScene)
                                }
                            }
                        }
                    }
                    
                   
                }
                
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let selectedWorker = selectedWorker else { return }
        let touchLocation = touch.location(in: self)
        let deltaX = touchLocation.x - initialTouchPosition.x
        let deltaY = touchLocation.y - initialTouchPosition.y
        
        let newX = selectedWorker.sprite.position.x + deltaX
        let newY = selectedWorker.sprite.position.y + deltaY
        
        let halfWidth = selectedWorker.sprite.size.width / 2
        let halfHeight = selectedWorker.sprite.size.height / 2
        let minX = halfWidth
        let maxX = self.size.width - halfWidth
        let minY = halfHeight
        let maxY = self.size.height - halfHeight
        
        if(!AppManager.shared.pauseStatus && !selectedWorker.working) {
            selectedWorker.sprite.position.x = max(minX, min(maxX, newX))
            selectedWorker.sprite.position.y = max(minY, min(maxY, newY))
        }
        
        for station in stations {
            if(selectedWorker.sprite.intersects(station.sprite)) {
                if station.workingWorker == nil {
                    selectedWorker.sprite.position = station.sprite.position 
                    station.workingWorker = selectedWorker
                    selectedWorker.begginWork()
                    selectedWorker.progressBar.increaseProgress(toWidth: selectedWorker.sprite.size.width / selectedWorker.scaleFactor, duration: 3)
                    self.selectedWorker = nil
                    self.initialTouchPosition = .zero
                    if(self.progress == 0) {
                        self.nextInstruction()
                    }
                }
                break  
            }
        }
        
        initialTouchPosition = touchLocation
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedWorker = nil
        initialTouchPosition = .zero
    }
    
    override func update(_ currentTime: TimeInterval) {
        for station in stations {
            if let workingWorker = station.workingWorker {
                if(!workingWorker.working) {
                    nextInstruction()
                    workingWorker.sprite.removeFromParent()
                    station.workingWorker = nil
                    self.progress += 1
                    progressBar.increaseProgress(toWidth: (progressBar.progressWidth + progressBar.background.size.width/6), duration: 1)
                }
            }
        }
        if(progressBar.progressWidth >= progressBar.background.size.width) {
            progressBar.progressWidth = 0
            nextLevel()
        }
    }
    func nextLevel() {
        let wait = SKAction.wait(forDuration: 2)
        instructionNode = InstructionNode(instruction: "\tThis time we are going to have 4 stations, a fourth of the new MacBook M3 Pro full core capacity, by assigning each worker to a unique station, they can work without needing to wait to the station to be free, so the final result can be achived way faster!", title: "Now lets use Parallelization to Speed it Up!", size: size)
        instructionNode.alpha = 0
        addChild(instructionNode)
        self.run(wait){  [self] in
            progressBar.progressWidth = 0
            progressBar.progressIndicator.size.width = 0
            curInstruction = 0
            start = false
            let fadeIn = SKAction.fadeIn(withDuration: 1)           
            instructionNode.run(fadeIn) {
            }
            instructionNode.zPosition = 3
            resetWorkers()
            resetStations()
            lvl += 1
            if(lvl == 1) {
                singleCoreTime = seconds
                seconds = 0
            } else {
                if (lvl == 2) {
                    multiCoreTime = seconds
                    seconds = 0
                    removeWorkers()
                    removeStations()
                    instructionNode.instructionLabel.text = "Considering that your time with one station, single core, was \(singleCoreTime), your time with multiple stations, multi core, was \(multiCoreTime) what is the speed up from going to 4 stations? Considering Speed up = (single core time / multi core time) * 100"
                    instructionNode.startButton.removeFromParent()
                    instructionNode.startButtonLabel.removeFromParent()
                    #warning("mudar o speedup ta errado KKKK a formula tbm")
                    questionNode.addQuestions(questions:  ["\(singleCoreTime * 100/multiCoreTime - 57)%",
                                                           "\(singleCoreTime * 100/multiCoreTime)%",
                                                           "\(singleCoreTime * 100/multiCoreTime + 61)%", 
                                                           "\((singleCoreTime * 100/multiCoreTime) - 20)%"]) 
                   
                    addChild(questionNode)
                    lvl += 1
                } 
            }
        }
    }
    func resetWorkers() {
        removeWorkers()
        for i in 0..<3 {
           
                let newWorker = SKSpriteNode(imageNamed: "workerSTD0")
                newWorker.zPosition = 2
            newWorker.scale(to: CGSize(width: size.width/11, height: 1.5 * size.width / 11))
                newWorker.position = CGPoint(x: size.width/8, y:  size.height/4 + newWorker.size.height * 1.2 * CGFloat(i))
                newWorker.name = "worker" + String(i)
                self.workers.append(Worker(type: (i)%2, sprite: newWorker, requirement: nil, secondRequirement: nil))
                self.addChild(newWorker)
        }
        for i in 0..<3 {
            let newWorker = SKSpriteNode(imageNamed: "workerSTD0")
            newWorker.zPosition = 2
            newWorker.scale(to: CGSize(width: size.width/11, height: 1.5 * size.width / 11))
            newWorker.position = CGPoint(x: size.width/8 + newWorker.size.width * 1.5, y: size.height/4 + newWorker.size.height * 1.2 * CGFloat(i))
            newWorker.name = "worker" + String(i + 4)
            self.workers.append(Worker(type: (i)%2, sprite: newWorker, requirement: nil, secondRequirement: nil))
            self.addChild(newWorker)
        }
    }
    
    func removeWorkers() {
        for worker in workers {
            worker.sprite.removeFromParent()
        }
        workers = []
    }
    
    func removeStations() {
        for station in stations {
            station.sprite.removeFromParent()
        }
        stations = []
    }
    
    func resetStations() {
        removeStations()
        for i in 0..<2 {
            for j in 0..<2 {
                let newStation = SKSpriteNode(imageNamed: "StationEmpty")
                newStation.scale(to: CGSize(width: size.width/4, height: size.height/4))
                newStation.position = CGPoint(x: size.width/2 + CGFloat(j) * newStation.size.width * 1.5, y: size.height/3 + newStation.size.height * 1.4 * CGFloat(i))
                newStation.zPosition = 1
                newStation.name = "station" + String(i + j)
                self.addChild(newStation)
                self.stations.append(Station(sprite: newStation))
            }
        }
    }
    func nextInstruction() {
        self.curInstruction += 1
        switch curInstruction {
        case 1:
            instruction.text = instructions[curInstruction]
        case 2:
            instruction.text = instructions[curInstruction]
        case 3:
            instruction.text = instructions[curInstruction]
            break
        case 4:
            break
        case 5:
            break
        case 6: break
        default:
            instruction.text = instructions.last
        }
    }
}
