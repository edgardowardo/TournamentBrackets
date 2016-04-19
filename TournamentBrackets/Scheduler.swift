//
//  Scheduler.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 16/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation

///
/// Scheduler creates sports fixtures from a set of generic elements.
/// - Round Robin
/// - Round Robin Pairs
/// - Single Elimination
/// - Double Elimination
///
class Scheduler {
    
    ///
    /// Builds a round robin schedule from a given set
    ///
    /// - Returns: a list of home versus away pairs in that order. [(round, index, home, away)]
    ///
    static func roundRobin<T>(round : Int, startindex : Int = 1, row : [T?]) -> [(Int, Int, T?,T?)] {
        var index = startindex
        var elements = row
        var schedules = [(Int, Int, T?, T?)]()
        
        //
        // if odd then add a bye
        //
        if elements.count % 2 != 0 {
            elements.append(nil)
        }
        
        //
        // base case
        //
        guard round < elements.count else { return schedules }
        
        //
        // process half the elements to create the pairs
        //
        let endIndex = elements.count - 1
        for i in (0 ..< elements.count / 2).reverse() {
            let home = elements[i]
            let away = elements[endIndex - i]
            let pair = (round, index, home, away)
            index = index + 1
            schedules.append(pair)
        }
        
        //
        // shift the elements to process as the next row. the first element is fixed hence insert to position one.
        //
        var nextrow = elements
        let displaced = nextrow.removeAtIndex(elements.count - 1)
        nextrow.insert(displaced, atIndex: 1)
        
        return schedules + roundRobin(round + 1, startindex: index, row: nextrow)
    }
    
    ///
    /// Builds a round robin paired schedule from a given set
    ///
    /// - Returns: a list of home pairs and away pairs in that order. [(round, index, home1, home2, away1, away2)]
    ///
    static func roundRobinPair<T>(round : Int, startindex : Int = 1, row : [T?]) -> [(Int, Int, T?,T?,T?,T?)] {
        var index = startindex
        var elements = row
        var schedules = [(Int,Int,T?,T?,T?,T?)]()
        
        //
        // if odd then add a bye
        //
        if elements.count % 2 != 0 {
            elements.append(nil)
        }
        
        //
        // base case
        //
        var tophalf = ( elements.count / 2 ) - 1
        guard round < elements.count && row.count > 3  else { return schedules }
        
        //
        // process half the elements to create the pairs
        //
        let endIndex = elements.count - 1
        
        while tophalf > 0 {
            
            let i = tophalf
            
            //
            // home pair
            //
            let home1 = elements[i]
            let home2 = elements[endIndex - i]
            
            //
            // away pair
            //
            let away1 = elements[i - 1]
            let away2 = elements[endIndex - (i - 1)]
            
            guard let _ = home1, _ = home2, _ = away1, _ = away2 else { continue }
            
            let pair = (round, index, home1, home2, away1, away2)
            schedules.append(pair)
            index = index + 1
            
            
            tophalf = tophalf - 2
        }
        
        //
        // shift the elements to process as the next row. the last element is fixed hence, displaced is minus two.
        //
        var nextrow = elements
        let displaced = nextrow.removeAtIndex(elements.count - 2)
        nextrow.insert(displaced, atIndex: 0)
        
        return schedules + roundRobinPair(round + 1, startindex : index, row: nextrow)
    }
    ///
    /// Builds single elimination match schedule from a given set
    ///
    /// - Returns: a list of game matches in single elimination format.
    ///
    static func singleElimination<U>(round : Int, row : [U?]) -> [Game<U>] {
        
        var index = 0
        var elements = row
        var schedules = [Game<U>]()
        
        guard elements.count <= 64 && round < elements.count  else { return schedules }
        
        //
        // Adjust the number of teams necessary to construct the brackets which are 2, 4, 8, 16, 32 and 64
        //
        for i in 1...8 {
            let minimum = 2^^i
            if elements.count < minimum {
                let diff = minimum - elements.count
                for _ in 1...diff {
                    elements.append(nil) // bye
                }
                break
            } else if elements.count == minimum {
                break
            }
        }
        
        //
        // process half the elements to create the pairs
        //
        let endIndex = elements.count - 1
        for i in (0 ..< elements.count / 2).reverse() {
            let home = elements[i]
            let away = elements[endIndex - i]
            let game = Game(index: &index, round: round, home: home, away: away, prevHomeGame: nil, prevAwayGame: nil, isLoserBracket: false)
            schedules.append(game)
        }
        
        //
        // apply rainbow pairing for the new game winners instead of teams
        //
        return schedules + singleElimination(&index, round: round + 1, row: schedules)
    }
    
