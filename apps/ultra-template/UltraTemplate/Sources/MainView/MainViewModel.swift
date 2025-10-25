import Foundation

protocol MainViewModel {
}

final class DefaultMainViewModel: MainViewModel {
    init() {
    }
}

// MARK: - Preview

extension MainViewModel where Self == DefaultMainViewModel {
    static var preview: DefaultMainViewModel {
        DefaultMainViewModel()
    }
}
