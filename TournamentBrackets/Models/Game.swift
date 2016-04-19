//
//  Game.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 17/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

///
/// Game model of single and double elimination schedules. An object model is necessary to 
/// represent pointers of the previous games which makes up the tournament tree.
///
class Game<T> {
    var index = 0
    var round = 0
    var home : T?
    var away : T?
    var prevHomeGame : Game?
    var prevAwayGame : Game?
    var isLoserBracket = false
    var firstLoserIndex = Int.max // only matters if isLoserBracket is true
    var isBye : Bool {
        get {
            return homePrompt == "BYE" || awayPrompt == "BYE"
        }
    }
    var isBothBye : Bool {
        get {
            return homePrompt == "BYE" && awayPrompt == "BYE"
        }
    }
    var homePrompt : String {
        get {
            if let h = home {
                return "\(h)"
            } else if let ph = prevHomeGame {
                if isLoserBracket && (ph.isBye && ph.index < ph.firstLoserIndex || ph.isBothBye) {
                    return "BYE"
                } else {
                    return ""
                }
            } else {
                return "BYE"
            }
        }
    }
    var awayPrompt : String {
        get {
            if let a = away {
                return "\(a)"
            } else if let ah = prevAwayGame {
                if isLoserBracket && (ah.isBye && ah.index < ah.firstLoserIndex || ah.isBothBye) {
                    return "BYE"
                } else {
                    return ""
                }
            } else {
                return "BYE"
            }
        }
    }
    var info : String {
        get {
            var i = ""
            if isLoserBracket {
                i = "LR\(round).\(index)."
                if let h = home {
                    i.appendContentsOf("\(h)")
                } else if let ph = prevHomeGame {
                    if ph.index < ph.firstLoserIndex {
                        i.appendContentsOf("L\(ph.index)")
                    } else {
                        i.appendContentsOf("W\(ph.index)")
                    }
                } else {
                    i.appendContentsOf("B")
                }
                i.appendContentsOf("v")
                if let a = away {
                    i.appendContentsOf("\(a)")
                } else if let ah = prevAwayGame {
                    if ah.index < ah.firstLoserIndex {
                        i.appendContentsOf("L\(ah.index)")
                    } else {
                        i.appendContentsOf("W\(ah.index)")
                    }
                } else {
                    i.appendContentsOf("B")
                }
            } else {
                i = "R\(round).\(index)."
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
            }
            return i
        }
    }
    
    convenience init(inout index : Int, round : Int, home : T?, away : T?, prevHomeGame : Game?, prevAwayGame : Game?, isLoserBracket : Bool) {
        self.init()
        index = index + 1
        self.index = index
        self.round = round
        self.home = home
        self.away = away
        self.prevHomeGame = prevHomeGame
        self.prevAwayGame = prevAwayGame
        self.isLoserBracket = isLoserBracket
        
        if round < 3 && !isLoserBracket {
            //
            // progress previous home game if it's a bye
            //
            if let prevhome = prevHomeGame {
                if let h = prevhome.home where prevhome.away == nil {
                    self.home = h
                } else if let a = prevhome.away where prevhome.home == nil {
                    self.home = a
                }
            }
            
            //
            // progress previous away game if it's a bye
            //
            if let prevaway = prevAwayGame {
                if let h = prevaway.home where prevaway.away == nil {
                    self.away = h
                } else if let a = prevaway.away where prevaway.home == nil {
                    self.away = a
                }
            }
        }
    }
}
