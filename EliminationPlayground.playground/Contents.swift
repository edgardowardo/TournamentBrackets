//: Playground - noun: a place where people can play

import Foundation




/*
it("schedules double elimination with 5 teams") {
    let teams : [Int?] = [1,2,3,4,5]
    let matches = Scheduler.doubleElimination(1, row: teams)
    expect(matches.count).to(equal(14))
    expect(matches[00].info).to(equal("R1.1.4v5"))
    expect(matches[01].info).to(equal("R1.2.3vB"))
    expect(matches[02].info).to(equal("R1.3.2vB"))
    expect(matches[03].info).to(equal("R1.4.1vB"))
    expect(matches[04].info).to(equal("R2.5.3v2"))
    expect(matches[05].info).to(equal("R2.6.W1v1"))
    expect(matches[06].info).to(equal("R3.7.W5vW6"))
    expect(matches[07].info).to(equal("LR2.8.L1vL2"))
    expect(matches[08].info).to(equal("LR2.9.L3vL4"))
    expect(matches[09].info).to(equal("LR3.10.L5vW8"))
    expect(matches[10].info).to(equal("LR3.11.L6vW9"))
    expect(matches[11].info).to(equal("LR4.12.W10vW11"))
    expect(matches[12].info).to(equal("LR5.13.L7vW12"))
    expect(matches[13].info).to(equal("R4.14.W7vW13"))
}*/

let teams : [Int?] = [1,2,3,4,5]

infix operator ^^ { }
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}

///
/// A binary tree representing two teams playing in a single or double elimination schedule.
///
indirect enum GameTree<SomeTeam> {
    
    ///
    /// A game scheduled on the first round of the tree
    ///
    case Game(info: GameInfo<SomeTeam>, left: SomeTeam?, right: SomeTeam?)
    
    ///
    /// A future game scheduled on the suceeding rounds of the tree
    ///
    case FutureGame(info: GameInfo<SomeTeam>, left: GameTree<SomeTeam>, right: GameTree<SomeTeam>)
    
    ///
    /// Flattens a tree in to a list
    ///
    func flatten(withRound: Int? = nil) -> [GameTree<SomeTeam>] {
        var flatNodes = [GameTree<SomeTeam>]()
        switch self {
        case .Game(_,_,_) :
            if let r = withRound where self.round == r {
                flatNodes = flatNodes + [self]
            } else {
                flatNodes = flatNodes + [self]
            }
        case let .FutureGame(_, left, right) :
            if let r = withRound where self.round == r {
                flatNodes = flatNodes + left.flatten() + right.flatten() + [self]
            } else {
                flatNodes = flatNodes + left.flatten() + right.flatten() + [self]
            }
        }
        return flatNodes
    }
}

///
/// Stored information about the game
///
struct GameInfo<SomeTeam> {
    var index: Int
    var round: Int
    var isBye: Bool
    var winner: SomeTeam?
    var isLoserBracket = false
    var firstLoserIndex = Int.max
    init(index: Int, round: Int, isBye: Bool, winner: SomeTeam?) {
        self.index = index
        self.round = round
        self.isBye = isBye
        self.winner = winner
    }
    init(index: Int, round: Int, isBye: Bool, winner: SomeTeam?, isLoserBracket: Bool, firstLoserIndex: Int) {
        self.index = index
        self.round = round
        self.isBye = isBye
        self.winner = winner
        self.isLoserBracket = isLoserBracket
        self.firstLoserIndex = firstLoserIndex
    }
}

///
/// Convenience properties of the game information in the tree
///
extension GameTree {
    var index : Int {
        get {
            switch self {
            case .Game(let info, _, _) :
                return info.index
            case .FutureGame(let info, _, _) :
                return info.index
            }
        }
    }
    var round : Int {
        get {
            switch self {
            case .Game(let info, _, _) :
                return info.round
            case .FutureGame(let info, _, _) :
                return info.round
            }
        }
    }
    var isBye : Bool {
        get {
            switch self {
            case .Game(let info, _, _) :
                return info.isBye
            case .FutureGame(let info, _, _) :
                return info.isBye
            }
        }
    }
    var winner : SomeTeam? {
        get {
            switch self {
            case .Game(let info, _, _) :
                return info.winner
            case .FutureGame(let info, _, _) :
                return info.winner
            }
        }
    }
    var isLoserBracket : Bool {
        get {
            switch self {
            case .Game(let info, _, _) :
                return info.isLoserBracket
            case .FutureGame(let info, _, _) :
                return info.isLoserBracket
            }
        }
    }
    var firstLoserIndex : Int {
        get {
            switch self {
            case .Game(let info, _, _) :
                return info.firstLoserIndex
            case .FutureGame(let info, _, _) :
                return info.firstLoserIndex
            }
        }
    }
}

