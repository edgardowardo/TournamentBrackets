//
//  GroupDetailViewModel.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 17/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation

struct GroupDetailViewModel {
    
    var rounds : [Int]!
    var group : Group!
    var isLoserBracket : Bool = false
    let gameViewModels : [GameViewModel]!
    var indexOffset : Int {
        get {
            return (isLoserBracket) ? 2 : 1            
        }
    }
    
    var mainTitle : String {
        get {
            if group.schedule == .DoubleElimination {
                return isLoserBracket ? "Losers" : "Winners"
            }
            return group.schedule.description
        }
    }
    
    var mainIconName : String {
        get {
            return group.schedule.iconName
        }
    }
    
    init(group : Group, gameViewModels: [GameViewModel], isLoserBracket : Bool) {
        self.group = group
        self.isLoserBracket = isLoserBracket
        self.gameViewModels = gameViewModels
        rounds = Array(group.games
            .filter("elimination == nil || elimination.isLoserBracket == %@", isLoserBracket)
            .map{ $0.round }).unique
        rounds.sortInPlace({ $0 < $1 })
    }
}
