//
//  Tree.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 25/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation

///
/// A generic tree type which can be a value or reference type
///
indirect enum Tree<SomeType> {
    case Empty
    case Node(left: Tree<SomeType>, value: SomeType, right: Tree<SomeType>)
    func flatten() -> [Tree<SomeType>] {
        var flatNodes = [Tree<SomeType>]()
        switch self {
        case .Empty :
            break
        case let .Node(left, _, right) :
            flatNodes = flatNodes + left.flatten() + right.flatten() + [self]
        }
        return flatNodes
    }
}

extension Tree {
    var round : Int {
        get {
            if case .Node(_, let value, _) = self {
                if let game = value as? GameProtocol {
                    return game.round
                }
            }
            return 0
        }
    }
    var index : Int {
        get {
            if case .Node(_, let value, _) = self {
                if let game = value as? GameProtocol {
                    return game.index
                }
            }
            return 0
        }
    }
}