import SwiftUI
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    
    private var audioPlayer: AVAudioPlayer?
    
    func playSound(soundName: String, fileType: String) {
        if let soundURL = Bundle.main.url(forResource: soundName, withExtension: fileType) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        } else {
            print("Sound file not found")
        }
    }
}
