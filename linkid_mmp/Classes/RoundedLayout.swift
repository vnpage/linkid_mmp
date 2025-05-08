//
//  RoundedLayout.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 18/4/25.
//

import UIKit

class RoundedLayout: UIView {
    private var cornerRadius: CGFloat = 0.0
    private let clipPath = UIBezierPath()

    // Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // Setter for corner radius
    func setCornerRadius(_ radius: CGFloat) {
        self.cornerRadius = radius
        setNeedsDisplay() // Redraw the view
    }

    // Setup method
    private func setup() {
        layer.masksToBounds = true
    }

    // Override draw to clip the view with rounded corners
    override func draw(_ rect: CGRect) {
        let clipPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.addPath(clipPath.cgPath)
        context.clip()
        super.draw(rect)
    }
}
