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
    private static var lastCheckHeartBeatTime: Date? // last beat time
    private static var beatInterval: TimeInterval = 30 // sync every 5 seconds
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
        Logger.log("tracking event: \(name)")
        checkAuth()
        if(SessionManager.disableTracking) {
            return
        }
        var realtime = false
        if let _data = data, let afRealtime = _data["afRealtime"] {
            if afRealtime is Bool && afRealtime as! Bool == true {
                realtime = true
            } else if afRealtime is String && (afRealtime as! String).lowercased() == "true" {
                realtime = true
            }
        }
        var _data: [String: Any] = [:]
        if data != nil {
//            _data += data ?? [:]
            _data.merged(with: data ?? [:])
        }
        if let userId = StorageHelper.shared.getValue(forKey: "LinkID_MMP_UserID") as String?, userId != "" {
            _data["lid_mmp_user_id"] = userId
        }
        let event = EventData.makeEvent(key: name, sessionId: authData?.data?.sessionId ?? "", realtime: realtime, data: _data)
        DatabaseHelper.shared.addEvent(event: event)
        
        if(realtime) {
            syncRealtime(event)
        }
        
        eventTotalCounter += 1
        checkTimer()

        // check if it's time to sync
        if eventTotalCounter >= syncEventCount {
            Logger.log("eventTotalCounter >= syncEventCount")
            sync()
        }
    }
    
    class func getTotalCount() -> Int {
        return eventTotalCounter
    }
    
    private class func syncRealtime(_ eventData: EventData) {
        if(SessionManager.disableTracking) {
            return
        }
        var _data: [EventData] = []
        _data.append(eventData)
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
                        Logger.log("----- sync successful -----")
                        DatabaseHelper.shared.removeEvents(events: _data)
                    } else {
                        Logger.log("----- sync error -----")
                        Logger.log(result.responseText)
                    }
                } catch {
                    Logger.log("----- sync error -----")
                    Logger.log(error)
                }
            } else {
                Logger.log("----- sync error -----")
                Logger.log(_error ?? "Error from request")
            }
        }
    }

    private class func sync() {
        if(SessionManager.disableTracking) {
            return
        }
        // send the queued events to the server
        // you can use a library like Alamofire to make the HTTP request
        // alternatively, you can use a third-party service like Mixpanel or Amplitude to track the events
        if(isSyncing==true) {
            return
        }
        let events = DatabaseHelper.shared.getEvents(limit: 50)
        lastSyncTime = Date()
        isSyncing = true
        Logger.log("----- syncing: \(events?.count ?? 0) events -----")
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
                        Logger.log("----- sync successful -----")
                        DatabaseHelper.shared.removeEvents(events: _data)
                    } else {
                        Logger.log("----- sync error -----")
                        Logger.log(result.responseText)
                    }
                } catch {
                    Logger.log("----- sync error -----")
                    Logger.log(error)
                }
            } else {
                Logger.log("----- sync error -----")
                Logger.log(_error ?? "Error from request")
            }
            checkTimer()
        }
    }
    
    private class func heartBeat() {
        if(SessionManager.disableTracking) {
            return
        }
        if lastCheckHeartBeatTime != nil {
            if Date().timeIntervalSince(lastCheckHeartBeatTime!) >= beatInterval {
                lastCheckHeartBeatTime = Date()
                HttpClient.shared.post(with: "/partner/online-user/log", params: [:]) { data, _error in
                    if let data = data {
                        do {
                            let result = try JSONDecoder().decode(HeartBeatResultData.self, from: data)
                            let dataStr = String(data: data, encoding: .utf8)
                            if result.responseCode == 200 {
                                Logger.log("Airflex ping.......")
                                beatInterval = TimeInterval(result.data?.second ?? 30)
                            } else {
                                Logger.log(result.responseText)
                            }
                        } catch {
                            Logger.log(error)
                        }
                    } else {
                        Logger.log(_error ?? "Error from request")
                    }
                }
            }
        }
    }
    
    private class func checkTimer() {
        if syncTimer == nil {
            startSyncTimer()
        }
    }

    private class func startSyncTimer() {
        if(SessionManager.disableTracking) {
            return
        }
        lastSyncTime = Date()
        lastCheckHeartBeatTime = Date()
        Logger.log("startSyncTimer")
        DispatchQueue.main.async {
            syncTimer = Timer.scheduledTimer(withTimeInterval: syncInterval, repeats: true) { _ in
                if lastSyncTime != nil {
                    if Date().timeIntervalSince(lastSyncTime!) >= syncInterval {
                        Logger.log("time to sync")
                        sync()
                    }
                }
                heartBeat()
            }
        }
    }
    
    public class func stopSyncTimer() { 
        syncTimer?.invalidate()
        syncTimer = nil
    }
}
