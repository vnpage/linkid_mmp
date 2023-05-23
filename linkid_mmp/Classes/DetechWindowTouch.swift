//
//  DetechWindowTouch.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 28/02/2023.
//

import Foundation
import UIKit

public class DetectWindowTouch: UIWindow {
    public override func sendEvent(_ event: UIEvent) {
        if let touch = event.allTouches?.first {
            switch touch.phase {
            case .began:
                print(touch.location(in: self))
                print("Touch Began")
            case .moved:
                print("Touch Move")
            case .ended:
                print("Touch End")
            case .cancelled:
                print("Touch Cancelled")
            default:
                break
            }
        }
        super.sendEvent(event)
    }
}
