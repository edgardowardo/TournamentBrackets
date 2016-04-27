//
//  Test_01SchedulerSpec_RoundRobin.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 27/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RealmSwift
import Quick
import Nimble
@testable import TournamentBrackets

class Test_01SchedulerSpec_RoundRobin : QuickSpec {
    override func spec() {
        
        beforeEach {
        }
        
        afterEach {
        }        
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ///
        /// ROUND ROBIN SCHEDULE
        ///
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        it("schedules round robin with 00 team") {
            let teams : [Int?] = []
            let matches = Scheduler.roundRobin(1, row: teams)
            expect(matches.count).to(equal(0))
        }
        
        it("schedules round robin with 01 team") {
            let teams : [Int?] = [1]
            let matches = Scheduler.roundRobin(1, row: teams)
            expect(matches.count).to(equal(1))
            expect("\(matches[0])").to(equal("(1, 1, Optional(1), nil)"))
        }
        
        it("schedules round robin with 02 teams") {
            let teams : [Int?] = [1,2]
            let matches = Scheduler.roundRobin(1, row: teams)
            expect(matches.count).to(equal(1))
            expect("\(matches[0])").to(equal("(1, 1, Optional(1), Optional(2))"))
        }
        
        it("schedules round robin with 03 teams") {
            let teams : [Int?] = [1,2,3]
            let matches = Scheduler.roundRobin(1, row: teams)
            expect(matches.count).to(equal(6))
            expect("\(matches[0])").to(equal("(1, 1, Optional(2), Optional(3))"))
            expect("\(matches[1])").to(equal("(1, 2, Optional(1), nil)"))
            expect("\(matches[2])").to(equal("(2, 3, nil, Optional(2))"))
            expect("\(matches[3])").to(equal("(2, 4, Optional(1), Optional(3))"))
            expect("\(matches[4])").to(equal("(3, 5, Optional(3), nil)"))
            expect("\(matches[5])").to(equal("(3, 6, Optional(1), Optional(2))"))
        }
        
        it("schedules round robin with 04 teams") {
            let teams : [Int?] = [1,2,3,4]
            let matches = Scheduler.roundRobin(1, row: teams)
            expect(matches.count).to(equal(6))
            expect("\(matches[0])").to(equal("(1, 1, Optional(2), Optional(3))"))
            expect("\(matches[1])").to(equal("(1, 2, Optional(1), Optional(4))"))
            expect("\(matches[2])").to(equal("(2, 3, Optional(4), Optional(2))"))
            expect("\(matches[3])").to(equal("(2, 4, Optional(1), Optional(3))"))
            expect("\(matches[4])").to(equal("(3, 5, Optional(3), Optional(4))"))
            expect("\(matches[5])").to(equal("(3, 6, Optional(1), Optional(2))"))
        }
        
        it("schedules round robin with 05 teams") {
            let teams : [Int?] = [1,2,3,4,5]
            let matches = Scheduler.roundRobin(1, row: teams)
            expect(matches.count).to(equal(15))
            expect("\(matches[00])").to(equal("(1, 1, Optional(3), Optional(4))"))
            expect("\(matches[01])").to(equal("(1, 2, Optional(2), Optional(5))"))
            expect("\(matches[02])").to(equal("(1, 3, Optional(1), nil)"))
            expect("\(matches[03])").to(equal("(2, 4, Optional(2), Optional(3))"))
            expect("\(matches[04])").to(equal("(2, 5, nil, Optional(4))"))
            expect("\(matches[05])").to(equal("(2, 6, Optional(1), Optional(5))"))
            expect("\(matches[06])").to(equal("(3, 7, nil, Optional(2))"))
            expect("\(matches[07])").to(equal("(3, 8, Optional(5), Optional(3))"))
            expect("\(matches[08])").to(equal("(3, 9, Optional(1), Optional(4))"))
            expect("\(matches[09])").to(equal("(4, 10, Optional(5), nil)"))
            expect("\(matches[10])").to(equal("(4, 11, Optional(4), Optional(2))"))
            expect("\(matches[11])").to(equal("(4, 12, Optional(1), Optional(3))"))
            expect("\(matches[12])").to(equal("(5, 13, Optional(4), Optional(5))"))
            expect("\(matches[13])").to(equal("(5, 14, Optional(3), nil)"))
            expect("\(matches[14])").to(equal("(5, 15, Optional(1), Optional(2))"))
        }
        
        it("schedules round robin with 06 teams") {
            let teams : [Int?] = [1,2,3,4,5,6]
            let matches = Scheduler.roundRobin(1, row: teams)
            expect(matches.count).to(equal(15))
            expect("\(matches[00])").to(equal("(1, 1, Optional(3), Optional(4))"))
            expect("\(matches[01])").to(equal("(1, 2, Optional(2), Optional(5))"))
            expect("\(matches[02])").to(equal("(1, 3, Optional(1), Optional(6))"))
            expect("\(matches[03])").to(equal("(2, 4, Optional(2), Optional(3))"))
            expect("\(matches[04])").to(equal("(2, 5, Optional(6), Optional(4))"))
            expect("\(matches[05])").to(equal("(2, 6, Optional(1), Optional(5))"))
            expect("\(matches[06])").to(equal("(3, 7, Optional(6), Optional(2))"))
            expect("\(matches[07])").to(equal("(3, 8, Optional(5), Optional(3))"))
            expect("\(matches[08])").to(equal("(3, 9, Optional(1), Optional(4))"))
            expect("\(matches[09])").to(equal("(4, 10, Optional(5), Optional(6))"))
            expect("\(matches[10])").to(equal("(4, 11, Optional(4), Optional(2))"))
            expect("\(matches[11])").to(equal("(4, 12, Optional(1), Optional(3))"))
            expect("\(matches[12])").to(equal("(5, 13, Optional(4), Optional(5))"))
            expect("\(matches[13])").to(equal("(5, 14, Optional(3), Optional(6))"))
            expect("\(matches[14])").to(equal("(5, 15, Optional(1), Optional(2))"))
        }
        
        it("schedules round robin with 07 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7]
            let matches = Scheduler.roundRobin(1, row: teams)
            expect(matches.count).to(equal(28))
            expect("\(matches[00])").to(equal("(1, 1, Optional(4), Optional(5))"))
            expect("\(matches[01])").to(equal("(1, 2, Optional(3), Optional(6))"))
            expect("\(matches[02])").to(equal("(1, 3, Optional(2), Optional(7))"))
            expect("\(matches[03])").to(equal("(1, 4, Optional(1), nil)"))
            expect("\(matches[04])").to(equal("(2, 5, Optional(3), Optional(4))"))
            expect("\(matches[05])").to(equal("(2, 6, Optional(2), Optional(5))"))
            expect("\(matches[06])").to(equal("(2, 7, nil, Optional(6))"))
            expect("\(matches[07])").to(equal("(2, 8, Optional(1), Optional(7))"))
            expect("\(matches[08])").to(equal("(3, 9, Optional(2), Optional(3))"))
            expect("\(matches[09])").to(equal("(3, 10, nil, Optional(4))"))
            expect("\(matches[10])").to(equal("(3, 11, Optional(7), Optional(5))"))
            expect("\(matches[11])").to(equal("(3, 12, Optional(1), Optional(6))"))
            expect("\(matches[12])").to(equal("(4, 13, nil, Optional(2))"))
            expect("\(matches[13])").to(equal("(4, 14, Optional(7), Optional(3))"))
            expect("\(matches[14])").to(equal("(4, 15, Optional(6), Optional(4))"))
            expect("\(matches[15])").to(equal("(4, 16, Optional(1), Optional(5))"))
            expect("\(matches[16])").to(equal("(5, 17, Optional(7), nil)"))
            expect("\(matches[17])").to(equal("(5, 18, Optional(6), Optional(2))"))
            expect("\(matches[18])").to(equal("(5, 19, Optional(5), Optional(3))"))
            expect("\(matches[19])").to(equal("(5, 20, Optional(1), Optional(4))"))
            expect("\(matches[20])").to(equal("(6, 21, Optional(6), Optional(7))"))
            expect("\(matches[21])").to(equal("(6, 22, Optional(5), nil)"))
            expect("\(matches[22])").to(equal("(6, 23, Optional(4), Optional(2))"))
            expect("\(matches[23])").to(equal("(6, 24, Optional(1), Optional(3))"))
            expect("\(matches[24])").to(equal("(7, 25, Optional(5), Optional(6))"))
            expect("\(matches[25])").to(equal("(7, 26, Optional(4), Optional(7))"))
            expect("\(matches[26])").to(equal("(7, 27, Optional(3), nil)"))
            expect("\(matches[27])").to(equal("(7, 28, Optional(1), Optional(2))"))
        }
        
        it("schedules round robin with 08 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8]
            let matches = Scheduler.roundRobin(1, row: teams)
            expect(matches.count).to(equal(28))
            expect("\(matches[00])").to(equal("(1, 1, Optional(4), Optional(5))"))
            expect("\(matches[01])").to(equal("(1, 2, Optional(3), Optional(6))"))
            expect("\(matches[02])").to(equal("(1, 3, Optional(2), Optional(7))"))
            expect("\(matches[03])").to(equal("(1, 4, Optional(1), Optional(8))"))
            expect("\(matches[04])").to(equal("(2, 5, Optional(3), Optional(4))"))
            expect("\(matches[05])").to(equal("(2, 6, Optional(2), Optional(5))"))
            expect("\(matches[06])").to(equal("(2, 7, Optional(8), Optional(6))"))
            expect("\(matches[07])").to(equal("(2, 8, Optional(1), Optional(7))"))
            expect("\(matches[08])").to(equal("(3, 9, Optional(2), Optional(3))"))
            expect("\(matches[09])").to(equal("(3, 10, Optional(8), Optional(4))"))
            expect("\(matches[10])").to(equal("(3, 11, Optional(7), Optional(5))"))
            expect("\(matches[11])").to(equal("(3, 12, Optional(1), Optional(6))"))
            expect("\(matches[12])").to(equal("(4, 13, Optional(8), Optional(2))"))
            expect("\(matches[13])").to(equal("(4, 14, Optional(7), Optional(3))"))
            expect("\(matches[14])").to(equal("(4, 15, Optional(6), Optional(4))"))
            expect("\(matches[15])").to(equal("(4, 16, Optional(1), Optional(5))"))
            expect("\(matches[16])").to(equal("(5, 17, Optional(7), Optional(8))"))
            expect("\(matches[17])").to(equal("(5, 18, Optional(6), Optional(2))"))
            expect("\(matches[18])").to(equal("(5, 19, Optional(5), Optional(3))"))
            expect("\(matches[19])").to(equal("(5, 20, Optional(1), Optional(4))"))
            expect("\(matches[20])").to(equal("(6, 21, Optional(6), Optional(7))"))
            expect("\(matches[21])").to(equal("(6, 22, Optional(5), Optional(8))"))
            expect("\(matches[22])").to(equal("(6, 23, Optional(4), Optional(2))"))
            expect("\(matches[23])").to(equal("(6, 24, Optional(1), Optional(3))"))
            expect("\(matches[24])").to(equal("(7, 25, Optional(5), Optional(6))"))
            expect("\(matches[25])").to(equal("(7, 26, Optional(4), Optional(7))"))
            expect("\(matches[26])").to(equal("(7, 27, Optional(3), Optional(8))"))
            expect("\(matches[27])").to(equal("(7, 28, Optional(1), Optional(2))"))
        }
        
        
        it("ends this spec") {
            expect(1-1).to(equal(0))
        }
    }
}
