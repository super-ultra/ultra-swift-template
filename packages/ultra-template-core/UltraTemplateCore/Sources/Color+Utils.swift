import SwiftUI

extension Color {

    public init(hexRGB: String) {
        var str = hexRGB.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if str.hasPrefix("#") { str.removeFirst() }

        guard str.count == 6 else {
            assertionFailure()
            self.init(.clear)
            return
        }

        var rgb: UInt64 = 0
        Scanner(string: str).scanHexInt64(&rgb)

        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            opacity: 1.0
        )
    }
}
