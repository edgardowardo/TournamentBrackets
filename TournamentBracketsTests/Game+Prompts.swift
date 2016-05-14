//
//  Game+Prompts.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 14/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
@testable import TournamentBrackets

//
// View model routines such as displaying left and right prompts
//
extension GameTree {
    var isBothBye : Bool {
        get {
            return leftPrompt == "BYE" && rightPrompt == "BYE"
        }
    }
    var leftPrompt : String {
        switch self {
        case .Game(_, let left, let right) :
            if let l = left {
                return "\(l)"
            } else if let _ = right where left == nil && self.isBye {
                return "BYE"
            }
            return ""
        case .FutureGame(_, let left, _) :
            if isLoserBracket && (left.isBye && left.index < left.firstLoserIndex || left.isBothBye) {
                return "BYE"
            } else {
                return ""
            }
        }
    }
    
    var rightPrompt : String {
        switch self {
        case .Game(_, let left, let right) :
            if let r = right {
                return "\(r)"
            } else if let _ = left where right == nil && self.isBye {
                return "BYE"
            }
            return ""
        case .FutureGame(_, _, let right) :
            if isLoserBracket && (right.isBye && right.index < right.firstLoserIndex || right.isBothBye) {
                return "BYE"
            } else {
                return ""
            }
        }
    }
}

//
// Place in testing.
//
extension GameTree {
    var versus : String {
        switch self {
        case .Game(_, _, _) :
            let l = (leftPrompt == "BYE") ? "B" : leftPrompt
            let r = (rightPrompt == "BYE") ? "B" : rightPrompt
            return "\(l)v\(r)"
        case .FutureGame(_, let left, let right):
            let leftprefix = (isLoserBracket && left.index < left.firstLoserIndex) ? "L" : "W"
            let rightprefix = (isLoserBracket && right.index < right.firstLoserIndex) ? "L" : "W"
            let l, r : String
            if let w = left.winner where !isLoserBracket {
                l = "\(w)"
            } else {
                l = "\(leftprefix)\(left.index)"
            }
            if let w = right.winner where !isLoserBracket {
                r = "\(w)"
            } else {
                r = "\(rightprefix)\(right.index)"
            }
            return "\(l)v\(r)"
        }
    }
}