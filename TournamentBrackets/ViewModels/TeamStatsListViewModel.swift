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
        
        statsList.value = group.teams.map{ (team) -> TeamStats in
            let countPlayed = group.games.filter("leftTeam.seed == %@ || rightTeam.seed == %@", team.seed, team.seed).count
            let countWins = group.games.filter("winner.seed == %@", team.seed).count
            let countLost = group.games.filter("leftTeam.seed == %@ || rightTeam.seed == %@", team.seed, team.seed).filter("winner != nil").count
            
            return TeamStats(oldseed: team.seed, seed: 0, name: team.name, countPlayed: countPlayed, countWins: countWins, countLost: countLost, pointsFor: 0.0, pointsAgainst: 0.0, pointsDifference: 0.0)
        }
    }
}