//
//  SafeViewStyleApplier.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 18/4/25.
//

import UIKit

class SafeViewStyleApplier {

    static func applyTextStyles(to label: UILabel, styles: [String: String]) {
        for (key, value) in styles {
            print("Text style: \(key) = \(value)")

            switch key {
            case "color":
                if let color = UIColor(hex: value) {
                    label.textColor = color
                } else {
                    print("Invalid color: \(value)")
                }
            case "font-size":
                if value.hasSuffix("px"), let size = Float(value.replacingOccurrences(of: "px", with: "").trimmingCharacters(in: .whitespaces)) {
                    label.font = label.font.withSize(CGFloat(size))
                } else {
                    print("Invalid font-size: \(value)")
                }
            case "text-align":
                switch value {
                case "center":
                    label.textAlignment = .center
                case "right":
                    label.textAlignment = .right
                default:
                    label.textAlignment = .left
                }
            case "font-weight":
                if value == "bold" || value == "600" {
                    label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
                }
            case "text-decoration":
                if value == "line-through" {
                    let attributes: [NSAttributedString.Key: Any] = [
                        .strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue
                    ]
                    label.attributedText = NSAttributedString(string: label.text ?? "", attributes: attributes)
                }
            case "max-lines":
                if let lines = Int(value), lines > 0 {
                    label.numberOfLines = lines
                }
            case "text-overflow":
                if value == "ellipsis" {
                    label.lineBreakMode = .byTruncatingTail
                }
            default:
                break
            }
        }
    }

    static func applyLayoutStyles(to view: UIView, styles: [String: String], context: LayoutContext? = nil) -> LayoutContext {
        var width: CGFloat = UIViewNoIntrinsicMetric
        var height: CGFloat = UIViewNoIntrinsicMetric
        var weight: CGFloat = 0

        print("Applying layout styles: \(styles)")

        if let widthVal = styles["width"]?.trimmingCharacters(in: .whitespaces) {
            if widthVal.contains("calc"), let parentWidth = context?.parentWidthPx {
                width = CGFloat(parseCalc(calcExpression: widthVal, parentWidthPx: Int(parentWidth)))
            } else if widthVal == "100%", let parentWidth = context?.parentWidthPx {
                width = CGFloat(parentWidth)
            } else if widthVal.hasSuffix("%"), let percent = Float(widthVal.replacingOccurrences(of: "%", with: "")) {
                width = CGFloat(context?.parentWidthPx ?? 0 * Int(CGFloat(percent / 100)))
            } else if let pxValue = parsePx(value: widthVal) {
                width = CGFloat(pxValue)
            }
        }

        if let heightVal = styles["height"]?.trimmingCharacters(in: .whitespaces) {
            if heightVal == "100%", let parentHeight = context?.parentHeightPx {
                height = CGFloat(parentHeight)
            } else if let pxValue = parsePx(value: heightVal) {
                height = CGFloat(pxValue)
            }
        }

        if let margin = styles["margin"], let marginValue = parsePx(value: margin) {
            view.layoutMargins = UIEdgeInsets(top: CGFloat(marginValue), left: CGFloat(marginValue), bottom: CGFloat(marginValue), right: CGFloat(marginValue))
        }

        if let padding = styles["padding"], let paddingValue = parsePx(value: padding) {
            view.layer.masksToBounds = true
            view.layer.cornerRadius = CGFloat(paddingValue)
        }

        if let backgroundColor = styles["background-color"], let color = UIColor(hex: backgroundColor) {
            view.backgroundColor = color
        }

        if let borderRadius = styles["border-radius"], let radius = parsePx(value: borderRadius) {
            view.layer.cornerRadius = CGFloat(radius)
            view.layer.masksToBounds = true
        }

        if let imageView = view as? UIImageView, let objectFit = styles["object-fit"] {
            switch objectFit {
            case "contain":
                imageView.contentMode = .scaleAspectFit
            case "cover":
                imageView.contentMode = .scaleAspectFill
            default:
                break
            }
        }

        return LayoutContext(isParentHorizontal: false, parentWeight: Float(weight), parentWidthPx: Int(width), parentHeightPx: Int(height))
    }

    private static func parseCalc(calcExpression: String, parentWidthPx: Int) -> Int {
        let expression = calcExpression.replacingOccurrences(of: "calc(", with: "").replacingOccurrences(of: ")", with: "").trimmingCharacters(in: .whitespaces)
        let parts = expression.split(separator: "-").map { $0.trimmingCharacters(in: .whitespaces) }

        guard parts.count == 2 else { return 0 }

        let percentPart = parts[0]
        let pxPart = parts[1]

        let percent = percentPart.hasSuffix("%") ? Float(percentPart.replacingOccurrences(of: "%", with: "")) ?? 0 : 0
        let px = pxPart.hasSuffix("px") ? Int(pxPart.replacingOccurrences(of: "px", with: "")) ?? 0 : 0

        return Int(CGFloat(parentWidthPx) * CGFloat(percent / 100)) - px
    }

    private static func parsePx(value: String) -> Int? {
        let trimmedValue = value.trimmingCharacters(in: .whitespaces)
        if trimmedValue.hasSuffix("px") {
            return Int(trimmedValue.replacingOccurrences(of: "px", with: ""))
        }
        return Int(trimmedValue)
    }
}

// Helper to convert hex color strings to UIColor
extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
