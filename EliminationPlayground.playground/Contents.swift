//: Playground - noun: a place where people can play

import Foundation

infix operator ^^ { }
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}

indirect enum GameTree<SomeTeam> {
    case Game(left: SomeTeam?, right: SomeTeam?)
    case FutureGame(left: GameTree<SomeTeam>, right: GameTree<SomeTeam>)
    func flatten() -> [GameTree<SomeTeam>] {
        var flatNodes = [GameTree<SomeTeam>]()
        switch self {
        case .Game(_,_) :
            flatNodes = flatNodes + [self]
        case let .FutureGame(left, right) :
            flatNodes = flatNodes + left.flatten() + right.flatten()
        }
        return flatNodes
    }
}


func singleElimination<TeamType>(round : Int, teams : [TeamType?]) -> GameTree<TeamType> {
    
    var index = 0
    var elements = teams
    var schedules = [GameTree<TeamType>]()
    
    guard elements.count <= 64 && round < elements.count else {
        return GameTree.Game(left: nil, right: nil) // TODO: CORRECT????
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
        let game = GameTree.Game(left: home, right: away)
        schedules.append(game)
    }
    
    //
    // apply rainbow pairing for the new game winners instead of teams
    //
    return singleElimination(index, round: round + 1, trees: schedules)
 
}

func singleElimination<TeamType>(index : Int, round : Int, trees : [GameTree<TeamType>]) -> GameTree<TeamType> {
    
    var index = index
    var schedules = [GameTree<TeamType>]()
    
    guard trees.count > 1 else { return trees[0]}
    
    //
    // process all the game winners to create new games for the round
    //
    let endIndex = trees.count - 1
    for i in (0 ..< trees.count / 2).reverse() {
        let left = trees[i]
        let right = trees[endIndex - i]
        index = index + 1
        let game = GameTree.FutureGame(left: left, right: right)
        schedules.append(game)
    }
    
    //
    // apply rainbow pairing for the new game winners until the base case happens
    //
    return singleElimination(index, round: round + 1, trees: schedules)
}


var newgames = singleElimination(1, teams: [1,2,3,4,5])
var newflatgames = newgames.flatten()



for g in newflatgames {
    print(g)
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

print("-------------")


//GameTree.Empty
//GameTree.Node(left: <#T##GameTree<SomeTeam>#>, center: <#T##SomeTeam#>, right: <#T##GameTree<SomeTeam>#>)
//GameTree.Match(home: <#T##SomeTeam#>, away: <#T##SomeTeam#>)

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

protocol GameProtocol {
    var index: Int { get set }
    var round: Int { get set }
}

struct Game<Team> : GameProtocol {
    var index: Int
    var round: Int
    var home: Team?
    var away: Team?
}

func valuedSingleElimination<TeamType>(round : Int, teams : [TeamType?]) -> Tree<Game<TeamType>> {
    
    var index = 0
    var elements = teams
    var schedules = [Tree<Game<TeamType>>]()
    
    guard elements.count <= 64 && round < elements.count else { return Tree.Empty }
    
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
    return valuedSingleElimination(index, round: round + 1, trees: schedules)
}


func valuedSingleElimination<TeamType>(index : Int, round : Int, trees : [Tree<Game<TeamType>>]) -> Tree<Game<TeamType>> {
    
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
    return valuedSingleElimination(index, round: round + 1, trees: schedules)
}

var games = valuedSingleElimination(1, teams: [1,2,3,4,5])
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
