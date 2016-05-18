//
//  GameListViewModel.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 17/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

struct GameListViewModel {
    
    var realm = try! Realm()
    var games : Observable<Array<Game>>!
    let gameViewModels : [GameViewModel]!
    var pageIndex : Int!

    private var group : Group!
    
    init(group : Group, gameViewModels: [GameViewModel], round : Int, isLoserBracket : Bool) {
        let g = group
        self.group = g
        self.gameViewModels = gameViewModels
        self.games = g.games
            .filter("round == %@", round)
            .filter("elimination == nil || elimination.isLoserBracket == %@", isLoserBracket)
            .sorted("index", ascending: true)
            .asObservableArray()
    }
}
