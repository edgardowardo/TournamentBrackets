//
//  GroupSettingViewModel.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 04/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RxSwift

struct GroupSettingViewModel {

    var name : String
    var scheduleType: Variable<ScheduleType>   = Variable(.RoundRobin)
    
//    var scheduleType1: Variable<Int>   = Variable(0)
//    var scheduleType2: Variable<Int>   = Variable(-1)
    var teamCount = 2
    var isHandicap = false

    init(group : Group) {
        self.name = group.name
        
//        switch group.schedule {
//        case .RoundRobin:
//            fallthrough
//        case .RoundDoubles:
//            scheduleType1.value = group.schedule.rawValue
//            scheduleType2.value = -1
//        case .SingleElimination :
//            fallthrough
//        case .DoubleElimination :
//            scheduleType1.value = -1
//            scheduleType2.value = group.schedule.rawValue
//        }
        
        self.scheduleType.value = group.schedule
        self.teamCount = group.schedule.allowedTeamCounts.first!
        self.isHandicap = group.isHandicap
    }
    
}