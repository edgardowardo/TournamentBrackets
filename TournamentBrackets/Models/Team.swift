//
//  Team.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 04/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RealmSwift

class Team : Object {
    dynamic var id = NSUUID().UUIDString
    dynamic var name = ""
    dynamic var handicap : Int = 0
    dynamic var seed = 0
    
    convenience init(name : String, seed : Int) {
        self.init()
        self.name = name
        self.seed = seed
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}