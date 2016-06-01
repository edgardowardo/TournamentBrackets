//
//  AppObject.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 01/06/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RealmSwift

class AppObject : Object {
    dynamic var id = NSUUID().UUIDString
    dynamic var _isAdsShown = true
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var sharedInstance = AppObject.loadAppData()
    
    var isAdsShown : Bool {
        get {
            if let _ = self.realm, app = realm!.objects(AppObject).first {
                return app._isAdsShown
            }
            return true
        }
        set {
            if let _ = self.realm {
                try! realm!.write {
                    if let app = AppObject.sharedInstance {
                        app._isAdsShown = newValue
                        realm!.add(app, update: true)
                    }
                }
            }
        }
    }
    
    static func loadAppData(let realmIn : Realm! = nil) -> AppObject? {
        var a : AppObject? = nil
        
        var realm : Realm!
        
        if realmIn == nil {
            realm = try? Realm()
        }
        
        // If not existing, create it, else query the existing one
        if realm.objects(AppObject).count == 0 {
            try! realm.write {
                let app = AppObject()
                realm.add(app)
                a = app
            }
        } else {
            a = realm.objects(AppObject).first
        }
        
        return a
    }
    
}