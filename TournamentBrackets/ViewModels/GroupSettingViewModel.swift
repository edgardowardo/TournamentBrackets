//
//  GroupSettingViewModel.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 04/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

struct TeamStruct {
    var name = ""
    var handicap = 0
    var seed = 0
}

struct GroupSettingViewModel {

    var realm = try! Realm()
    var name : String
    var scheduleType : Variable<ScheduleType>   = Variable(.RoundRobin)
    var isSorting : Variable<Bool> = Variable(false)
    var isHandicap : Variable<Bool> = Variable(true)
    var teams: Variable<[Team]> = Variable([])
    var teamCount = 2 {
        didSet {
            
            //
            // Don't just delete the old teams. It may contain text inputs. Combine with the new ones if adding.
            //
            var oldTeams = self.teams.value
            
            //
            // add to list
            //
            if oldTeams.count < teamCount {
                let newTeams = (oldTeams.count ..< teamCount).map{ (value) in Team(name: "Team \(value + 1 )", seed: value + 1, isHandicap : self.isHandicap.value) }
                oldTeams = oldTeams + newTeams
            }
            
            //
            // truncate list
            //
            if oldTeams.count > teamCount {
                oldTeams = Array(oldTeams[0..<teamCount])
            }
            self.teams.value = oldTeams
        }
    }
    var group : Group!
    
    mutating func saveWithTournament(tournament : Tournament) {
        group = Group()
        group.name = self.name
        group.schedule = self.scheduleType.value
        group.teamCount = self.teamCount
        group.isHandicap = self.isHandicap.value
        group.teams = List(self.teams.value)
        group.games = List(schedule(group.schedule, withTeams: self.teams.value))
        try! self.realm.write {
            tournament.groups.insert(group, atIndex: 0)
            self.realm.add(tournament, update: true)
        }
    }
    
    func copyTeams(teams: [TeamStats]) {
        let copiedteams = teams.map{ (t) -> Team in
            let team = Team(name: t.name, seed: t.seed, isHandicap: false)
            team.handicap = t.handicap
            return team
        }
        self.teams.value = copiedteams
    }
    
    func setTeamsHandicap(isHandicap : Bool) {
        for t in teams.value {
            t.isHandicapped = isHandicap
        }
    }
    
    func shuffle() {
        self.teams.value.shuffleInPlace()
        for (index, element) in teams.value.enumerate() {
            element.seed = index + 1
        }
    }
    
    func reset() {
        let newTeams = (0 ..< teamCount).map{ (value) in Team(name: "Team \(value + 1 )", seed: value + 1, isHandicap : self.isHandicap.value) }
        self.teams.value = newTeams
    }
    
    func moveElement(fromIndexPath : NSIndexPath, toIndexPath : NSIndexPath) {
        let f = fromIndexPath.row, t = toIndexPath.row
        let element = teams.value[f]
        teams.value.removeAtIndex(f)
        teams.value.insert(element, atIndex: t)
        for (index, element) in teams.value.enumerate() {
            element.seed = index + 1
        }
    }
    
    init(group : Group) {
        self.name = group.name
        self.scheduleType.value = group.schedule
        self.teamCount = group.schedule.allowedTeamCounts.first!
        self.isHandicap.value = group.isHandicap
    }
    
    private func transfrormTeam(team : Team) -> TeamStruct {
        return TeamStruct(name: team.name, handicap: team.handicap, seed: team.seed)
    }
    
    private func getTeam(team : TeamStruct?) -> Team? {
        if let t = team {
            return self.teams.value.filter{ (tee) in tee.name == t.name && tee.seed == t.seed && tee.handicap == t.handicap }.first
        } else {
            return nil
        }
    }
    
    func calculateGameHandicap(game: Game) {
        guard isHandicap.value else { return }
        game.calculateHandicap()
    }
    
