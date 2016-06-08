//
//  GroupImporter.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 08/06/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RealmSwift

class GroupImporter {
    
    let realm = try! Realm()
    
    func importGroup(group : [String : AnyObject]) {

        let tname = "Imported"
        let tourney : Tournament
        if let t = realm.objects(Tournament).filter("name == '\(tname)'").first {
            tourney = t
        } else {
            tourney = Tournament()
            try! realm.write {
                tourney.name = tname
                realm.add(tourney, update: true)
            }
        }

        let group = Group(value: group)
        group.id = NSUUID().UUIDString
        group.time = NSDate().timeIntervalSinceReferenceDate

        let count = tourney.groups.filter("name contains '\(group.name)'").count
        if count > 0 {
            group.name = "\(group.name)(\(count))"
        }
        
        try! self.realm.write {
            for t in group.teams {
                t.id = NSUUID().UUIDString
            }
            let games = Array(group.games)
            let teams = Array(group.teams)
            for g in group.games {
                g.id = NSUUID().UUIDString
                // re-assign winner, leftTeam rightTeam, doubles.leftTeam2, doubles.rightTeam2, prevLeftGame, prevRightGame
                if let w = g.winner {
                    g.winner = teams.filter({ $0.seed == w.seed}).first
                }
                if let lt = g.leftTeam {
                    g.leftTeam = teams.filter({ $0.seed == lt.seed}).first                    
                }
                if let rt = g.rightTeam {
                    g.rightTeam = teams.filter({ $0.seed == rt.seed}).first
                }
                
                if let d = g.doubles {
                    if let lt = d.leftTeam2 {
                        d.leftTeam2 = teams.filter({ $0.seed == lt.seed}).first
                    }
                    if let rt = d.rightTeam2 {
                        d.rightTeam2 = teams.filter({ $0.seed == rt.seed}).first
                    }
                }
                if let e = g.elimination {
                    if let lg = e.prevLeftGame {
                        e.prevLeftGame = games.filter({ $0.index == lg.index }).first
                    }
                    if let rg = e.prevRightGame {
                        e.prevRightGame = games.filter({ $0.index == rg.index }).first
                    }
                }
            }
            tourney.time = NSDate().timeIntervalSinceReferenceDate
            tourney.groups.insert(group, atIndex: 0)
            self.realm.add(tourney, update: true)
        }
    }
}