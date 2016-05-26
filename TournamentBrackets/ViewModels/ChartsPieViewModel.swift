//
//  ChartsPieViewModel.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 25/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RxSwift

struct ChartsPieViewModel {
    
    var group : Group
    var chartType : TournamentChart
    var helper: TeamStatsListViewModel
    var xAxis : [String]!
    var yAxis : [Double]!
    
    init(group : Group, chartType : TournamentChart, helper : TeamStatsListViewModel) {
        self.group = group
        self.chartType = chartType
        self.helper = helper
    }
    
    var colorSet : [UIColor] {
        get {
            return chartType.colorSet
        }
    }
    
    var drawHoleEnabled : Bool {
        get {
            return chartType == .Played
        }
    }
    
    var holeText : String {
        get {
            if chartType == .Played {
                return "\(group.games.count) games in total"
            } else {
                return ""
            }
        }
    }
    
    mutating func loadData() {
        switch chartType {
        case .Played:
            xAxis = ["Played", "Not played yet"]
            let total = group.games.count
            let played = group.games
                .filter("winner != nil || isDraw == 1")
                .count
            let notplayed = total - played
            yAxis = [Double(played), Double(notplayed)]
        case .Won:
            let stats = helper.statsList.sort({ (s1, s2) in s1.countWins > s2.countWins })
            let total = stats.map{ return $0.countWins }.reduce(0, combine: { $0 + $1 })
            guard total > 0 else { xAxis = []; yAxis = []; break }
            xAxis = stats.map{ $0.name }
            yAxis = stats.map{ Double($0.countWins) }
        case .Earned:
            let stats = helper.statsList.sort({ (s1, s2) in s1.pointsFor > s2.pointsFor })
            let total = stats.map{ return $0.pointsFor }.reduce(0, combine: { $0 + $1 })
            guard total > 0 else { xAxis = []; yAxis = []; break }
            xAxis = stats.map{ $0.name }
            yAxis = stats.map{ Double($0.pointsFor) }
        case .Conceded:
            let stats = helper.statsList.sort({ (s1, s2) in s1.pointsAgainst > s2.pointsAgainst })
            let total = stats.map{ return $0.pointsAgainst }.reduce(0, combine: { $0 + $1 })
            guard total > 0 else { xAxis = []; yAxis = []; break }
            xAxis = stats.map{ $0.name }
            yAxis = stats.map{ Double($0.pointsAgainst) }
        default:
            xAxis = group.teams.map{ $0.name }
            yAxis = xAxis.map{ _ in return 0.0 }
        }
    }
}

extension TournamentChart {
    var colorSet : [UIColor] {
        get {
            if self == .Played {
                return [UIColor.flatEmeraldColor(), UIColor.flatConcreteColor()]
            } else if self == .Conceded {
                return
                    [
                        UIColor.flatConcreteColor(),
                        UIColor.flatAsbestosColor(),
                        UIColor.flatWetAsphaltColor(),
                        UIColor.flatMidnightBlueColor(),
                        UIColor.flatAmethystColor(),
                        UIColor.flatWisteriaColor(),
                        UIColor.flatPeterRiverColor(),
                        UIColor.flatBelizeHoleColor(),
                        UIColor.flatConcreteColor().colorWithAlphaComponent(0.5),
                        UIColor.flatAsbestosColor().colorWithAlphaComponent(0.5),
                        UIColor.flatWetAsphaltColor().colorWithAlphaComponent(0.5),
                        UIColor.flatMidnightBlueColor().colorWithAlphaComponent(0.5),
                        UIColor.flatAmethystColor().colorWithAlphaComponent(0.5),
                        UIColor.flatWisteriaColor().colorWithAlphaComponent(0.5),
                        UIColor.flatPeterRiverColor().colorWithAlphaComponent(0.5),
                        UIColor.flatBelizeHoleColor().colorWithAlphaComponent(0.5),
                        
                        UIColor.flatTurquoiseColor(),
                        UIColor.flatGreenSeaColor(),
                        UIColor.flatEmeraldColor(),
                        UIColor.flatNephritisColor(),
                        UIColor.flatOrangeColor(),
                        UIColor.flatCarrotColor(),
                        UIColor.flatPumpkinColor(),
                        UIColor.flatAlizarinColor(),
                        UIColor.flatPomegranateColor(),
                        UIColor.flatTurquoiseColor().colorWithAlphaComponent(0.5),
                        UIColor.flatGreenSeaColor().colorWithAlphaComponent(0.5),
                        UIColor.flatEmeraldColor().colorWithAlphaComponent(0.5),
                        UIColor.flatNephritisColor().colorWithAlphaComponent(0.5),
                        UIColor.flatOrangeColor().colorWithAlphaComponent(0.5),
                        UIColor.flatCarrotColor().colorWithAlphaComponent(0.5),
                        UIColor.flatPumpkinColor().colorWithAlphaComponent(0.5),
                        UIColor.flatAlizarinColor().colorWithAlphaComponent(0.5),
                        UIColor.flatPomegranateColor().colorWithAlphaComponent(0.5)
                ]
            } else {
                return
                    [
                        UIColor.flatTurquoiseColor(),
                        UIColor.flatGreenSeaColor(),
                        UIColor.flatEmeraldColor(),
                        UIColor.flatNephritisColor(),
                        UIColor.flatOrangeColor(),
                        UIColor.flatCarrotColor(),
                        UIColor.flatPumpkinColor(),
                        UIColor.flatAlizarinColor(),
                        UIColor.flatPomegranateColor(),
                        UIColor.flatTurquoiseColor().colorWithAlphaComponent(0.5),
                        UIColor.flatGreenSeaColor().colorWithAlphaComponent(0.5),
                        UIColor.flatEmeraldColor().colorWithAlphaComponent(0.5),
                        UIColor.flatNephritisColor().colorWithAlphaComponent(0.5),
                        UIColor.flatOrangeColor().colorWithAlphaComponent(0.5),
                        UIColor.flatCarrotColor().colorWithAlphaComponent(0.5),
                        UIColor.flatPumpkinColor().colorWithAlphaComponent(0.5),
                        UIColor.flatAlizarinColor().colorWithAlphaComponent(0.5),
                        UIColor.flatPomegranateColor().colorWithAlphaComponent(0.5),
                        
                        UIColor.flatConcreteColor(),
                        UIColor.flatAsbestosColor(),
                        UIColor.flatWetAsphaltColor(),
                        UIColor.flatMidnightBlueColor(),
                        UIColor.flatAmethystColor(),
                        UIColor.flatWisteriaColor(),
                        UIColor.flatPeterRiverColor(),
                        UIColor.flatBelizeHoleColor(),
                        UIColor.flatConcreteColor().colorWithAlphaComponent(0.5),
                        UIColor.flatAsbestosColor().colorWithAlphaComponent(0.5),
                        UIColor.flatWetAsphaltColor().colorWithAlphaComponent(0.5),
                        UIColor.flatMidnightBlueColor().colorWithAlphaComponent(0.5),
                        UIColor.flatAmethystColor().colorWithAlphaComponent(0.5),
                        UIColor.flatWisteriaColor().colorWithAlphaComponent(0.5),
                        UIColor.flatPeterRiverColor().colorWithAlphaComponent(0.5),
                        UIColor.flatBelizeHoleColor().colorWithAlphaComponent(0.5)
                ]
            }
        }
    }
}
