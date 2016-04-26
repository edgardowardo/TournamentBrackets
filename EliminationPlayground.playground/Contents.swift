//: Playground - noun: a place where people can play

import Foundation

let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]

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
    func flatten() -> [GameTree<SomeTeam>] {
        var flatNodes = [GameTree<SomeTeam>]()
        switch self {
        case .Game(_,_,_) :
            flatNodes = flatNodes + [self]
        case let .FutureGame(_, left, right) :
            flatNodes = flatNodes + left.flatten() + right.flatten() + [self]
        }
        return flatNodes
    }
}

///
/// Stored information about the game
///
struct GameInfo<Team> {
    var index: Int
    var round: Int
    var isBye: Bool
    var winner: Team?
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
}

//
// View model routines such as displaying left and right prompts
//
extension GameTree {
    
    var leftPrompt : String {
        switch self {
        case .Game(_, let left, let right) :
            if let l = left {
                return "\(l)"
            } else if let _ = right where left == nil && self.isBye {
                return "BYE"
            }
            return ""
        case .FutureGame(_, _, _) :
            return ""
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
        case .FutureGame(_, _, _) :
            return ""
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
            let l, r : String
            if let w = left.winner {
                l = "\(w)"
            } else {
                l = "W\(left.index)"
            }
            if let w = right.winner {
                r = "\(w)"
            } else {
                r = "W\(right.index)"
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
func valuedSingleElimination<TeamType>(round : Int, teams : [TeamType?]) -> GameTree<TeamType> {
    
    var index = 0
    var elements = teams
    var schedules = [GameTree<TeamType>]()
    
    guard elements.count <= 64 && round < elements.count else {
        let winner : TeamType? = nil
        let info = GameInfo(index: 0, round: 0, isBye: false, winner: winner)
        return GameTree.Game(info: info, left: nil, right: nil)
    }
    
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
        var winner : TeamType? = nil
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
func valuedSingleElimination<TeamType>(index : Int, round : Int, trees : [GameTree<TeamType>]) -> GameTree<TeamType> {
    
    var index = index
    var schedules = [GameTree<TeamType>]()
    
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
        let nilTeam : TeamType? = nil
        let info = GameInfo(index: index, round: round, isBye: false, winner: nilTeam)
        let game = GameTree.FutureGame(info: info, left: left, right: right)
        schedules.append(game)
    }
    
    //
    // apply rainbow pairing for the new game winners until the base case happens
    //
    return valuedSingleElimination(index, round: round + 1, trees: schedules)
}

var newgames = valuedSingleElimination(1, teams: teams)
var newflatgames = newgames.flatten()
newflatgames.sortInPlace{ (g1, g2) -> Bool in return g1.index < g2.index }

for g in newflatgames {
    print("R\(g.round).\(g.index).\(g.versus)") //  ->\(g)")
}



//newflatgames.sortInPlace{ (g1, g2) -> Bool in return g1.index < g2.index }

//for (index, item) in newflatgames.enumerate() {
//    if case .Node(let left, let right) = item {
//        var homeText = "B", awayText = "B"
//        if let home = value.home {
//            homeText = "\(home)"
//        } else if case .Node(_, let v, _) = left {
//            homeText = "W\(v.index)"
//        }
//        if let away = value.away {
//            awayText = "\(away)"
//        } else if case .Node(_, let v, _) = right {
//            awayText = "W\(v.index)"
//        }
//        print("R\(value.round).\(value.index).\(homeText)v\(awayText)")
//    }
//}

print("----------------------------------------------------")

/*

//GameTree.Empty
//GameTree.Node(left: <#T##GameTree<SomeTeam>#>, center: <#T##SomeTeam#>, right: <#T##GameTree<SomeTeam>#>)
//GameTree.Match(home: <#T##SomeTeam#>, away: <#T##SomeTeam#>)


///
/// Game protocol
///
protocol GameProtocol {
    var index: Int { get set }
    var round: Int { get set }
    var isBye: Bool { get set }
}

///
/// A generic tree type which can be a value or reference type
///
indirect enum Tree<SomeType> {
    case Empty
    case Node(left: Tree<SomeType>, value: SomeType, right: Tree<SomeType>)
    func flatten() -> [Tree<SomeType>] {
        var flatNodes = [Tree<SomeType>]()
        switch self {
        case .Empty :
            break
        case let .Node(left, _, right) :
            flatNodes = flatNodes + left.flatten() + right.flatten() + [self]
        }
        return flatNodes
    }
}

extension Tree {
    var round : Int {
        get {
            if case .Node(_, let value, _) = self {
                if let game = value as? GameProtocol {
                    return game.round
                }
            }
            return 0
        }
    }
    var index : Int {
        get {
            if case .Node(_, let value, _) = self {
                if let game = value as? GameProtocol {
                    return game.index
                }
            }
            return 0
        }
    }
}

//protocol DoubleEliminationGameProtocol {
//    var isLoserBracket : Bool { get set }
//    var firstLoserIndex : Int { get set }
//}


protocol OldGameProtocol {
    var index: Int { get set }
    var round: Int { get set }
}

struct Game<Team>: OldGameProtocol {
    var index: Int
    var round: Int
    var home: Team?
    var away: Team?
}

func singleElimination<TeamType>(round : Int, teams : [TeamType?]) -> Tree<Game<TeamType>> {
    
    var index = 0
    var elements = teams
    var schedules = [Tree<Game<TeamType>>]()
    
    guard elements.count <= 64 && round < elements.count else {
        print("empty")
        return Tree.Empty
    }
    
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
        let game = Game(index: index, round: round, home: home, away: away)
        let tree = Tree.Node(left: Tree.Empty, value: game, right: Tree.Empty)
        //schedules.insert(tree, atIndex: 0)
        schedules.append(tree)
    }
    
    //
    // apply rainbow pairing for the new game winners instead of teams
    //
    return singleElimination(index, round: round + 1, trees: schedules)
}


func singleElimination<TeamType>(index : Int, round : Int, trees : [Tree<Game<TeamType>>]) -> Tree<Game<TeamType>> {
    
    var index = index
    var schedules = [Tree<Game<TeamType>>]()
    
    guard trees.count > 1 else { return trees[0]}
    
    //
    // process all the game winners to create new games for the round
    //
    let endIndex = trees.count - 1
    for i in (0 ..< trees.count / 2).reverse() {
        let left = trees[i]
        let right = trees[endIndex - i]
        
        index = index + 1
        let nilTeam : TeamType? = nil
        let game = Game(index: index, round: round, home: nilTeam, away: nilTeam)
        let tree = Tree.Node(left: left, value: game, right: right)
        schedules.append(tree)
    }
    
    //
    // apply rainbow pairing for the new game winners until the base case happens
    //
    return singleElimination(index, round: round + 1, trees: schedules)
}

var games = singleElimination(1, teams: teams)
var flatgames = games.flatten()
flatgames.sortInPlace{ (g1, g2) -> Bool in return g1.index < g2.index }

for (index, item) in flatgames.enumerate() {
    if case .Node(let left, let value, let right) = item {
        var homeText = "B", awayText = "B"
        if let home = value.home {
            homeText = "\(home)"
        } else if case .Node(_, let v, _) = left {
            homeText = "W\(v.index)"
        }
        if let away = value.away {
            awayText = "\(away)"
        } else if case .Node(_, let v, _) = right {
            awayText = "W\(v.index)"
        }
        print("R\(value.round).\(value.index).\(homeText)v\(awayText)")
    }
}

*/
