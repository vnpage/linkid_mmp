//
//  TrackingEvent.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 03/01/2023.
//

import Foundation
//import SQLite

class TrackingEvent {
    private static let syncInterval: TimeInterval = 5 // sync every 5 seconds
    private static let syncEventCount = 10 // sync after every 10 events
//    private static var eventQueue: [EventData] = [] // queue to store events that are waiting to be synced
    private static var syncTimer: Timer? // timer to schedule syncs at regular intervals
    private static let semaphore = DispatchSemaphore(value: 1) // semaphore to limit the number of concurrent syncs
    private static var lastSyncTime: Date? // last event time
    private static var eventTotalCounter = 0;
    private static var isSyncing = false;
    
    private static var authData: AuthData?
    
    class func checkAuth() {
        authData = StorageHelper.shared.getAuthData()
        if(authData==nil) {
            SessionManager.retry()
        }
    }

    class func trackEvent(name: String, data: [String: Any]?) {
        print("tracking event: \(name)")
        checkAuth()
        let event = EventData.makeEvent(key: name, sessionId: authData?.data?.sessionId ?? "", realtime: false, data: data)
        DatabaseHelper.shared.addEvent(event: event)
        eventTotalCounter += 1
        checkTimer()

        // check if it's time to sync
        if eventTotalCounter >= syncEventCount {
            print("eventTotalCounter >= syncEventCount")
            sync()
        }
    }
    
    class func getTotalCount() -> Int {
        return eventTotalCounter
    }

    private class func sync() {
        // send the queued events to the server
        // you can use a library like Alamofire to make the HTTP request
        // alternatively, you can use a third-party service like Mixpanel or Amplitude to track the events
        if(isSyncing==true) {
            return
        }
        let events = DatabaseHelper.shared.getEvents(limit: 50)
        lastSyncTime = Date()
        isSyncing = true
        print("----- syncing: \(events?.count ?? 0) events -----")
        eventTotalCounter = 0
        var _data: [EventData] = []
        _data.append(contentsOf: events ?? [])
        if _data.isEmpty {
            isSyncing = false
            return
        }
        HttpClient.shared.post(with: "/partner/event/log", params: ["events": EventData.convertToArray(_data)]) { data, _error in
            isSyncing = false
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(ResultData.self, from: data)
                    if result.responseCode == 200 {
                        print("----- sync successful -----")
                        DatabaseHelper.shared.removeEvents(events: _data)
                    } else {
                        print("----- sync error -----")
                        print(result.responseText)
                    }
                } catch {
                    print("----- sync error -----")
                    print(error)
                }
            } else {
                print("----- sync error -----")
                print(_error ?? "Error from request")
            }
            checkTimer()
        }
    }
    
    private class func checkTimer() {
        if syncTimer == nil {
            startSyncTimer()
        }
    }

    private class func startSyncTimer() {
        lastSyncTime = Date()
        print("startSyncTimer")
        DispatchQueue.main.async {
            syncTimer = Timer.scheduledTimer(withTimeInterval: syncInterval, repeats: true) { _ in
                if lastSyncTime != nil {
                    if Date().timeIntervalSince(lastSyncTime!) >= syncInterval {
                        print("time to sync")
                        sync()
                    }
                }
            }
        }
    }
    
    private class func stopSyncTimer() { 
        syncTimer?.invalidate()
        syncTimer = nil
    }
}
