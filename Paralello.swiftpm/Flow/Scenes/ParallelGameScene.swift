import SwiftUI
import SpriteKit

let instructions:[String] = [
"Add a worker by dragging one to a Station",
"Wait until they finished their task",
"Add a new Worker to the station",
"Nice! keep working until you build a Macintosh",
"Well done! You've build a Macintosh!"
]
let finalInstruction: String = "Now use paralization, two workers can work at the same time" 


class ParallelGameScene: SKScene {
    var pauseNode: PauseNode
    var start: Bool
    var background: SKSpriteNode
    var instruction: SKLabelNode
    var instructionNode: InstructionNode
    var curInstruction = 0
    var stations: [Station] = []
    var workers: [Worker] = []

    var macintosh: SKSpriteNode
    
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
     
        macintosh = SKSpriteNode(imageNamed: "Macintosh")
        macintosh.scale(to: CGSize(width: size.width/2.5, height: size.width/2.5))
        macintosh.position = CGPoint(x: size.width/2, y: size.height/2)
        macintosh.zPosition = 3
        
        progressBar = ProgressNode(size: CGSize(width: size.width - 200, height: size.height/6), indicatorColor: UIColor.mainGreen, position: CGPoint(x: 100, y: 100))
        
        
        timerLabel = SKLabelNode(text: String(seconds))
        timerLabel.position = CGPoint(x: 100, y: size.height - 100)
        timerLabel.fontSize = 32
        timerLabel.fontName = AppManager.shared.appFont
        timerLabel.fontColor = .black
        timerLabel.zPosition = 1
        
        start = false
        instructionNode = InstructionNode(instruction: "\tThe workers are just like process, we use them to perfom tasks, the stations are the CPU Cores, only one process can perform on a CPU at a time", title: "Let's build a Macintosh", size: size)
      
        instructionNode.zPosition = 3
        
