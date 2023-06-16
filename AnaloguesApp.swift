import SwiftUI

@main
struct CameraApp: App {
    
    @State var focusValue: Float = 0.5

    init() {
        UINavigationBar.applyCustomAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            CameraView()
        }
    }
}

fileprivate extension UINavigationBar {
    
    static func applyCustomAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
