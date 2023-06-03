//
//  UIColorExtension.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 1.03.23.
//

import UIKit.UIColor

extension UIColor{
    convenience init?(hex: String) {
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

            var rgb: UInt64 = 0

            var r: CGFloat = 0.0
            var g: CGFloat = 0.0
            var b: CGFloat = 0.0
            var a: CGFloat = 1.0

            let length = hexSanitized.count

            guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

            if length == 6 {
                r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
                g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
                b = CGFloat(rgb & 0x0000FF) / 255.0

            } else if length == 8 {
                r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
                g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
                b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
                a = CGFloat(rgb & 0x000000FF) / 255.0

            } else {
                return nil
            }

            self.init(red: r, green: g, blue: b, alpha: a)
        }
    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            if getRed(&r, green: &g, blue: &b, alpha: &a) {
                return (r,g,b,a)
            }
            return (0, 0, 0, 0)
        }

        // hue, saturation, brightness and alpha components from UIColor**
        var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
            var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
            if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
                return (hue, saturation, brightness, alpha)
            }
            return (0,0,0,0)
        }

        var htmlRGB: String {
            return String(format: "#%02x%02x%02x", Int(rgba.red * 255), Int(rgba.green * 255), Int(rgba.blue * 255))
        }

        var htmlRGBA: String {
            return String(format: "#%02x%02x%02x%02x", Int(rgba.red * 255), Int(rgba.green * 255), Int(rgba.blue * 255), Int(rgba.alpha * 255) )
        }
}
