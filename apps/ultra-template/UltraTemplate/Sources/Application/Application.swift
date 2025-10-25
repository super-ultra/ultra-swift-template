import SwiftUI

@main
struct Application: App {
    // MARK: - App

    var body: some Scene {
        WindowGroup {
            MainView(model: DefaultMainViewModel())
        }
    }

}