    private func schedule(schedule : ScheduleType, withTeams teams: [Team]) -> [Game] {
        let row : [TeamStruct?] = teams.map{ transfrormTeam($0) }
        switch schedule {
        case .RoundRobin:
            let schedules = Scheduler.roundRobin(1, row: row )
            let games : [Game] = schedules.map{ (game) in
                var winner : TeamStruct? = nil
                if let left = game.2 where game.3 == nil {
                    winner = left
                } else if let right = game.3 where game.2 == nil {
                    winner = right
                }
                let game = Game(round: game.0, index: game.1, winner: getTeam(winner), leftTeam: getTeam(game.2), rightTeam: getTeam(game.3), isBye: (winner != nil), doubles: nil, elimination: nil)
                calculateGameHandicap(game)
                return game
            }
            return games
        case .RoundDoubles:
            let schedules = Scheduler.roundRobinDoubles(1, row: row)
            let games : [Game] = schedules.map{ (game) in
                let doubles = Doubles(leftTeam2: getTeam(game.3), rightTeam2: getTeam(game.5))
                let game =  Game(round: game.0, index: game.1, winner: nil, leftTeam: getTeam(game.2), rightTeam: getTeam(game.4), isBye: false, doubles: doubles, elimination: nil)
                calculateGameHandicap(game)
                return game
            }
            return games
        case .SingleElimination:
            let schedules = Scheduler.valuedSingleElimination(1, teams: row)
            var valuedgames = schedules.flatten()
            valuedgames.sortInPlace{ (g1, g2) -> Bool in return g1.index < g2.index }
            let games : [Game] = valuedgames.map{ (game) in
                let e = Elimination(isLoserBracket: game.isLoserBracket, leftGameIndex: game.leftGameIndex, rightGameIndex: game.rightGameIndex)
                let game = Game(round: game.round, index: game.index, winner: getTeam(game.winner), leftTeam: getTeam(game.left), rightTeam: getTeam(game.right), isBye: game.isBye, doubles: nil, elimination: e)
                return game
            }
            setPreviousGames(games)
            return games
        case .DoubleElimination:
            let schedules = Scheduler.valuedDoubleElimination(1, teams: row)
            var valuedgames = schedules.flatten().unique
            valuedgames.sortInPlace{ (g1, g2) -> Bool in return g1.index < g2.index }
            let games : [Game] = valuedgames.map{ (game) in
                let e = Elimination(isLoserBracket: game.isLoserBracket, leftGameIndex: game.leftGameIndex, rightGameIndex: game.rightGameIndex)
                e.firstLoserIndex = game.firstLoserIndex
                let game = Game(round: game.round, index: game.index, winner: getTeam(game.winner), leftTeam: getTeam(game.left), rightTeam: getTeam(game.right), isBye: game.isBye, doubles: nil, elimination: e)
                return game
            }
            setPreviousGames(games)
            return games
        }
    }

    ///
    /// Previous games help build the tree structure and identify the left and right prompts. 
    /// The routine identifies the left and right previous game and advances the previous winners 
    /// in elimination schedules.
    ///
    private func setPreviousGames(games : [Game]) {
        for g in games {
            if let e = g.elimination {
                e.prevLeftGame = games.filter{ (game) in game.index == e.leftGameIndex }.first
                if let leftPrevGame = e.prevLeftGame, leftWinner = leftPrevGame.winner {
                    g.leftTeam = leftWinner
                }
                e.prevRightGame = games.filter{ (game) in game.index == e.rightGameIndex }.first
                if let rightPrevGame = e.prevRightGame, rightWinner = rightPrevGame.winner {
                    g.rightTeam = rightWinner
                }
            }
            calculateGameHandicap(g)
        }
    }
    
}

///
/// Game extensions for saving into data store
///
extension Game {
    func calculateHandicap() {
        guard let left = leftTeam, right = rightTeam else {
            leftScore = 0
            rightScore = 0
            return
        }
        
        var leftHandicap = left.handicap
        var rightHandicap = right.handicap
        
        if let d = doubles {
            if let leftHandicap2 = d.leftTeam2?.handicap {
                leftHandicap = leftHandicap + leftHandicap2
            }
            if let rightHandicap2 = d.rightTeam2?.handicap {
                rightHandicap = rightHandicap + rightHandicap2
            }
        }
        let difference = abs(leftHandicap - rightHandicap)
        if leftHandicap > rightHandicap {
            leftScore = difference / 2
            rightScore = -difference / 2
        } else if leftHandicap < rightHandicap {
            leftScore = -difference / 2
            rightScore = difference / 2
        } else {
            leftScore = 0
            rightScore = 0
        }
        
        return
    }
}

///
/// Game tree extensions for saving into data store
///
extension GameTree {
    
    var leftGameIndex : Int {
        get {
            switch self {
            case .Game(_, _, _) :
                return 0
            case .FutureGame(_, let left, _) :
                return left.index
            }
        }
    }
    
    var left : SomeTeam? {
        get {
            switch self {
            case .Game(_, let left, _) :
                if let l = left {
                    return l
                } else {
                    return nil
                }
            case .FutureGame(_, _, _) :
                return nil
            }
        }
    }
    
    var right : SomeTeam? {
        get {
            switch self {
            case .Game(_, _, let right) :
                if let r = right {
                    return r
                } else {
                    return nil
                }
            case .FutureGame(_, _, _) :
                return nil
            }
        }
    }
    
    var rightGameIndex : Int {
        get {
            switch self {
            case .Game(_, _, _) :
                return 0
            case .FutureGame(_, _, let right) :
                return right.index
            }
        }
    }
    
}