//
// View model routines such as displaying left and right prompts
//
extension GameTree {
    var isBothBye : Bool {
        get {
            return leftPrompt == "BYE" && rightPrompt == "BYE"
        }
    }
    var leftPrompt : String {
        switch self {
        case .Game(_, let left, let right) :
            if let l = left {
                return "\(l)"
            } else if let _ = right where left == nil && self.isBye {
                return "BYE"
            }
            return ""
        case .FutureGame(_, let left, _) :
            if isLoserBracket && (left.isBye && left.index < left.firstLoserIndex || left.isBothBye) {
                return "BYE"
            } else {
                return ""
            }
        }
    }
    
    var rightPrompt : String {
        switch self {
        case .Game(_, let left, let right) :
            if let r = right {
                return "\(r)"
            } else if let _ = left where right == nil && self.isBye {
                return "BYE"
            }
            return ""
        case .FutureGame(_, _, let right) :
            if isLoserBracket && (right.isBye && right.index < right.firstLoserIndex || right.isBothBye) {
                return "BYE"
            } else {
                return ""
            }
        }
    }
}

//
// Place in testing.
//
extension GameTree {
    var versus : String {
        switch self {
        case .Game(_, _, _) :
            let l = (leftPrompt == "BYE") ? "B" : leftPrompt
            let r = (rightPrompt == "BYE") ? "B" : rightPrompt
            return "\(l)v\(r)"
        case .FutureGame(_, let left, let right):
            let leftprefix = (isLoserBracket && left.index < left.firstLoserIndex) ? "L" : "W"
            let rightprefix = (isLoserBracket && right.index < right.firstLoserIndex) ? "L" : "W"
            let l, r : String
            if let w = left.winner {
                l = "\(w)"
            } else {
                l = "\(leftprefix)\(left.index)"
            }
            if let w = right.winner {
                r = "\(w)"
            } else {
                r = "\(rightprefix)\(right.index)"
            }
            return "\(l)v\(r)"
        }
    }
}

///
/// Builds single elimination match schedule from a given set
///
/// - Returns: a game tree in single elimination format.
///
func valuedSingleElimination<SomeTeam>(round : Int, teams : [SomeTeam?]) -> GameTree<SomeTeam> {
    
    var index = 0
    var elements = teams
    var schedules = [GameTree<SomeTeam>]()
    
    //
    // Adjust the number of teams with a bye, necessary to construct the brackets which are 2, 4, 8, 16, 32 and 64
    //
    for i in 1...8 {
        let minimum = 2^^i
        if elements.count < minimum {
            let diff = minimum - elements.count
            for _ in 1...diff {
                elements.append(nil)
            }
            break
        } else if elements.count == minimum {
            break
        }
    }
    
    //
    // process half the elements to create the pairs
    //
    let endIndex = elements.count - 1
    for i in (0 ..< elements.count / 2).reverse() {
        let home = elements[i]
        let away = elements[endIndex - i]
        index = index + 1
        
        //
        // Game is a bye, therefore identify the winner
        //
        var winner : SomeTeam? = nil
        if let h = home where away == nil {
            winner = h
        } else if let a = away where home == nil {
            winner = a
        }
        
        //
        // Create the game
        //
        let info = GameInfo(index: index, round: round, isBye: (winner != nil), winner: winner)
        let game = GameTree.Game(info: info, left: home, right: away)
        schedules.append(game)
    }
    
    //
    // apply rainbow pairing for the new game winners instead of teams
    //
    return valuedSingleElimination(index, round: round + 1, trees: schedules)
 
}

