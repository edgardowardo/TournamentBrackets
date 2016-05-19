//
//  GroupDetailViewModel.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 17/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

struct GroupDetailViewModel {
    
    var realm = try! Realm()
    var rounds : [Int]!
    var group : Group!
    var showLoserBracket : Variable<Bool> = Variable(false)
    let gameViewModels : [GameViewModel]!
    
    init(group : Group) {
        self.group = group
        rounds = Array(group.games.map{ $0.round }).unique
        rounds.sortInPlace({ $0 < $1 })
        
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
}
