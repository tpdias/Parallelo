import SwiftUI
import SpriteKit

class AppManager {
    static let shared = AppManager()
    
    var soundStatus: Bool = true
    var voiceOverStatus: Bool = false
    var appFont: String = "Calibri-Bold"
    
    
    func animateToggle(toggle: SKSpriteNode, toggleState: Bool) {
        let transitionTexture = SKTexture(imageNamed: "ToggleTransition")
        var nextTexture = SKTexture()
        if(!toggleState){
            nextTexture = SKTexture(imageNamed: "ToggleOff")
        } else {
            nextTexture = SKTexture(imageNamed: "ToggleOn")
        }
        
        let changeToTransition = SKAction.setTexture(transitionTexture)
        let wait = SKAction.wait(forDuration: 0.1)
        let changeToOn = SKAction.setTexture(nextTexture)
        
        let sequence = SKAction.sequence([changeToTransition, wait, changeToOn])
        
        toggle.run(sequence)
    }
        func animateSoundButton(button: SKSpriteNode) {
            button.texture = SKTexture(imageNamed: "SoundButtonPressed")
            let waitForAnimation = SKAction.wait(forDuration: 0.2)   
            let sequence = SKAction.sequence([waitForAnimation])
            button.run(sequence) { 
                AppManager.shared.soundStatus.toggle()
                if(AppManager.shared.soundStatus) {
                    button.texture = SKTexture(imageNamed: "SoundButton")
                }
                else {
                    button.texture = SKTexture(imageNamed: "SoundButtonOff")
                }
            }
        }
}
