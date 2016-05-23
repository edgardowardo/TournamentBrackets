//
//  Game.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 17/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import RealmSwift

class Game : Object {
    dynamic var id = NSUUID().UUIDString

    dynamic var round: Int = 0
    dynamic var index: Int = 0
    dynamic var winner: Team? = nil
    dynamic var leftTeam: Team? = nil
    dynamic var rightTeam: Team? = nil
    dynamic var isBye: Bool = false
    dynamic var leftScore = 0
    dynamic var rightScore = 0
    dynamic var note = ""

    dynamic var doubles : Doubles? = nil
    dynamic var elimination : Elimination? = nil

    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(round: Int, index: Int, winner: Team?, leftTeam: Team?, rightTeam: Team?, isBye: Bool, doubles: Doubles?, elimination: Elimination?) {
        self.init()
        self.round = round
        self.index = index
        self.winner = winner
        self.leftTeam = leftTeam
        self.rightTeam = rightTeam
        self.isBye = isBye

        self.doubles = doubles
        self.elimination = elimination
    }
}

class Doubles : Object {
    dynamic var id = NSUUID().UUIDString
    dynamic var leftTeam2: Team? = nil
    dynamic var rightTeam2: Team? = nil
    
    convenience init(leftTeam2: Team?, rightTeam2: Team?) {
        self.init()
        self.leftTeam2 = leftTeam2
        self.rightTeam2 = rightTeam2
    }
}

class Elimination : Object {
    dynamic var id = NSUUID().UUIDString
    dynamic var isLoserBracket = false
    dynamic var leftGameIndex: Int = 0
    dynamic var prevLeftGame : Game? = nil
    dynamic var rightGameIndex: Int = 0
    dynamic var prevRightGame : Game? = nil
    dynamic var firstLoserIndex = Int.max
    
    convenience init(isLoserBracket : Bool, leftGameIndex: Int, rightGameIndex: Int) {
        self.init()
        self.isLoserBracket = isLoserBracket
        self.leftGameIndex = leftGameIndex
        self.rightGameIndex = rightGameIndex
    }
}
