import SwiftUI
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    static let soundTrack = SoundManager()
    let soundtrack = "Density_&_Time_-_MAZE"
    private var audioPlayer: AVAudioPlayer?
    
    func playAudio(audio: String, loop: Bool, volume: Float) {
        guard let audioURL = Bundle.main.url(forResource: audio, withExtension: "mp3") else {
            print("No audio file found")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
            
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.volume = volume
            audioPlayer?.numberOfLoops = loop ? -1 : 0
            audioPlayer?.play()
        } catch {
            print("Couldn't play audio. Error: \(error)")
        }
    }

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
 
    func playButtonSound() {
        if let soundURL = Bundle.main.url(forResource: "buttonSound", withExtension: "mp3") {
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
    func stopSounds() {
        audioPlayer?.stop()
    }
    func playLowSound(soundName: String, fileType: String) {
        if let soundURL = Bundle.main.url(forResource: soundName, withExtension: fileType) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.volume = 0.3
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        } else {
            print("Sound file not found")
        } 
    }
    
    func playToggleSound() {
        if let soundURL = Bundle.main.url(forResource: "toggleSound", withExtension: "mp3") {
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
