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
                Logger.log(touch.location(in: self))
                Logger.log("Touch Began")
            case .moved:
                Logger.log("Touch Move")
            case .ended:
                Logger.log("Touch End")
            case .cancelled:
                Logger.log("Touch Cancelled")
            default:
                break
            }
        }
        super.sendEvent(event)
    }
}
