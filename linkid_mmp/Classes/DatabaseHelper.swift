//
//  DatabaseHelper.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 23/05/2023.
//

import UIKit
//@_implementationOnly import GRDB

class DatabaseHelper {
    static let shared = DatabaseHelper()
    var dbQueue: DatabaseQueue?
    
    init() {
        initDb()
        createTable()
    }
    
    func initDb() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!
            dbQueue = try DatabaseQueue(path: "\(path)/linkid_mmp_2.sqlite3")
        } catch {
        }
    }
    
    func createTable() {
        do {
            try dbQueue?.write { db in
                try db.create(table: "EventData") { t in
                    t.primaryKey(["id"])
                    t.column("id", .text).notNull()
                    t.column("key", .text).notNull()
                    t.column("time", .integer).notNull()
                    t.column("sessionId", .text).notNull()
                    t.column("realtime", .boolean).notNull()
                    t.column("data", .text).notNull()
                    t.column("appId", .text).notNull()
                    t.column("preEvent", .text).notNull()
                }
            }
        } catch {
//            print("\(error)")
        }
    }
    
    // MARK: - Add Record
    
    func addEvent(event: EventData) {
        if (checkExistsByKeyAndTime(key: event.key, time: event.time)) {
            return
        }
        do {
            try dbQueue?.write { db in
                try event.insert(db)
            }
        } catch {
            Logger.log("\(error)")
        }
    }
    
    func checkExistsByKeyAndTime(key: String, time: Int) -> Bool {
        do {
            let result: [EventData]? = try dbQueue?.read { db in
                try EventData.order(Column("time").asc)
                    .limit(1)
                    .fetchAll(db)
            }
            if (result != nil && (result?.count ?? 0) > 0) {
                return true
            }
        } catch {}
        return false
    }
    
    // MARK: - Get Records
    
    func getEvents(limit: Int) -> [EventData]? {
        do {
            if let appId = DeviceInfo.getAppId() as String?, appId != "" {
                let result: [EventData]? = try dbQueue?.read { db in
                    try EventData.filter(Column("appId") == appId)
                        .order(Column("time").asc)
                        .limit(limit > 0 ? limit : 10)
                        .fetchAll(db)
                }
                return result
            } else {
                let result: [EventData]? = try dbQueue?.read { db in
                    try EventData.order(Column("time").asc)
                        .limit(limit > 0 ? limit : 10)
                        .fetchAll(db)
                }
                return result
            }
        } catch {
            
        }
        return nil
    }
    
    // MARK: - Remove Record
    func removeEvents(events: [EventData]) {
        var ids: [String] = []
        events.forEach { event in
            ids.append(event.id)
        }
        do {
            _ = try dbQueue?.write { db in
                try EventData.deleteAll(db, keys: ids)
            }
        } catch {
            Logger.log("Error removing records: \(error)")
        }
    }
}
