import SwiftUI


import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var finishedOnboarding: Bool
    private let onboardingPages = [
        OnboardingPage(imageName: "onboarding1", title: "Welcome to MyApp", description: "Explore and enjoy our app's features."),
        OnboardingPage(imageName: "onboarding2", title: "Get Started", description: "Sign up to personalize your experience."),
        OnboardingPage(imageName: "onboarding3", title: "Ready to Go", description: "Start using our app now!")
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
                Text(currentPage == onboardingPages.count - 1 ? "Get Started" : "Next")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
        }
    }
}

struct OnboardingPageView: View {
    let onboardingPage: OnboardingPage
    
    var body: some View {
        VStack {
            Image(onboardingPage.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
            
            Text(onboardingPage.title)
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Text(onboardingPage.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

struct OnboardingPage {
    let imageName: String
    let title: String
    let description: String
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        let mockFinishedOnboarding = false 
        return OnboardingView(finishedOnboarding: .constant(mockFinishedOnboarding))
    }
}
