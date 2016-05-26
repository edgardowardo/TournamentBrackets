//
//  TeamsImportItemViewModel.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 26/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation

struct TeamsImportItemViewModel {
    
    var group : Group!
    var text : String! {
        get {
            return group.name
        }
    }
    var detailText : String! {
        get {
            return "\(group.schedule) \(group.teams.count) teams"
        }
    }
    init(group : Group) {
        self.group = group
    }
}
