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

    func countTasksAllGroup () -> [Group] {
        var result: [Group] = []
        guard let db = self.db else {return []}
        do {
            let rows = try db.prepare("SELECT groups.id, groups.name as group_name, count(tasks.id) as number_tasks, groups.image FROM groups LEFT JOIN tasks ON groups.id == tasks.group_id GROUP BY groups.name ORDER BY groups.name DESC")
            for row in rows {
                if let rowFirst = row[0], let rowSecond = row[1], let rowThird = row[2], let image = row[3] {
                    if let groupId = rowFirst as? Int64,
                        let nameGroups = rowSecond as? String,
                        let numberTasks = rowThird as? Int64,
                        let imageGroup = image as? String {
                        let group = Group(groupId: Int(groupId), name: nameGroups, numberTask: Int(numberTasks), image: imageGroup)
                        result.append(group)
                    }
                }
            }
        } catch {
            return []
        }
        return result
    }

    func getTodayTasks () -> [[String : Any]] {
        var listTask = [[String : Any]]()
        guard let db = self.db else {return []}
        do {
            let currentDay = CommonUtility.formatToString(Date())
            let tasks = try db.prepare("SELECT * FROM tasks WHERE tasks.selectedDate = '\(currentDay)'")
            for row in tasks {
                var dictionaryTask = [String:Any]()
                for (index, name) in tasks.columnNames.enumerated() {
                    dictionaryTask[name] = row[index]
                }
                listTask.append(dictionaryTask)
            }
        } catch {
            return []
        }
        return listTask
    }

    func findTaskByGroup(_ groupId:Int) -> [[String : Any]] {

        var listTask = [[String : Any]]()
        guard let db = self.db else {return []}
        do {
            let tasks = try db.prepare("select * from tasks where tasks.group_id = \(groupId)")
            for row in tasks {
                var dictionaryTask = [String:Any]()
                for (index, name) in tasks.columnNames.enumerated() {
                    dictionaryTask[name] = row[index]
                }
                listTask.append(dictionaryTask)
            }
        } catch {
            return []
        }
        return listTask
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
