//
//  TournamentListViewModel.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 29/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RealmSwift

struct TournamentListCommandViewModel {
    
    var realm = try! Realm()
    let tournaments: [Tournament]
    
    init(tournaments : [Tournament]) {
        self.tournaments = tournaments
    }
    
    func executeCommand(command: TournamentListCommand) -> TournamentListCommandViewModel {
        switch command {
        case let .SetTournaments(tournaments):
            return TournamentListCommandViewModel(tournaments: tournaments)
        case let .DeleteTournament(indexPath):
            var all = [self.tournaments]
            all[indexPath.section].removeAtIndex(indexPath.row)
            return TournamentListCommandViewModel(tournaments: all[0])
        case let .InsertTournament(tournament):
            var t = self.tournaments
            t.append(tournament)
            return TournamentListCommandViewModel(tournaments: t)
        }
    }

}

enum TournamentListCommand {
    case SetTournaments(tournaments: [Tournament])
    case DeleteTournament(indexPath: NSIndexPath)
    case InsertTournament(tournament: Tournament)
}