import SwiftUI
import UltraTemplateAssets

struct MainView: View {
    let model: MainViewModel

    // MARK: - View

    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack {

            }
            .background(Color.Assets.background)
            .navigationTitle(String.Main.title)
        }
    }

    // MARK: - Private

    @State private var navigationManager = NavigationManager()
}

// MARK: - Preview

#Preview {
    MainView(model: .preview)
}
