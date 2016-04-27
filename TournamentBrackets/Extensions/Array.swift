//
//  Array.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 27/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

extension Array where Element : Hashable {
    var unique: [Element] {
        return Array(Set(self))
    }
}