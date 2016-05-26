//
//  ChartsHorizontalBarViewModel.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 25/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RxSwift

struct ChartsHorizontalBarViewModel {
    
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
    
    var yAxisMaxValue : Double {
        get {
            if group.schedule == .RoundRobin || group.schedule == .RoundDoubles {
                return Double(helper.countGames)
            } else {
                return 0.0
            }
        }
    }
    
    mutating func loadData() {
        if chartType == .PlayedPerTeam {
            xAxis = helper.statsList.map{ $0.name }
            yAxis = helper.statsList.map{ Double($0.countPlayed) }
        }
    }
}