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
    private static var eventQueue: [EventData] = [] // queue to store events that are waiting to be synced
    private static var syncTimer: Timer? // timer to schedule syncs at regular intervals
    private static let semaphore = DispatchSemaphore(value: 1) // semaphore to limit the number of concurrent syncs
    private static var lastSyncTime: Date? // last event time
    private static var eventTotalCounter = 0;
    private static var isSyncing = false;
    
//    private static var db: Connection?
    private static var authData: AuthData?
    
//    class func initDb() {
//        do {
//            if(TrackingEvent.db==nil) {
//                let path = NSSearchPathForDirectoriesInDomains(
//                    .documentDirectory, .userDomainMask, true
//                ).first!
//                TrackingEvent.db = try Connection("\(path)/linkid_mmp.sqlite3")
//                let events = Table("events")
//                let name = Expression<String>("name")
//                let data = Expression<String>("data")
//                
//                try! db?.run(events.create(ifNotExists: true) { t in
//                    t.column(name)
//                    t.column(data)
//                })
//            }
//        } catch {
//            // handle the error
//            print("Error reading file: \(error.localizedDescription)")
//        }
//    }
    
    class func checkAuth() {
        authData = StorageHelper.shared.getAuthData()
        if(authData==nil) {
            SessionManager.retry()
        }
    }

    class func trackEvent(name: String, data: [String: Any]?) {
        print("tracking event: \(name)")
//        initDb()
        checkAuth()
        eventQueue.append(EventData.makeEvent(key: name, sessionId: authData?.data?.sessionId ?? "", realtime: false, data: data))
        eventTotalCounter += 1

        checkTimer()

        // check if it's time to sync
        if eventQueue.count >= syncEventCount {
            print("eventQueue.count >= syncEventCount")
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
        lastSyncTime = Date()
        isSyncing = true
        print("----- syncing -----")
        
        var _data: [EventData] = []
        if eventQueue.count > syncEventCount {
            _data += eventQueue.prefix(syncEventCount)
            eventQueue = eventQueue.suffix(eventQueue.count-syncEventCount)
        } else {
            _data += eventQueue
            eventQueue.removeAll()
        }
        
        HttpClient.shared.post(with: "/partner/event/log", params: ["events": EventData.convertToArray(_data)]) { data, _error in
            isSyncing = false
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(ResultData.self, from: data)
                    if result.responseCode == 200 {
                        print("----- sync successful -----")
                    } else {
                        print("----- sync error -----")
                        print(result.responseText)
                        eventQueue += _data
                    }
                } catch {
                    print("----- sync error -----")
                    eventQueue += _data
                    print(error)
                }
            } else {
                print("----- sync error -----")
                print(_error)
                eventQueue += _data
            }
            if eventQueue.count > 0 {
                checkTimer()
            }
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
                    if Date().timeIntervalSince(lastSyncTime!) >= syncInterval && eventQueue.count>0 {
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
