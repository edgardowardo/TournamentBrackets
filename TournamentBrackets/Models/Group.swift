//
//  Group.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 29/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RealmSwift

class Group : Object {
    dynamic var id = NSUUID().UUIDString
    dynamic var time: NSTimeInterval = NSDate().timeIntervalSinceReferenceDate
    dynamic var name = ""
    dynamic var scheduleType = 0
    dynamic var teamCount = 4 // TODO: REMOVE THIS LATER! Since it only serves as default of teams.count 
    dynamic var isHandicap = false
    var teams = List<Team>()
    var games = List<Game>()

    override static func ignoredProperties() -> [String] {
        return ["schedule"]
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var schedule : ScheduleType {
        get {
            return ScheduleType(rawValue:  scheduleType)!
        }
        set {
            self.scheduleType = newValue.rawValue
        }
    }
}