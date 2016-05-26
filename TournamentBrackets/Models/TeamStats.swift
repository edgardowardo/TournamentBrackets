//
//  TeamStats.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 22/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation

struct TeamStats {
    var oldseed : Int
    var seed : Int
    var name : String
    var handicap : Int
    var countPlayed : Int
    var countGames : Int
    var countWins : Int
    var countDraws : Int
    var countLost : Int
    var pointsFor : Int
    var pointsAgainst : Int
    var pointsDifference : Int
}

enum HandicapCopyOptions {
    case None, Copy, Recalculate
}