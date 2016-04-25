//
//  Game.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 17/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

protocol GameProtocol {
    var index: Int { get set }
    var round: Int { get set }
}

struct Game<Team> : GameProtocol {
    var index: Int
    var round: Int
    var home: Team?
    var away: Team?
}

//protocol DoubleEliminationGameProtocol {
//    var isLoserBracket : Bool { get set }
//    var firstLoserIndex : Int { get set }
//}


indirect enum GameTree<SomeTeam> {
    case Game(left: SomeTeam?, right: SomeTeam?)
    case FutureGame(left: GameTree<SomeTeam>, right: GameTree<SomeTeam>)
    func flatten() -> [GameTree<SomeTeam>] {
        var flatNodes = [GameTree<SomeTeam>]()
        switch self {
        case .Game(_,_) :
            flatNodes = flatNodes + [self]
        case let .FutureGame(left, right) :
            flatNodes = flatNodes + left.flatten() + right.flatten()
        }
        return flatNodes
    }
}