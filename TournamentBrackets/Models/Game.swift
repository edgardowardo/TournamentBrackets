//
//  Game.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 17/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

///
/// A binary tree representing two teams playing in a single or double elimination schedule.
///
indirect enum GameTree<SomeTeam> {
    
    ///
    /// A game scheduled on the first round of the tree
    ///
    case Game(info: GameInfo<SomeTeam>, left: SomeTeam?, right: SomeTeam?)
    
    ///
    /// A future game scheduled on the suceeding rounds of the tree
    ///
    case FutureGame(info: GameInfo<SomeTeam>, left: GameTree<SomeTeam>, right: GameTree<SomeTeam>)
    
    ///
    /// Flattens a tree into a list
    ///
    func flatten() -> [GameTree<SomeTeam>] {
        var flatNodes = [GameTree<SomeTeam>]()
        switch self {
        case .Game(_,_,_) :
            flatNodes = flatNodes + [self]
        case let .FutureGame(_, left, right) :
            flatNodes = flatNodes + left.flatten() + right.flatten() + [self]
        }
        return flatNodes
    }
}

///
/// Stored information about the game
///
struct GameInfo<SomeTeam> {
    var index: Int
    var round: Int
    var isBye: Bool
    var winner: SomeTeam?
    var isLoserBracket = false
    var firstLoserIndex = Int.max
    init(index: Int, round: Int, isBye: Bool, winner: SomeTeam?) {
        self.index = index
        self.round = round
        self.isBye = isBye
        self.winner = winner
    }
    init(index: Int, round: Int, isBye: Bool, winner: SomeTeam?, isLoserBracket: Bool, firstLoserIndex: Int) {
        self.init(index: index, round: round, isBye: isBye, winner: winner)
        self.isLoserBracket = isLoserBracket
        self.firstLoserIndex = firstLoserIndex
    }
}

///
/// Global equatable function to allow Array.unique
///
func ==<SomeTeam>(lhs: GameTree<SomeTeam>, rhs: GameTree<SomeTeam>) -> Bool {
    return lhs.index == rhs.index
}

///
/// Convenience properties of the game information in the tree
///
extension GameTree : Hashable, Equatable {
    var hashValue: Int {
        get {
            return index
        }
    }
    var index : Int {
        get {
            switch self {
            case .Game(let info, _, _) :
                return info.index
            case .FutureGame(let info, _, _) :
                return info.index
            }
        }
    }
    var round : Int {
        get {
            switch self {
            case .Game(let info, _, _) :
                return info.round
            case .FutureGame(let info, _, _) :
                return info.round
            }
        }
    }
    var isBye : Bool {
        get {
            switch self {
            case .Game(let info, _, _) :
                return info.isBye
            case .FutureGame(let info, _, _) :
                return info.isBye
            }
        }
    }
    var winner : SomeTeam? {
        get {
            switch self {
            case .Game(let info, _, _) :
                return info.winner
            case .FutureGame(let info, _, _) :
                return info.winner
            }
        }
    }
    var isLoserBracket : Bool {
        get {
            switch self {
            case .Game(let info, _, _) :
                return info.isLoserBracket
            case .FutureGame(let info, _, _) :
                return info.isLoserBracket
            }
        }
    }
    var firstLoserIndex : Int {
        get {
            switch self {
            case .Game(let info, _, _) :
                return info.firstLoserIndex
            case .FutureGame(let info, _, _) :
                return info.firstLoserIndex
            }
        }
    }
}
