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
    
    var statsList: [TeamStats] = []
    var group : Group!
    var countGames : Int!
    
    init(group : Group) {
        self.group = group
    }
    
    mutating func loadStatsList() {

        var unindexed = group.teams.map{ (team) -> TeamStats in
            let countPlayed = group.games
                .filter("winner != nil || isDraw == 1")
                .filter("leftTeam.seed == %@ || rightTeam.seed == %@ || doubles.leftTeam2.seed == %@ || doubles.rightTeam2.seed == %@", team.seed, team.seed, team.seed, team.seed)
                .count
            self.countGames = group.games
                .filter("leftTeam.seed == %@ || rightTeam.seed == %@ || doubles.leftTeam2.seed == %@ || doubles.rightTeam2.seed == %@", team.seed, team.seed, team.seed, team.seed)
                .count
            let countWins = group.games
                .filter { (game) in game.winner?.seed == team.seed || game.winner2?.seed == team.seed }
                .count
            let countLost = group.games
                .filter("leftTeam.seed == %@ || rightTeam.seed == %@ || doubles.leftTeam2.seed == %@ || doubles.rightTeam2.seed == %@", team.seed, team.seed, team.seed, team.seed)
                .filter { (game) in game.winner != nil && !(game.winner?.seed == team.seed || game.winner2?.seed == team.seed) }
                .count
            let countDraws = group.games
                .filter("leftTeam.seed == %@ || rightTeam.seed == %@ || doubles.leftTeam2.seed == %@ || doubles.rightTeam2.seed == %@", team.seed, team.seed, team.seed, team.seed)
                .filter("isDraw == 1")
                .count
            
            let pointsForLeft = group.games
                .filter("leftTeam.seed == %@ || doubles.leftTeam2.seed == %@", team.seed, team.seed)
                .map { (game) -> Int in game.leftScore }
                .reduce(0, combine: {  $0 + $1 })
            let pointsForRight = group.games
                .filter("rightTeam.seed == %@ || doubles.rightTeam2.seed == %@", team.seed, team.seed)
                .map { (game) -> Int in game.rightScore }
                .reduce(0, combine: {  $0 + $1 })
            let pointsFor = pointsForLeft + pointsForRight
            
            let pointsAgainstLeft = group.games
                .filter("leftTeam.seed == %@ || doubles.leftTeam2.seed == %@", team.seed, team.seed)
                .map { (game) -> Int in game.rightScore }
                .reduce(0, combine: {  $0 + $1 })
            let pointsAgainstRight = group.games
                .filter("rightTeam.seed == %@ || doubles.rightTeam2.seed == %@", team.seed, team.seed)
                .map { (game) -> Int in game.leftScore }
                .reduce(0, combine: {  $0 + $1 })
            let pointsAgainst = pointsAgainstLeft + pointsAgainstRight
            let pointDifference = pointsFor - pointsAgainst
            
            return TeamStats(oldseed: team.seed, seed: 0, name: team.name, handicap: team.handicap, countPlayed: countPlayed, countGames: countGames, countWins: countWins, countDraws:  countDraws, countLost: countLost, pointsFor: pointsFor, pointsAgainst: pointsAgainst, pointsDifference: pointDifference)
        }
        let winfactor = 1000000
        let drawfactor = 500000
        let diff = unindexed.map{ $0.countPlayed }.reduce(0, combine: { $0 + $1 })
        if diff > 0 {
            unindexed.sortInPlace{ (g1, g2) in g1.countWins * winfactor + g1.countDraws * drawfactor + g1.pointsDifference > g2.countWins * winfactor + g2.countDraws * drawfactor + g2.pointsDifference }
        }
        
        var indexed = [TeamStats]()
        for (i, e) in unindexed.enumerate() {
            indexed.append(TeamStats(oldseed: e.oldseed, seed: i+1, name: e.name, handicap: e.handicap, countPlayed: e.countPlayed, countGames: e.countGames, countWins: e.countWins, countDraws: e.countDraws, countLost: e.countLost, pointsFor: e.pointsFor, pointsAgainst: e.pointsAgainst, pointsDifference: e.pointsDifference))
        }
        
        statsList = indexed
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
