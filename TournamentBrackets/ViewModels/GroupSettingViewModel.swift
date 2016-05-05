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
    var scheduleType : Variable<ScheduleType>   = Variable(.RoundRobin)
    var isHandicap : Variable<Bool> = Variable(false)
    var teams: Variable<[Team]> = Variable([])
    var teamCount = 2 {
        didSet {
            let newTeams = (0 ..< teamCount).map{ (value) in Team(name: "Team \(value + 1)", seed: value + 1)  }
            self.teams.value = newTeams
        }
    }
    
    init(group : Group) {
        self.name = group.name
        self.scheduleType.value = group.schedule
        self.teamCount = group.schedule.allowedTeamCounts.first!
        self.isHandicap.value = group.isHandicap
    }
}