import SwiftUI
import SpriteKit

class Worker {
    var type: Int
    var sprite: SKSpriteNode
    var working: Bool = false
    var finishedWorking: Bool = false
    var pausedWorking: Bool = false
    var progressBar: ProgressNode
    var tool: Tool?
    var secondTool: Tool? = nil
    var requirement: RequirementNode? = nil
    var secondRequirement: RequirementNode? = nil
    var sleeping: Bool = false
    var scaleFactor: CGFloat
    init(type: Int, sprite: SKSpriteNode, requirement: Int?, secondRequirement: Int?) {
        tool = nil
        self.scaleFactor = sprite.xScale
        self.sprite = sprite
        self.type = type
        let name = SKLabelNode(text: "Worker")
        name.fontName = AppManager.shared.appFont
        name.fontSize = 24 / scaleFactor
        name.fontColor = .black
        name.position = CGPoint(x: 0, y: -sprite.size.height / scaleFactor / 2.5)
        name.zPosition = 2
        
        
        
        progressBar = ProgressNode(size: CGSize(width: sprite.size.width / scaleFactor, height: sprite.size.height / scaleFactor / 2), indicatorColor: UIColor.mainGreen, position: CGPoint(x: (-sprite.size.width / scaleFactor / 2), y: -(sprite.size.height / scaleFactor) / 2))
        self.sprite.addChild(name)
        
        if let requirement = requirement {
            let newReq = RequirementNode(size: CGSize(width: sprite.size.width/2 / scaleFactor, height: sprite.size.width/2 / scaleFactor), pos: CGPoint(x: self.sprite.size.width / scaleFactor, y: (self.sprite.size.height / 1.8) / scaleFactor), type: requirement)
            self.requirement = newReq
            newReq.zPosition = 3
            self.sprite.addChild(newReq)
        }
        if let secondRequirement = secondRequirement {
            let newReq = RequirementNode(size: CGSize(width: sprite.size.width/2 / scaleFactor, height: sprite.size.width/2 / scaleFactor), pos: CGPoint(x: -50 / scaleFactor, y: -50 / scaleFactor), type: secondRequirement)
            self.secondRequirement = newReq
            newReq.zPosition = 3
            self.sprite.addChild(newReq)
        }
        animateSTD()
    }
    func addRequirement(type: Int) {
        let newReq = RequirementNode(size: CGSize(width: sprite.size.width/2 / scaleFactor, height: sprite.size.width/2 / scaleFactor), pos: CGPoint(x: self.sprite.size.width / scaleFactor, y: (self.sprite.size.height / 1.8) / scaleFactor), type: type)
        self.requirement = newReq
        newReq.zPosition = 3
        self.sprite.addChild(newReq)
    }
    func addSecondRequirement(type: Int) {
        let newReq = RequirementNode(size: CGSize(width: sprite.size.width/2 / scaleFactor, height: sprite.size.width/2 / scaleFactor), pos: CGPoint(x: -self.sprite.size.width / scaleFactor, y: (self.sprite.size.height / 1.8) / scaleFactor), type: type)
        self.secondRequirement = newReq
        newReq.zPosition = 3
        self.sprite.addChild(newReq)
    }
    func workAndStop(duration: TimeInterval) {
        //sprite.run(SKAction.wait(forDuration: 1)) { [self] in
            sprite.removeAllActions()
            animateWork()
            sprite.addChild(progressBar)
            working = true
            progressBar.increaseProgress(toWidth: sprite.size.width / scaleFactor / 2, duration: duration)
            sprite.run(SKAction.wait(forDuration: duration)) { [self] in
                animateSTD()
                //self.workers[2].progressBar.progressIndicator.removeAllActions()
                working = false
                pausedWorking = true
            }
       // }
    }
    func beginWork(duration: TimeInterval, newWidth: CGFloat) {
        self.sprite.removeAllActions()
        animateWork()
        working = true 
        progressBar.increaseProgress(toWidth: (newWidth / scaleFactor), duration: duration)
        let work = SKAction.wait(forDuration: duration) 
        sprite.run(work) {
            self.finishWorking()
        }
        sprite.addChild(progressBar)
    }
    func animateWork() {
        self.sprite.removeAllActions()
        let textures = [SKTexture(imageNamed: "workerWorking0"), SKTexture(imageNamed: "workerWorking1")]
        let action = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 1/3, resize: false, restore: true))
        SoundManager.shared.playAudio(audio: "Hammer", loop: false, volume: 0.1)
        self.sprite.run(action)
    }
    func animateSTD() {
        self.sprite.removeAllActions()
        let textures = [SKTexture(imageNamed: "workerSTD0"), SKTexture(imageNamed: "workerSTD1")]
        let action = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 1/2, resize: false, restore: true))
        self.sprite.run(action)
    }
    
    func finishWorking() {
        working = false
        sprite.removeAllActions()
        animateSTD()
        finishedWorking = true
        if let tool = self.tool {
            tool.unassingTool()
            self.tool = nil
        }
        if let secondTool = self.secondTool {
            secondTool.unassingTool()
            self.secondTool = nil
        }
        if let requirement = self.requirement {
            requirement.removeFromParent()
        }
        if let secondRequirement = self.secondRequirement {
            secondRequirement.removeFromParent()
        }
        progressBar.resetProgress()
        progressBar.removeFromParent()
    }
    func resumeWork() {
        sprite.removeAllActions()
        animateWork()
        working = true
        let work = SKAction.wait(forDuration: 1.5)
        sprite.run(work) {
            self.working = false
            self.finishWorking()
        }
        progressBar.increaseProgress(toWidth: sprite.size.width / scaleFactor, duration: 1.5)
    }
    
    func workWithTool() {
        progressBar.increaseProgress(toWidth: sprite.size.width / scaleFactor, duration: 3)
        self.sprite.run(AppManager.shared.wait) {
            self.finishedWorking = true
        }
        
    }
    func resetWorker() {
        self.progressBar.removeFromParent()
        self.finishedWorking = false
        self.pausedWorking = false
        self.sleeping = false
        self.tool = nil
        self.working = false
        self.requirement = RequirementNode(size: CGSize(width: sprite.size.width/2 / scaleFactor, height: sprite.size.width/2 / scaleFactor), pos: CGPoint(x: self.sprite.size.width / scaleFactor, y: (self.sprite.size.height / 1.8) / scaleFactor), type: type)
        let sndReq = type >= 2 ? 0 : (type + 1)
        self.secondRequirement = RequirementNode(size: CGSize(width: sprite.size.width/2 / scaleFactor, height: sprite.size.width/2 / scaleFactor), pos: CGPoint(x: -self.sprite.size.width / scaleFactor, y: (self.sprite.size.height / 1.8) / scaleFactor), type: sndReq)

        self.progressBar.resetProgress()
        self.sprite.addChild(self.progressBar)
        if let requirement = requirement,
           let secondRequirement = secondRequirement {
            self.sprite.addChild(requirement)
            self.sprite.addChild(secondRequirement)
        }
        else {
            print("Erro")
        }
    }
}
