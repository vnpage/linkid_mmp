//
//  DatabaseHelper.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 23/05/2023.
//

import UIKit
@_implementationOnly import GRDB

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
            dbQueue = try DatabaseQueue(path: "\(path)/linkid_mmp.sqlite3")
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
                }
            }
        } catch {
//            print("\(error)")
        }
    }
    
    // MARK: - Add Record
    
    func addEvent(event: EventData) {
        do {
            try dbQueue?.write { db in
                try event.insert(db)
            }
        } catch {
            Logger.log("\(error)")
        }
    }
    
    // MARK: - Get Records
    
    func getEvents(limit: Int) -> [EventData]? {
        do {
            let result: [EventData]? = try dbQueue?.read { db in
                try EventData.order(Column("time").asc)
                    .limit(limit > 0 ? limit : 10)
                    .fetchAll(db)
            }
            return result
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
