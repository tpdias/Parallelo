import SwiftUI

@main
struct MyApp: App {
    @State private var finishedOnboarding = false
    var body: some Scene {
        WindowGroup {
//            if(!finishedOnboarding) {
//                OnboardingView(finishedOnboarding: $finishedOnboarding)
//            }
//            else {
                MainMenuView()
//            }
        }
    }
}
