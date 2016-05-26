//
//  TeamsImportViewModel.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 26/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RealmSwift

struct TeamsImportListViewModel {
    
    var tournaments : Results<Tournament>!
    var realm = try! Realm()

    init() {
        tournaments = realm.objects(Tournament).sorted("time", ascending: false)
    }
}

