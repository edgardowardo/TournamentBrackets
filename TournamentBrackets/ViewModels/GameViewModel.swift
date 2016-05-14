//
//  GameViewModel.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 13/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

struct GameViewModel {
    
    var realm = try! Realm()
    var winner : Variable<Team?> = Variable(nil)
    var leftTeam : Variable<Team?> = Variable(nil)
    var rightTeam : Variable<Team?> = Variable(nil)
    
    var leftPrompt : String {
        get {
            return game.leftPrompt
        }
    }
    var rightPrompt : String {
        get {
            return game.rightPrompt
        }
    }
    var game : Game!
    
    var index : Int {
        get {
            return game.index
        }
    }

    init(game : Game) {
        self.game = game
        self.winner.value = game.winner
        self.leftTeam.value = game.leftTeam
        self.rightTeam.value = game.rightTeam
    }
    
    func setLeftTeamAsWinner() {
        guard self.rightPrompt != "BYE" && self.rightPrompt.characters.count > 0 else { return }
        
        self.winner.value = leftTeam.value
        try! self.realm.write {
            self.game.winner = self.winner.value
        }
    }
    
    func setRightTeamAsWinner() {
        guard self.leftPrompt != "BYE" && self.leftPrompt.characters.count > 0 else { return }
        
        self.winner.value = rightTeam.value
        try! self.realm.write {
            self.game.winner = self.winner.value
        }
    }
}


extension Game {
    
    var isBothBye : Bool {
        get {
            return leftPrompt == "BYE" && rightPrompt == "BYE"
        }
    }
    
    var leftPrompt : String {
        get {
            if let l = leftTeam {
                return l.name
            } else if let _ = rightTeam where leftTeam == nil && self.isBye {
                return "BYE"
            } else if let e = elimination, left = e.prevLeftGame, leftE = left.elimination
                where e.isLoserBracket && (left.isBye && left.index < leftE.firstLoserIndex || left.isBothBye) {
                
                return "BYE"
            } else {
                return ""
            }
        }
    }
    
    var rightPrompt : String {
        get {
            if let r = rightTeam {
                return r.name
            } else if let _ = leftTeam where rightTeam == nil && self.isBye {
                return "BYE"
            } else if let e = elimination, right = e.prevRightGame, rightE = right.elimination
                where e.isLoserBracket && (right.isBye && right.index < rightE.firstLoserIndex || right.isBothBye) {
                
                return "BYE"
            } else {
                return ""
            }
        }
    }
    
}