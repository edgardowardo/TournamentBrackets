//
//  TeamStatsViewModel.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 22/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation

struct TeamStatsViewModel {

    var oldseed : Int
    var seed : String
    var name : String
    var countPlayed : String
    var countWins : String
    var countLost : String
    var pointsFor : String
    var pointsAgainst : String
    var pointsDifference : String
    
    var teamstats : TeamStats!
    
    var seedDirection : String {
        if teamstats.seed < oldseed {
            return "↑"
        } else if teamstats.seed > oldseed {
            return "↓"
        } else {
            return ""
        }
    }
    
    var seedDelta : String {
        let diff = abs(teamstats.seed - oldseed)
        return diff > 0 ? "\(diff)" : ""
    }

    init(teamstats : TeamStats) {
        self.teamstats = teamstats
        
        self.oldseed = teamstats.oldseed
        self.seed = "\(teamstats.seed)"
        self.name = teamstats.name
        self.countPlayed = "\(teamstats.countPlayed)"
        self.countWins = "\(teamstats.countWins)"
        self.countLost = "\(teamstats.countLost)"
        self.pointsFor = "\(Int(teamstats.pointsFor))"
        self.pointsAgainst = "\(Int(teamstats.pointsAgainst))"
        self.pointsDifference = "\(Int(teamstats.pointsDifference))"
    }
    
}
