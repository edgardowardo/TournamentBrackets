//
//  Group.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 29/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RealmSwift

enum ScheduleType : Int {
    case RoundRobin = 0
    case RoundRobinDoubles
    case SingleElimination
    case DoubleElimination
}

class Group : Object {
    dynamic var name = ""
    dynamic var isHandicap = false
    dynamic var scheduleType = 0
    dynamic var teamCount = 0
    
    var schedule : ScheduleType {
        get {
            return ScheduleType(rawValue:  scheduleType)!
        }
    }
}