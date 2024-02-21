import SwiftUI
import UIKit
import SpriteKit

@main
struct MyApp: App {
    @State private var finishedOnboarding = false
    var body: some Scene {
        WindowGroup {
            MainMenuView()
        }        
    }
}
