//
//  GameListViewModel.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 17/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RealmSwift

struct GameListViewModel {
    
    private var group : Group!
    var round : Int!
    let gameViewModels : [GameViewModel]!
    var isLoserBracket : Bool = false
    var gamesInRound : Results<Game>!
    var pageIndex : Int!
    var isRoundFinished : Bool {
        get {
            return gamesInRound.map{ (g) in g.winner != nil }.reduce(true, combine: { $0 && $1})
        }
    }
    
    init(group : Group, gameViewModels: [GameViewModel], round : Int, isLoserBracket : Bool) {
        let g = group
        self.group = g
        self.round = round
        self.gameViewModels = gameViewModels
        self.isLoserBracket = isLoserBracket
        
        self.gamesInRound = g.games
            .filter("round == %@", round)
            .filter("elimination == nil || elimination.isLoserBracket == %@", isLoserBracket)
            .sorted("index", ascending: true)
    }
}
