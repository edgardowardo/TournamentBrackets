//
//  ScheduleType.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 03/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation

enum ScheduleType : Int {
    case RoundRobin = 0
    case RoundDoubles
    case SingleElimination
    case DoubleElimination
    
    var allowedTeamCounts : [Int] {
        get {
            switch self {
            case .RoundDoubles : return (4..<33).filter{ ($0 % 4) != 2 }.map { $0 }
            case .RoundRobin : fallthrough
            case .SingleElimination : fallthrough
            case .DoubleElimination : return (2..<33).map { $0 }
            }
        }
    }

    var iconNameWithText : String {
        get {
            switch self {
            case .RoundRobin : return "icon-round-robin-text"
            case .RoundDoubles : return "icon-american-text"
            case .DoubleElimination : return "icon-double-e-text"
            case .SingleElimination : return "icon-single-e-text"
            }
        }
    }
    
    var iconName : String {
        get {
            switch self {
            case .RoundRobin : return "icon-roundrobin"
            case .RoundDoubles : return "icon-robinpairs"
            case .DoubleElimination : fallthrough
            case .SingleElimination : return "icon-single-e"
                
            }
        }
    }    
    
    var description : String {
        get {
            switch self {
            case .RoundRobin : return "Round Robin"
            case .RoundDoubles : return "American"
            case .SingleElimination : return "Single Elimination"
            case .DoubleElimination : return "Double Elimination"
            }
        }
    }
    
    static func schedules() -> [ScheduleType] {
        return [ .RoundRobin, .RoundDoubles, .SingleElimination, .DoubleElimination ]
    }
}