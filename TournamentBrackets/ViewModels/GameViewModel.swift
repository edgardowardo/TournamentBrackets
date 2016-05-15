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

class GameViewModel {
    
    var realm = try! Realm()
    var winner : Variable<Team?> = Variable(nil)
    var leftTeam : Variable<Team?> = Variable(nil)
    var rightTeam : Variable<Team?> = Variable(nil)
    lazy var disposeBag: DisposeBag? = { return DisposeBag() }()
    
    var prevLeftGameViewModel : GameViewModel? = nil {
        didSet {
            if let prevModel = prevLeftGameViewModel {
                prevModel.winner
                    .asObservable()
                    .subscribeNext { [unowned self] newWinner in
                        guard let elimination = self.game.elimination, prevLeftGame = elimination.prevLeftGame else { return }
                        let newLoser : Team? = (newWinner == nil) ? nil : prevLeftGame.opposite(newWinner)
                        guard  (!elimination.isLoserBracket && newWinner != self.game.leftTeam)
                            || (elimination.isLoserBracket && newLoser != self.game.leftTeam)  else { return }
                        let team : Team? = ( elimination.isLoserBracket ) ? newLoser : newWinner
                        self.winner.value = nil
                        self.leftTeam.value = team
                        try! self.realm.write {
                            self.game.winner = nil
                            self.game.leftTeam = team
                        }
                    }
                    .addDisposableTo(disposeBag!)
            }
        }
    }
    
    var prevRightGameViewModel : GameViewModel? = nil {
        didSet {
            if let prevModel = prevRightGameViewModel {
                prevModel.winner
                    .asObservable()
                    .subscribeNext { [unowned self] newWinner in
                        guard let elimination = self.game.elimination, prevRightGame = elimination.prevRightGame else { return }
                        let newLoser : Team? = (newWinner == nil) ? nil : prevRightGame.opposite(newWinner)
                        
//                        if prevRightGame.isAnyBye {
//                            newLoser = newWinner
//                        }
                        
                        guard  (!elimination.isLoserBracket && newWinner != self.game.rightTeam)
                            || (elimination.isLoserBracket && newLoser != self.game.rightTeam)  else { return }
                        let team : Team? = ( elimination.isLoserBracket ) ? newLoser : newWinner
                        self.winner.value = nil
                        self.rightTeam.value = team
                        try! self.realm.write {
                            self.game.winner = nil
                            self.game.rightTeam = team
                        }
                    }
                    .addDisposableTo(disposeBag!)
            }
        }
    }
    
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
        
        self.leftTeam
            .asObservable()
            .subscribeNext { [unowned self] someTeam in
                if let team = someTeam where self.game.rightPrompt == "BYE" {
                    self.winner.value = team
                    try! self.realm.write {
                        self.game.winner = team
                    }
                }
            }
            .addDisposableTo(self.disposeBag!)
        
        self.rightTeam
            .asObservable()
            .subscribeNext { [unowned self] someTeam in
                if let team = someTeam where self.game.leftPrompt == "BYE" {
                    self.winner.value = team
                    try! self.realm.write {
                        self.game.winner = team
                    }
                }
            }
            .addDisposableTo(self.disposeBag!)
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
    
    func opposite(team: Team?) -> Team? {
        if team == self.leftTeam {
            return self.rightTeam
        } else if team == self.rightTeam {
            return self.leftTeam
        } else {
            return nil
        }
    }
    
    var isAnyBye : Bool {
        get {
            return leftPrompt == "BYE" || rightPrompt == "BYE"
        }
    }
    
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