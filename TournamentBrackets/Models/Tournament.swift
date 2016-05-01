//
//  Tournament.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 28/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RealmSwift

class Tournament : Object {
    dynamic var time: NSTimeInterval = NSDate().timeIntervalSinceReferenceDate
    dynamic var name = "Tournament"
    let groups = List<Group>()
}