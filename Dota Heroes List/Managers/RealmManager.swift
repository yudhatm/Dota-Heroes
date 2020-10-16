//
//  RealmManager.swift
//  Dota Heroes List
//
//  Created by Yudha on 16/10/20.
//  Copyright © 2020 Yudha. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let instance = RealmManager()
    
    var realm = try? Realm()
    
    public func setDefaultRealm() {
        var config = Realm.Configuration()
        
        config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent("DotaHeroes.realm")
        config.deleteRealmIfMigrationNeeded = true
        
        Realm.Configuration.defaultConfiguration = config
        
        realm = try! Realm()
        
        print("Realm file path: \(config.fileURL)")
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("DotaHeroes.realm") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE")
            } else {
                print("FILE NOT AVAILABLE")
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
    }
    
    public func migration() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config

        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        let realm = try! Realm()
    }
    
    // delete database from local storage
    func deleteDatabase() {
        let realm = try? Realm()
        
        try! realm?.write({
            realm?.deleteAll()
        })
    }
    
    // delete particular object
    func deleteObject(objs : Object) {
        let realm = try? Realm()
        
        try? realm!.write ({
            realm?.delete(objs)
        })
    }
    
    //Save array of objects to database
    func saveObjects<T>(objs: [T]) where T : Object {
        try? realm!.write {
            for item in objs {
                // If update = false, adds the object
                realm?.add(item, update: .all)
            }
        }
    }
    
    func saveObject<T>(obj: T) where T: Object {
        try? realm!.write {
            realm?.add(obj, update: .all)
        }
    }
    
    func addObject<T>(obj: T, errorHandling: (NSError?)->Void) where T: Object {
        let realm = try? Realm()
        
        do {
            try realm?.write {
                realm?.add(obj)
            }
        }
        catch let error as NSError {
            print("Realm add error: \(error.localizedDescription)")
            errorHandling(error)
        }
    }
    
    // editing the object
    func editObjects(objs: Object) {
        try? realm!.write ({
            // If update = true, objects that are already in the Realm will be
            // updated instead of added a new.
            realm?.add(objs, update: .all)
        })
    }
    
    //Returs an array as Results<object>?
    func getObjects<T>(type: T.Type) -> Results<T>? where T : Object {
        let realm = try! Realm()
        
        return realm.objects(type)
    }
}
