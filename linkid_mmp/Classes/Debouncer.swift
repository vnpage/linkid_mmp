//
//  Debouncer.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 24/2/25.
//

import Foundation

class Debouncer {
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue
    private let delay: TimeInterval

    init(delay: TimeInterval, queue: DispatchQueue = .main) {
        self.delay = delay
        self.queue = queue
    }

    func debounce(action: @escaping () -> Void) {
        // Cancel the previous task if it's still pending
        workItem?.cancel()

        // Create a new DispatchWorkItem
        let task = DispatchWorkItem(block: action)
        workItem = task

        // Execute the new task after the delay
        queue.asyncAfter(deadline: .now() + delay, execute: task)
    }
}
