//
//  ScreenChangeObserver.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 28/09/2023.
//

import Foundation

import UIKit

class ScreenChangeObserver {
    private var currentViewController: UIViewController?

    func startObserving() {
        if let window = UIApplication.shared.keyWindow {
            currentViewController = window.rootViewController
            observeViewControllerChanges()
        }
    }

    private func observeViewControllerChanges() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.checkForScreenChange()
        }
    }

    private func checkForScreenChange() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }

        let newViewController = window.topMostViewController()

        if newViewController !== currentViewController {
            // Screen has changed
            currentViewController = newViewController
            screenChanged(to: newViewController)
        }
    }

    private func screenChanged(to viewController: UIViewController?) {
        // Do something when the screen changes
//        print("Screen changed to: \(viewController?.description ?? "Unknown Screen")")
        Airflex.setCurrentScreen(viewController?.description ?? "Unknown Screen")
    }
}

extension UIWindow {
    func topMostViewController() -> UIViewController? {
        var topController = rootViewController

        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }

        return topController
    }
}
