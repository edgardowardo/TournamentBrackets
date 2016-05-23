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
            let countPlayed = group.games
                .filter("winner != nil")
                .filter("leftTeam.seed == %@ || rightTeam.seed == %@ || doubles.leftTeam2.seed == %@ || doubles.rightTeam2.seed == %@", team.seed, team.seed, team.seed, team.seed)
                .count
            let countGames = group.games
                .filter("leftTeam.seed == %@ || rightTeam.seed == %@ || doubles.leftTeam2.seed == %@ || doubles.rightTeam2.seed == %@", team.seed, team.seed, team.seed, team.seed)
                .count
            let countWins = group.games
                .filter { (game) in game.winner?.seed == team.seed || game.winner2?.seed == team.seed }
                .count
            let countLost = group.games
                .filter("leftTeam.seed == %@ || rightTeam.seed == %@ || doubles.leftTeam2.seed == %@ || doubles.rightTeam2.seed == %@", team.seed, team.seed, team.seed, team.seed)
                .filter { (game) in game.winner != nil && !(game.winner?.seed == team.seed || game.winner2?.seed == team.seed) }
                .count
            
            return TeamStats(oldseed: team.seed, seed: 0, name: team.name, countPlayed: countPlayed, countGames: countGames, countWins: countWins, countLost: countLost, pointsFor: 0.0, pointsAgainst: 0.0, pointsDifference: 0.0)
        }
        unindexed.sortInPlace{ (g1, g2) in g1.countWins > g2.countWins }
        var indexed = [TeamStats]()
        for (i, e) in unindexed.enumerate() {
            indexed.append(TeamStats(oldseed: e.oldseed, seed: i+1, name: e.name, countPlayed: e.countPlayed, countGames: e.countGames, countWins: e.countWins, countLost: e.countLost, pointsFor: e.pointsFor, pointsAgainst: e.pointsAgainst, pointsDifference: e.pointsDifference))
        }
        
        statsList.value = indexed
    }
}

extension Game {
    var winner2: Team? {
        get {
            if let winner1 = winner {
                if let d = doubles {
                    if let left = leftTeam where  winner1.seed == left.seed {
                        return d.leftTeam2
                        
                    } else if let right = rightTeam where winner1.seed == right.seed {
                        return d.rightTeam2
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
    }
}
