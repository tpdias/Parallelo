import UIKit
import SwiftUI

struct OnboardingView: View {

    @State private var currentPage = 0
    @Binding var finishedOnboarding: Bool
    @State private var font: UIFont?
    private let onboardingPages = [
        OnboardingPage(imageName: "onboarding1", title: "Welcome to\nThiago's Parallel Adventure", description: "The app was designed to be used on the iPad in landscape mode."),
        OnboardingPage(imageName: "onboarding2", title: "Configurations", description: "You can turn on/off the Sound and change the App Font in any page for a better experience.\nThe OpenDyslexic font is designed to enhance readability and accessibility for individuals with dyslexia."),
        OnboardingPage(imageName: "onboarding3", title: "Voice Over", description: "You can activate the Voice Over in any configuration page and use simple voice commands, here are the list of commands: ")
    ]

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<onboardingPages.count) { index in
                    OnboardingPageView(onboardingPage: onboardingPages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            
            Button(action: {
                currentPage += 1
                if(currentPage >= onboardingPages.count) {
                    finishedOnboarding = true
                }
            }) {
                if(currentPage == (onboardingPages.count - 1)) {
                    Text("Start")
                        .padding()
                        .font(Font.custom(AppManager.shared.appFont, size: 28))
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }else {
                    Text("Next")
                        .padding()
                        .font(Font.custom(AppManager.shared.appFont, size: 28))
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
        

}

struct OnboardingPageView: View {
    let onboardingPage: OnboardingPage
    
    var body: some View {
        VStack {            
            Text(onboardingPage.title)
                .fontWeight(.bold)
                .font(Font.custom(AppManager.shared.appFont, size: 48))
                .padding()
                .multilineTextAlignment(.center)
                
            Text(onboardingPage.description)
                .multilineTextAlignment(.center)
                .font(Font.custom(AppManager.shared.appFont, size: 28))
                .padding()
                .padding(.top, 50)
                
            Image(onboardingPage.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
        }
    }
}

struct OnboardingPage {
    let imageName: String
    let title: String
    let description: String
}