        questionNode = QuestionNode(size: CGSize(width: size.width * 1.3, height: size.height / 2), position: CGPoint(x: size.width, y: size.height - 300), questions: [])
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
                                    let deadlockGameScene = DeadlockGameScene(size: self.size)
                                    deadlockGameScene.scaleMode = self.scaleMode
                                    self.view?.presentScene(deadlockGameScene)
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
            if let workingWorker = station.workingWorker, workingWorker.sprite.name != selectedWorker.sprite.name {
                if selectedWorker.sprite.intersects(station.sprite) {
                    // Adjust the position of the selected worker to stay outside the station
                    let newX = selectedWorker.sprite.position.x - deltaX
                    let newY = selectedWorker.sprite.position.y - deltaY
                    selectedWorker.sprite.position.x = max(minX, min(maxX, newX))
                    selectedWorker.sprite.position.y = max(minY, min(maxY, newY))
                    break
                }
            }
            if(selectedWorker.sprite.intersects(station.sprite)) {
                if station.workingWorker == nil {
                    selectedWorker.sprite.position = station.sprite.position 
                    station.workingWorker = selectedWorker
                    selectedWorker.beginWork(duration: 3, newWidth: selectedWorker.sprite.size.width)
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
                    workingWorker.sprite.removeFromParent()
                    station.workingWorker = nil
                    self.progress += 1
                    progressBar.increaseProgress(toWidth: (progressBar.progressWidth + progressBar.background.size.width/CGFloat(workers.count)), duration: 1)
                    nextInstruction()
                   
                }
            }
        }
        if(progressBar.progressWidth >= progressBar.background.size.width - 100) {
            progressBar.progressWidth = 0
            curInstruction = 0
            nextLevel()
        }
    }
    func nextLevel() {
        let wait = SKAction.wait(forDuration: 3)
        instruction.text = instructions.last
      
        self.macintosh.alpha = 0
        self.addChild(self.macintosh)
        SoundManager.shared.playAudio(audio: "Achievement", loop: false, volume: 0.1)
        self.macintosh.run(SKAction.fadeIn(withDuration: 1.5))
        
        instructionNode = InstructionNode(instruction: "\tThis time we are going to have 4 stations, a fourth of the new MacBook M3 Pro full core capacity, by assigning each worker to a unique station, they can work without needing to wait to the station to be free, so the final result can be achived way faster!", title: "Now lets use Parallelization to Speed it Up!", size: size)
        instructionNode.alpha = 0
        addChild(instructionNode)
        self.run(wait){  [self] in
            progressBar.progressWidth = 0
            progressBar.progressIndicator.size.width = 0
            curInstruction = 0
            start = false
            let fadeIn = SKAction.fadeIn(withDuration: 1)       
            macintosh.run(SKAction.fadeOut(withDuration: 1)) {
                macintosh.removeFromParent()
            }
            instructionNode.run(fadeIn) {
            }
            instructionNode.zPosition = 3
            resetWorkers()
            resetStations()
            lvl += 1
            if(lvl == 1) {
                singleCoreTime = seconds
                seconds = 0
                curInstruction = 0
                instruction.text = "Now two workers can work simultaneously!"
            } else {
                if (lvl == 2) {
                    
                    nextInstruction()
                    multiCoreTime = seconds
                    seconds = 0
                    removeWorkers()
                    removeStations()
                    let speedup: Float = Float(singleCoreTime)/Float(multiCoreTime)
                    let formattedSpeedup = String(format: "%.2f", speedup)
                    instructionNode.instructionLabel.text = "Well done! Your time with the single core, one station, was \(singleCoreTime), your time with multiple stations, multi core, was \(multiCoreTime). You did the same task, but \(formattedSpeedup) times faster\nWhy the task was faster?"
                    questionNode.addQuestions(questions: ["The workers did their tasks faster", "Two workers could work at the same time", "With more stations, the workers can make less work", "The workers helped each other on their tasks"])
                    self.addChild(questionNode)
                    instructionNode.startButton.removeFromParent()
                    instructionNode.startButtonLabel.removeFromParent()
                    lvl += 1
                } 
            }
        }
    }
    func resetWorkers() {
        removeWorkers()
        for i in 0..<2 {
           
                let newWorker = SKSpriteNode(imageNamed: "workerSTD0")
                newWorker.zPosition = 2
            newWorker.scale(to: CGSize(width: size.width/11, height: 1.5 * size.width / 11))
                newWorker.position = CGPoint(x: size.width/8, y:  size.height/3 + newWorker.size.height * 1.2 * CGFloat(i))
                newWorker.name = "worker" + String(i)
                self.workers.append(Worker(type: (i)%2, sprite: newWorker, requirement: nil, secondRequirement: nil))
                self.addChild(newWorker)
        }
        for i in 0..<2 {
            let newWorker = SKSpriteNode(imageNamed: "workerSTD0")
            newWorker.zPosition = 2
            newWorker.scale(to: CGSize(width: size.width/11, height: 1.5 * size.width / 11))
            newWorker.position = CGPoint(x: size.width/8 + newWorker.size.width * 1.5, y: size.height/3 + newWorker.size.height * 1.2 * CGFloat(i))
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

        for j in 0..<2 {
            let newStation = SKSpriteNode(imageNamed: "StationEmpty")
            newStation.scale(to: CGSize(width: size.width/4, height: size.height/4))
            newStation.position = CGPoint(x: size.width/2, y: size.height/3 + 1.5 * newStation.size.height * CGFloat(j))
            newStation.zPosition = 1
            newStation.name = "station" + String(j)
            self.addChild(newStation)
            self.stations.append(Station(sprite: newStation))
        }
        
//        for i in 0..<2 {
//            for j in 0..<2 {
//                let newStation = SKSpriteNode(imageNamed: "StationEmpty")
//                newStation.scale(to: CGSize(width: size.width/4, height: size.height/4))
//                newStation.position = CGPoint(x: size.width/2 + CGFloat(j) * newStation.size.width * 1.5, y: size.height/3 + newStation.size.height * 1.4 * CGFloat(i))
//                newStation.zPosition = 1
//                newStation.name = "station" + String(i + j)
//                self.addChild(newStation)
//                self.stations.append(Station(sprite: newStation))
//            }
//        }
    }
    func nextInstruction() {
        if(lvl == 1) {
            
            return 
        }
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
