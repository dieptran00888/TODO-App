//
//  SqliteManager.swift
//  TO-DO-APP
//
//  Created by ha.van.duc on 8/17/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import SQLite

class SqliteManager {
    static let shared = SqliteManager()
    var db: Connection?
    var destinationFileDbPath = ""

    private init() {
        let documentPath = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true).first!
        self.destinationFileDbPath = "\(documentPath)/db.sqlite3"
        if copyDatabaseIfNeeded() {
            connectDatabase()
        }
    }

    func copyDatabaseIfNeeded () -> Bool {
        var result = false
        let fileManager = FileManager.default
        let sourceFileDbPath = Bundle.main.path(forResource: "db", ofType: "sqlite3")

        if !fileManager.fileExists(atPath: destinationFileDbPath) {
            do {
                if let sourcePath = sourceFileDbPath {
                    try fileManager.copyItem(atPath: sourcePath, toPath: destinationFileDbPath)
                    result = true
                }
            }
            catch {
                result = false
            }
        } else {
            result = true
        }
        return result
    }

    func connectDatabase() {
        do {
            db = try Connection(self.destinationFileDbPath)
        } catch let  error as NSError {
            print("Error connect database: \(error)")
        }
    }

    func getDataWithQuery (query: String) -> [[String: Any]] {
        var dataList = [[String : Any]]()
        guard let db = self.db else {return []}
        do {
            let data = try db.prepare(query)
            for row in data {
                var dictionary = [String:Any]()
                for (index, name) in data.columnNames.enumerated() {
                    dictionary[name] = row[index]
                }
                dataList.append(dictionary)
            }
        } catch {
            return []
        }
        return dataList
    }

    func insertData (query: String) -> Bool {
        guard let db = self.db else {return false}
        do {
            _ = try db.run(query)
            if db.changes >= 1 {
                return true
            } else {
                return false
            }
        } catch let error as NSError {
            print("Oops. Error: \(error)")
            return false
        }
    }
}
