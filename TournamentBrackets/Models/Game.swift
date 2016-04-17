//
//  Game.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 17/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

class Game<T> {
    var index = 0
    var round = 0
    var home : T?
    var away : T?
    var prevHomeGame : Game?
    var prevAwayGame : Game?
    var info : String {
        get {
            var i = "\(round).\(index)."
            if let h = home {
                i.appendContentsOf("\(h)")
            } else if let ph = prevHomeGame {
                i.appendContentsOf("W\(ph.index)")
            } else {
                i.appendContentsOf("B")
            }
            i.appendContentsOf("v")
            if let a = away {
                i.appendContentsOf("\(a)")
            } else if let ah = prevAwayGame {
                i.appendContentsOf("W\(ah.index)")
            } else {
                i.appendContentsOf("B")
            }
            return i
        }
    }
}