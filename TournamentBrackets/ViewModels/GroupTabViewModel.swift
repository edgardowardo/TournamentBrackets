//
//  GroupTabViewModel.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 19/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RealmSwift

struct GroupTabViewModel {
 
    var group : Group!
    let gameViewModels : [GameViewModel]!
    var realm = try! Realm()

    init(group : Group) {
        self.group = group
        
        gameViewModels = group.games
            .sorted("index", ascending: true)
            .map{ (game) in GameViewModel(game: game, gamesCount: group.games.count) }
        for m in gameViewModels {
            if let mElimination = m.game.elimination {
                m.prevLeftGameViewModel = gameViewModels.filter{ (model) in model.index == mElimination.leftGameIndex }.first
                m.prevRightGameViewModel = gameViewModels.filter{ (model) in model.index == mElimination.rightGameIndex }.first
            }
        }
    }
    
    var title : String {
        get {
            return group.name
        }
    }
    
    func share() -> NSData {
        let d = group.toDictionary()
        return NSKeyedArchiver.archivedDataWithRootObject(d)
    }
}
