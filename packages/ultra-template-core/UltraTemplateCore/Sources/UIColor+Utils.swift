import UIKit

extension UIColor {
    public convenience init?(hexRGB: String) {
        var str = hexRGB.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if str.hasPrefix("#") { str.removeFirst() }

        guard str.count == 6 else { return nil }

        var rgb: UInt64 = 0
        Scanner(string: str).scanHexInt64(&rgb)

        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }

    public var hexRGB: String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(
            format: "#%02X%02X%02X",
            Int(r * 255),
            Int(g * 255),
            Int(b * 255)
        )
    }
}
