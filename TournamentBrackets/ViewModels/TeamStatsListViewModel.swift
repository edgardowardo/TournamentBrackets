//
//  TeamStatsListViewModel.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 22/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RxSwift

struct TeamStatsListViewModel {
    
    var statsList: Variable<[TeamStats]> = Variable([])
    var group : Group!
    
    init(group : Group) {
        self.group = group
    }
    
    func loadStatsList() {

        var unindexed = group.teams.map{ (team) -> TeamStats in
            let countPlayed = group.games.filter("leftTeam.seed == %@ || rightTeam.seed == %@", team.seed, team.seed).count
            let countWins = group.games.filter("winner.seed == %@", team.seed).count
            let countLost = group.games.filter("leftTeam.seed == %@ || rightTeam.seed == %@", team.seed, team.seed).filter("winner != nil").count
            
            return TeamStats(oldseed: team.seed, seed: 0, name: team.name, countPlayed: countPlayed, countWins: countWins, countLost: countLost, pointsFor: 0.0, pointsAgainst: 0.0, pointsDifference: 0.0)
        }
        unindexed.sortInPlace{ (g1, g2) in g1.countWins > g2.countWins }
        var indexed = [TeamStats]()
        for (i, e) in unindexed.enumerate() {
            indexed.append(TeamStats(oldseed: e.oldseed, seed: i+1, name: e.name, countPlayed: e.countPlayed, countWins: e.countWins, countLost: e.countLost, pointsFor: e.pointsFor, pointsAgainst: e.pointsAgainst, pointsDifference: e.pointsDifference))
        }
        
        statsList.value = indexed
    }
}