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
    
    var statsList: Variable<[TeamStats]> = Variable([])
    var group : Group
    var chartType : TournamentChart
    
    init(group : Group, chartType : TournamentChart) {
        self.group = group
        self.chartType = chartType
    }
    
}