///
/// Builds single elimination match schedule from a given set
///
/// - Returns: a game tree in single elimination format.
///
func valuedSingleElimination<SomeTeam>(index : Int, round : Int, trees : [GameTree<SomeTeam>]) -> GameTree<SomeTeam> {
    
    var index = index
    var schedules = [GameTree<SomeTeam>]()
    
    guard trees.count > 1 else {
        return trees[0]
    }
    
    //
    // process all the game winners to create new games for the round
    //
    let endIndex = trees.count - 1
    for i in (0 ..< trees.count / 2).reverse() {
        let left = trees[i]
        let right = trees[endIndex - i]
        index = index + 1
        let nilTeam : SomeTeam? = nil
        let info = GameInfo(index: index, round: round, isBye: false, winner: nilTeam)
        let game = GameTree.FutureGame(info: info, left: left, right: right)
        schedules.append(game)
    }
    
    //
    // apply rainbow pairing for the new game winners until the base case happens
    //
    return valuedSingleElimination(index, round: round + 1, trees: schedules)
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////


///
/// Builds double elimination match schedule from a given set
///
/// - Returns: a list of game matches in double elimination format.
///
func valuedDoubleElimination<SomeTeam>(round : Int, teams : [SomeTeam?]) -> GameTree<SomeTeam> {
    var elements = teams
    
    //
    // If two teams, make it 4 beacause it needs 4 to make the losers bracket
    //
    if elements.count == 2 {
        for _ in 3...4 {
            elements.append(nil)
        }
    }
    
    //
    // Build single elimination tree aka winners bracket
    //
    let lastWinnersGame = valuedSingleElimination(1, teams: elements)
    
    //
    // Build losers bracket
    //
    let lastLosersGame = valuedLosersBracket(fromWinnersBracket: lastWinnersGame, withWinnersRound: round, andLosersList: [], withLosersRound: round + 1, andIndex: lastWinnersGame.index)
    
    //
    // The final game is between the last winners game and the last losers game
    //
    let winner : SomeTeam? = nil
    let info = GameInfo(index: lastLosersGame.index + 1, round: round, isBye: false, winner: winner)
    let finals = GameTree.FutureGame(info: info, left: lastWinnersGame, right: lastLosersGame)
    return finals
}


///
/// Builds the loser bracket of double elimination match schedule
///
/// - Returns: a list of game matches of the losers bracket.
///
func valuedLosersBracket<SomeTeam>(fromWinnersBracket winners: GameTree<SomeTeam>, withWinnersRound winnersRound : Int, andLosersList losersList: [GameTree<SomeTeam>], withLosersRound losersRound : Int, andIndex index: Int) -> GameTree<SomeTeam> {
    
    var index = index
    let isLosersBracket = (losersList.count > 0)
    var winnersround = winnersRound
    var losersround = losersRound
    var survivors = [GameTree<SomeTeam>]()
    //let round = (isLoserBracket) ? losersround - 1 : winnersround
    
    //
    // The first loser index determines progress of a game on the losers bracket. When the index of a previous game is lower than this number, it comes from the winners bracket and hence interested in the losing team. Otherwise higher or equal to this index of a previous game, we are insterested to the winner of this loser game.
    //
    let firstLoserIndex = winners.index + 1
//    var firstLoserIndex = Int.max
//    let winnerGames = bracket.filter{ g in !g.isLoserBracket }
//    if let lastWinnerGame = winnerGames.last {
//        firstLoserIndex = lastWinnerGame.index + 1
//    }
    
    //
    // Look for games on the previous round
    //
    var games : [GameTree<SomeTeam>]
    if isLosersBracket {
        games = losersList.filter{ g in g.round == losersround - 1}
    } else {
        games = winners.flatten(winnersround)
    }
    //games.sortInPlace({ (g,h) in g.index < h.index })
    
    //var games = bracket.filter{ g in g.round == round && g.isLoserBracket == isLoserBracket }
    // TODO: !!!!!
//    guard games.count > 1 else { return survivors }
//    games.sortInPlace({ (g,h) in g.index < h.index })
//    var index = bracket.count
    
    //
    // Look for losers for previous round and create games sequentially (no rainbows)
    //
    var i = 0
    while i < games.count - 1 {
        let left = games[i]
        let right = games[i+1]
        index = index + 1
        let winner : SomeTeam? = nil
        let info = GameInfo(index: index, round: losersround, isBye: false, winner: winner, isLoserBracket: true, firstLoserIndex: firstLoserIndex)
        let game = GameTree.FutureGame(info: info, left: left, right: right)
        
//        let game = GameClass(index: &index, round: losersround, home: nil, away: nil, prevHomeGame: prevhome, prevAwayGame: prevaway, isLoserBracket: true)
//        game.firstLoserIndex = firstLoserIndex
        survivors.append(game)
        i = i + 2
    }
    
    //
    // Look for losers for the next round of winners bracket and match them with winners in this current round of games
    //
    winnersround = winnersround + 1
    //var newlosers = bracket.filter{ g in g.round == winnersround && g.isLoserBracket == false }
    var newlosers = winners.flatten(winnersround)
    // TODO: REALLY?
    guard newlosers.count > 0 && newlosers.count == survivors.count else {
        let winner : SomeTeam? = nil
        let info = GameInfo(index: 0, round: 0, isBye: false, winner: winner, isLoserBracket: true, firstLoserIndex: firstLoserIndex)
        return GameTree.Game(info: info, left: nil, right: nil)
    }
    //newlosers.sortInPlace({ (g, h) in g.index < h.index })
    
    //
    // Create padded rounds as result of matching the new losers of winners round and survivors
    //
    losersround = losersround + 1
    for i in 0...survivors.count - 1 {
        let newloser = newlosers[i]
        let survivor = survivors[i]
        index = index + 1
        let winner : SomeTeam? = nil
        let info = GameInfo(index: index, round: losersround, isBye: false, winner: winner, isLoserBracket: true, firstLoserIndex: firstLoserIndex)
        let game = GameTree.FutureGame(info: info, left: newloser, right: survivor)
        
//        let game = GameClass(index: &index, round: losersround, home: nil, away: nil, prevHomeGame: newloser, prevAwayGame: survivor, isLoserBracket: true)
//        game.firstLoserIndex = firstLoserIndex
        survivors.append(game)
    }
    
    //
    // Increment losers round again to create the next branch of the brackets
    //
    losersround = losersround + 1
    return valuedLosersBracket(fromWinnersBracket: winners, withWinnersRound: winnersround, andLosersList: survivors, withLosersRound: losersround, andIndex: index)
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////

//var newgames = valuedSingleElimination(1, teams: teams)
var newgames = valuedDoubleElimination(1, teams: teams)
var newflatgames = newgames.flatten()
newflatgames.sortInPlace{ (g1, g2) -> Bool in return g1.index < g2.index }

for g in newflatgames {
    print("R\(g.round).\(g.index).\(g.versus)")
}
