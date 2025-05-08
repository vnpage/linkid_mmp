//
//  LayoutContext.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 18/4/25.
//

import Foundation

struct LayoutContext: CustomStringConvertible {
    var isRoot: Bool = false
    var isParentHorizontal: Bool = false
    var parentWeight: Float = 0.0
    var parentWidthPx: Int = -1
    var parentHeightPx: Int = -1
    var color: String? = nil
    var fontWeight: String? = nil

    // Additional fields for handling justify-content, gap, index, etc.
    var childIndex: Int = -1
    var siblingCount: Int = -1
    var parentGapPx: Int = 0

    // Clone method
    func clone() -> LayoutContext {
        return LayoutContext(
            isRoot: self.isRoot,
            isParentHorizontal: self.isParentHorizontal,
            parentWeight: self.parentWeight,
            parentWidthPx: self.parentWidthPx,
            parentHeightPx: self.parentHeightPx,
            color: self.color,
            fontWeight: self.fontWeight,
            childIndex: self.childIndex,
            siblingCount: self.siblingCount,
            parentGapPx: self.parentGapPx
        )
    }

    // Description for debugging
    var description: String {
        return """
        LayoutContext {
            isRoot: \(isRoot),
            isParentHorizontal: \(isParentHorizontal),
            parentWeight: \(parentWeight),
            parentWidthPx: \(parentWidthPx),
            parentHeightPx: \(parentHeightPx),
            childIndex: \(childIndex),
            siblingCount: \(siblingCount),
            parentGapPx: \(parentGapPx),
            color: \(color ?? "nil"),
            fontWeight: \(fontWeight ?? "nil")
        }
        """
    }
}
