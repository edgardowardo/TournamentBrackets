//
//  GroupSettingViewModel.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 04/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RxSwift

import RealmSwift

struct GroupSettingViewModel {

    var realm = try! Realm()
    var name : String
    var scheduleType : Variable<ScheduleType>   = Variable(.RoundRobin)
    var isSorting : Variable<Bool> = Variable(false)
    var isHandicap : Variable<Bool> = Variable(true)
    var teams: Variable<[Team]> = Variable([])
    var teamCount = 2 {
        didSet {
            
            //
            // Don't just delete the old teams. It may contain text inputs. Combine with the new ones if adding.
            //
            var oldTeams = self.teams.value
            
            //
            // add to list
            //
            if oldTeams.count < teamCount {
                let newTeams = (oldTeams.count ..< teamCount).map{ (value) in Team(name: "Team \(value + 1 )", seed: value + 1, isHandicap : self.isHandicap.value) }
                oldTeams = oldTeams + newTeams
            }
            
            //
            // truncate list
            //
            if oldTeams.count > teamCount {
                oldTeams = Array(oldTeams[0..<teamCount])
            }
            self.teams.value = oldTeams
        }
    }
    
    func saveWithTournament(tournament : Tournament) -> Group {
        let group = Group()
        group.name = self.name
        group.schedule = self.scheduleType.value
        group.teamCount = self.teamCount
        group.teams = List(self.teams.value)
        try! self.realm.write {
            tournament.groups.append(group)
            self.realm.add(tournament, update: true)
        }
        return group
    }
    
    func setTeamsHandicap(isHandicap : Bool) {
        for t in teams.value {
            t.isHandicapped = isHandicap
        }
    }
    
    func shuffle() {
        self.teams.value.shuffleInPlace()
        for (index, element) in teams.value.enumerate() {
            element.seed = index + 1
        }
    }
    
    func reset() {
        let newTeams = (0 ..< teamCount).map{ (value) in Team(name: "Team \(value + 1 )", seed: value + 1, isHandicap : self.isHandicap.value) }
        self.teams.value = newTeams
    }
    
    func moveElement(fromIndexPath : NSIndexPath, toIndexPath : NSIndexPath) {
        let f = fromIndexPath.row, t = toIndexPath.row
        let element = teams.value[f]
        teams.value.removeAtIndex(f)
        teams.value.insert(element, atIndex: t)
        for (index, element) in teams.value.enumerate() {
            element.seed = index + 1
        }
    }
    
    init(group : Group) {
        self.name = group.name
        self.scheduleType.value = group.schedule
        self.teamCount = group.schedule.allowedTeamCounts.first!
        self.isHandicap.value = group.isHandicap
    }
}