    ///
    /// Builds single elimination match schedule from a set of match schedules from round 2 and up
    ///
    /// - Returns: a list of game matches in single elimination format.
    ///
    private static func singleElimination<U>(inout index : Int, round : Int, row : [Game<U>]) -> [Game<U>] {
        
        var schedules = [Game<U>]()
        
        guard row.count > 1 else { return schedules}
        
        //
        // process all the game winners to create new games for the round
        //
        let endIndex = row.count - 1
        for i in (0 ..< row.count / 2).reverse() {
            let prevhome = row[i]
            let prevaway = row[endIndex - i]
            let game = Game(index: &index, round: round, home: nil, away: nil, prevHomeGame: prevhome, prevAwayGame: prevaway, isLoserBracket: false)
            schedules.append(game)
        }
        
        //
        // apply rainbow pairing for the new game winners until the base case happens
        //
        return schedules + singleElimination(&index, round: round + 1, row: schedules)
    }

    
    ///
    /// Builds double elimination match schedule from a given set
    ///
    /// - Returns: a list of game matches in double elimination format.
    ///
    static func doubleElimination<U>(round : Int, row : [U?]) -> [Game<U>] {
        
        var elements = row
        var schedules = [Game<U>]()
        
        //
        // If two teams, make it 4 beacause it needs 4 to make the losers bracket
        //
        if elements.count == 2 {
            for _ in 3...4 {
                elements.append(nil)
            }
        }
        
        //
        // Build single elimination tree aka winners bracket
        //
        schedules = singleElimination(1, row: elements)
        
        //
        // Remember the last loser from the last game of the winners bracket
        //
        let lastWinnersGame = schedules.last
        
        //
        // Build losers bracket and accumulate in schedules
        //
        schedules = schedules + createLosersBracket(fromBracket : schedules, whereBracketIsLoser: false, withWinnersRound: round, orLosersRound: round + 1)
        
        //
        // Find the last winner of the losers bracket and add the final game
        //
        let lastLosersGame = schedules.last
        if let home = lastWinnersGame, away = lastLosersGame where !home.isLoserBracket && away.isLoserBracket {
            var index = schedules.count
            let game = Game(index: &index, round: home.round + 1, home: nil, away: nil, prevHomeGame: home, prevAwayGame: away, isLoserBracket: false)
            schedules.append(game)
        }
        
        return schedules
    }
    
    ///
    /// Builds the loser bracket of double elimination match schedule
    ///
    /// - Returns: a list of game matches of the losers bracket.
    ///
    private static func createLosersBracket<U>(fromBracket bracket: [Game<U>], whereBracketIsLoser isLoserBracket : Bool, withWinnersRound winnersround : Int, orLosersRound losersround : Int) -> [Game<U>] {
        
        var winnersround = winnersround
        var losersround = losersround
        var survivors = [Game<U>]()
        let round = (isLoserBracket) ? losersround - 1 : winnersround
        
        //
        // The first loser index determines progress of a game on the losers bracket. When the index of a previous game is lower than this number, it comes from the winners bracket and hence interested in the losing team. Otherwise higher or equal to this index of a previous game, we are insterested to the winner of this loser game.
        //
        var firstLoserIndex = Int.max
        let winnerGames = bracket.filter{ g in !g.isLoserBracket }
        if let lastWinnerGame = winnerGames.last {
            firstLoserIndex = lastWinnerGame.index + 1
        }
        
        //
        // Look for games on the previous round
        //
        var games = bracket.filter{ g in g.round == round && g.isLoserBracket == isLoserBracket }
        guard games.count > 1 else { return survivors }
        games.sortInPlace({ (g,h) in g.index < h.index })
        var index = bracket.count
        
        //
        // Look for losers for previous round and create games sequentially (no rainbows)
        //
        var i = 0
        while i < games.count - 1 {
            let prevhome = games[i]
            let prevaway = games[i+1]
            let game = Game(index: &index, round: losersround, home: nil, away: nil, prevHomeGame: prevhome, prevAwayGame: prevaway, isLoserBracket: true)
            game.firstLoserIndex = firstLoserIndex
            survivors.append(game)
            i = i + 2
        }
        
        //
        // Look for losers for the next round of winners bracket and match them with winners in this current round of games
        //
        winnersround = winnersround + 1
        var newlosers = bracket.filter{ g in g.round == winnersround && g.isLoserBracket == false }
        guard newlosers.count > 0 && newlosers.count == survivors.count else { return [Game<U>]() }
        newlosers.sortInPlace({ (g, h) in g.index < h.index })
        
        //
        // Create padded rounds as result of matching the new losers of winners round and survivors
        //
        losersround = losersround + 1
        for i in 0...survivors.count - 1 {
            let newloser = newlosers[i]
            let survivor = survivors[i]
            let game = Game(index: &index, round: losersround, home: nil, away: nil, prevHomeGame: newloser, prevAwayGame: survivor, isLoserBracket: true)
            game.firstLoserIndex = firstLoserIndex
            survivors.append(game)
        }
        
        //
        // Increment losers round again to create the next branch of the brackets
        //
        losersround = losersround + 1
        return survivors + createLosersBracket(fromBracket: survivors + bracket, whereBracketIsLoser: true, withWinnersRound: winnersround, orLosersRound: losersround)
    }

}