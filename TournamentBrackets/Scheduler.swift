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
    /// - Returns: a list of home versus away pairs in that order. [(round, home, away)]
    ///
    static func roundRobin<T>(round : Int, row : [T?]) -> [(Int, T?,T?)] {
        var elements = row
        var schedules = [(Int, T?, T?)]()
        
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
            let pair = (round, home, away)
            schedules.append(pair)
        }
        
        //
        // shift the elements to process as the next row. the first element is fixed hence insert to position one.
        //
        var nextrow = elements
        let displaced = nextrow.removeAtIndex(elements.count - 1)
        nextrow.insert(displaced, atIndex: 1)
        
        return roundRobin(round + 1, row: nextrow) + schedules
    }
    
    ///
    /// Builds a round robin paired schedule from a given set
    ///
    /// - Returns: a list of home pairs and away pairs in that order. [(round, home1, home2, away1, away2)]
    ///
    static func roundRobinPair<T>(round : Int, row : [T?]) -> [(Int, T?,T?,T?,T?)] {
        var elements = row
        var schedules = [(Int,T?,T?,T?,T?)]()
        
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
            
            let pair = (round, home1, home2, away1, away2)
            schedules.append(pair)
            
            tophalf = tophalf - 2
        }
        
        //
        // shift the elements to process as the next row. the last element is fixed hence, displaced is minus two.
        //
        var nextrow = elements
        let displaced = nextrow.removeAtIndex(elements.count - 2)
        nextrow.insert(displaced, atIndex: 0)
        
        return roundRobinPair(round + 1, row: nextrow) + schedules
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
    static func singleElimination<U>(inout index : Int, round : Int, row : [Game<U>]) -> [Game<U>] {
        
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

    
}