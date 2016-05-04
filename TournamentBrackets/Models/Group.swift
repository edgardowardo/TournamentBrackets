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
    dynamic var name = ""
    dynamic var isHandicap = false
    dynamic var scheduleType = 0
    dynamic var teamCount = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var schedule : ScheduleType {
        get {
            return ScheduleType(rawValue:  scheduleType)!
        }
    }
}