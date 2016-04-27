//
//  Test_02SchedulerSpec_RoundRobinDoubles.swift
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

class Test_02SchedulerSpec_RoundRobinDoubles : QuickSpec {
    override func spec() {
        
        beforeEach {
        }
        
        afterEach {
        }
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ///
        /// ROUND ROBIN DOUBLES SCHEDULE
        ///
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        it("schedules round robin doubles with 04 individuals") {
            let teams : [Int?] = [1,2,3,4]
            let matches = Scheduler.roundRobinDoubles(1, row: teams)
            expect(matches.count).to(equal(3))
            expect("\(matches[0])").to(equal("(1, 1, Optional(2), Optional(3), Optional(1), Optional(4))"))
            expect("\(matches[1])").to(equal("(2, 2, Optional(1), Optional(2), Optional(3), Optional(4))"))
            expect("\(matches[2])").to(equal("(3, 3, Optional(3), Optional(1), Optional(2), Optional(4))"))
        }
        
        it("schedules round robin doubles with 05 individuals") {
            let teams : [Int?] = [1,2,3,4,5]
            let matches = Scheduler.roundRobinDoubles(1, row: teams)
            expect(matches.count).to(equal(5))
            expect("\(matches[0])").to(equal("(1, 1, Optional(3), Optional(4), Optional(2), Optional(5))"))
            expect("\(matches[1])").to(equal("(2, 2, Optional(2), Optional(3), Optional(1), Optional(4))"))
            expect("\(matches[2])").to(equal("(3, 3, Optional(1), Optional(2), Optional(5), Optional(3))"))
            expect("\(matches[3])").to(equal("(4, 4, Optional(5), Optional(1), Optional(4), Optional(2))"))
            expect("\(matches[4])").to(equal("(5, 5, Optional(4), Optional(5), Optional(3), Optional(1))"))
        }
        
        it("schedules round robin doubles with 06 individuals where 6 does not play") {
            let teams : [Int?] = [1,2,3,4,5,6]
            let matches = Scheduler.roundRobinDoubles(1, row: teams)
            expect(matches.count).to(equal(5))
            expect("\(matches[0])").to(equal("(1, 1, Optional(3), Optional(4), Optional(2), Optional(5))"))
            expect("\(matches[1])").to(equal("(2, 2, Optional(2), Optional(3), Optional(1), Optional(4))"))
            expect("\(matches[2])").to(equal("(3, 3, Optional(1), Optional(2), Optional(5), Optional(3))"))
            expect("\(matches[3])").to(equal("(4, 4, Optional(5), Optional(1), Optional(4), Optional(2))"))
            expect("\(matches[4])").to(equal("(5, 5, Optional(4), Optional(5), Optional(3), Optional(1))"))
        }
        
        it("schedules round robin doubles with 07 individuals") {
            let teams : [Int?] = [1,2,3,4,5,6,7]
            let matches = Scheduler.roundRobinDoubles(1, row: teams)
            expect(matches.count).to(equal(7))
            expect("\(matches[0])").to(equal("(1, 1, Optional(4), Optional(5), Optional(3), Optional(6))"))
            expect("\(matches[1])").to(equal("(2, 2, Optional(3), Optional(4), Optional(2), Optional(5))"))
            expect("\(matches[2])").to(equal("(3, 3, Optional(2), Optional(3), Optional(1), Optional(4))"))
            expect("\(matches[3])").to(equal("(4, 4, Optional(1), Optional(2), Optional(7), Optional(3))"))
            expect("\(matches[4])").to(equal("(5, 5, Optional(7), Optional(1), Optional(6), Optional(2))"))
            expect("\(matches[5])").to(equal("(6, 6, Optional(6), Optional(7), Optional(5), Optional(1))"))
            expect("\(matches[6])").to(equal("(7, 7, Optional(5), Optional(6), Optional(4), Optional(7))"))
        }
        
        it("schedules round robin doubles with 08 individuals") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8]
            let matches = Scheduler.roundRobinDoubles(1, row: teams)
            expect(matches.count).to(equal(14))
            expect("\(matches[00])").to(equal("(1, 1, Optional(4), Optional(5), Optional(3), Optional(6))"))
            expect("\(matches[01])").to(equal("(1, 2, Optional(2), Optional(7), Optional(1), Optional(8))"))
            expect("\(matches[02])").to(equal("(2, 3, Optional(3), Optional(4), Optional(2), Optional(5))"))
            expect("\(matches[03])").to(equal("(2, 4, Optional(1), Optional(6), Optional(7), Optional(8))"))
            expect("\(matches[04])").to(equal("(3, 5, Optional(2), Optional(3), Optional(1), Optional(4))"))
            expect("\(matches[05])").to(equal("(3, 6, Optional(7), Optional(5), Optional(6), Optional(8))"))
            expect("\(matches[06])").to(equal("(4, 7, Optional(1), Optional(2), Optional(7), Optional(3))"))
            expect("\(matches[07])").to(equal("(4, 8, Optional(6), Optional(4), Optional(5), Optional(8))"))
            expect("\(matches[08])").to(equal("(5, 9, Optional(7), Optional(1), Optional(6), Optional(2))"))
            expect("\(matches[09])").to(equal("(5, 10, Optional(5), Optional(3), Optional(4), Optional(8))"))
            expect("\(matches[10])").to(equal("(6, 11, Optional(6), Optional(7), Optional(5), Optional(1))"))
            expect("\(matches[11])").to(equal("(6, 12, Optional(4), Optional(2), Optional(3), Optional(8))"))
            expect("\(matches[12])").to(equal("(7, 13, Optional(5), Optional(6), Optional(4), Optional(7))"))
            expect("\(matches[13])").to(equal("(7, 14, Optional(3), Optional(1), Optional(2), Optional(8))"))
        }
        
        it("schedules round robin doubles with 09 individuals") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9]
            let matches = Scheduler.roundRobinDoubles(1, row: teams)
            expect(matches.count).to(equal(18))
            expect("\(matches[00])").to(equal("(1, 1, Optional(5), Optional(6), Optional(4), Optional(7))"))
            expect("\(matches[01])").to(equal("(1, 2, Optional(3), Optional(8), Optional(2), Optional(9))"))
            expect("\(matches[02])").to(equal("(2, 3, Optional(4), Optional(5), Optional(3), Optional(6))"))
            expect("\(matches[03])").to(equal("(2, 4, Optional(2), Optional(7), Optional(1), Optional(8))"))
            expect("\(matches[04])").to(equal("(3, 5, Optional(3), Optional(4), Optional(2), Optional(5))"))
            expect("\(matches[05])").to(equal("(3, 6, Optional(1), Optional(6), Optional(9), Optional(7))"))
            expect("\(matches[06])").to(equal("(4, 7, Optional(2), Optional(3), Optional(1), Optional(4))"))
            expect("\(matches[07])").to(equal("(4, 8, Optional(9), Optional(5), Optional(8), Optional(6))"))
            expect("\(matches[08])").to(equal("(5, 9, Optional(1), Optional(2), Optional(9), Optional(3))"))
            expect("\(matches[09])").to(equal("(5, 10, Optional(8), Optional(4), Optional(7), Optional(5))"))
            expect("\(matches[10])").to(equal("(6, 11, Optional(9), Optional(1), Optional(8), Optional(2))"))
            expect("\(matches[11])").to(equal("(6, 12, Optional(7), Optional(3), Optional(6), Optional(4))"))
            expect("\(matches[12])").to(equal("(7, 13, Optional(8), Optional(9), Optional(7), Optional(1))"))
            expect("\(matches[13])").to(equal("(7, 14, Optional(6), Optional(2), Optional(5), Optional(3))"))
            expect("\(matches[14])").to(equal("(8, 15, Optional(7), Optional(8), Optional(6), Optional(9))"))
            expect("\(matches[15])").to(equal("(8, 16, Optional(5), Optional(1), Optional(4), Optional(2))"))
            expect("\(matches[16])").to(equal("(9, 17, Optional(6), Optional(7), Optional(5), Optional(8))"))
            expect("\(matches[17])").to(equal("(9, 18, Optional(4), Optional(9), Optional(3), Optional(1))"))
        }
        
        it("schedules round robin doubles with 10 individuals where 10 does not play") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10]
            let matches = Scheduler.roundRobinDoubles(1, row: teams)
            expect(matches.count).to(equal(18))
            expect("\(matches[00])").to(equal("(1, 1, Optional(5), Optional(6), Optional(4), Optional(7))"))
            expect("\(matches[01])").to(equal("(1, 2, Optional(3), Optional(8), Optional(2), Optional(9))"))
            expect("\(matches[02])").to(equal("(2, 3, Optional(4), Optional(5), Optional(3), Optional(6))"))
            expect("\(matches[03])").to(equal("(2, 4, Optional(2), Optional(7), Optional(1), Optional(8))"))
            expect("\(matches[04])").to(equal("(3, 5, Optional(3), Optional(4), Optional(2), Optional(5))"))
            expect("\(matches[05])").to(equal("(3, 6, Optional(1), Optional(6), Optional(9), Optional(7))"))
            expect("\(matches[06])").to(equal("(4, 7, Optional(2), Optional(3), Optional(1), Optional(4))"))
            expect("\(matches[07])").to(equal("(4, 8, Optional(9), Optional(5), Optional(8), Optional(6))"))
            expect("\(matches[08])").to(equal("(5, 9, Optional(1), Optional(2), Optional(9), Optional(3))"))
            expect("\(matches[09])").to(equal("(5, 10, Optional(8), Optional(4), Optional(7), Optional(5))"))
            expect("\(matches[10])").to(equal("(6, 11, Optional(9), Optional(1), Optional(8), Optional(2))"))
            expect("\(matches[11])").to(equal("(6, 12, Optional(7), Optional(3), Optional(6), Optional(4))"))
            expect("\(matches[12])").to(equal("(7, 13, Optional(8), Optional(9), Optional(7), Optional(1))"))
            expect("\(matches[13])").to(equal("(7, 14, Optional(6), Optional(2), Optional(5), Optional(3))"))
            expect("\(matches[14])").to(equal("(8, 15, Optional(7), Optional(8), Optional(6), Optional(9))"))
            expect("\(matches[15])").to(equal("(8, 16, Optional(5), Optional(1), Optional(4), Optional(2))"))
            expect("\(matches[16])").to(equal("(9, 17, Optional(6), Optional(7), Optional(5), Optional(8))"))
            expect("\(matches[17])").to(equal("(9, 18, Optional(4), Optional(9), Optional(3), Optional(1))"))
        }
        
        it("schedules round robin doubles with 11 individuals ") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11]
            let matches = Scheduler.roundRobinDoubles(1, row: teams)
            expect(matches.count).to(equal(22))
            expect("\(matches[00])").to(equal("(1, 1, Optional(6), Optional(7), Optional(5), Optional(8))"))
            expect("\(matches[01])").to(equal("(1, 2, Optional(4), Optional(9), Optional(3), Optional(10))"))
            expect("\(matches[02])").to(equal("(2, 3, Optional(5), Optional(6), Optional(4), Optional(7))"))
            expect("\(matches[03])").to(equal("(2, 4, Optional(3), Optional(8), Optional(2), Optional(9))"))
            expect("\(matches[04])").to(equal("(3, 5, Optional(4), Optional(5), Optional(3), Optional(6))"))
            expect("\(matches[05])").to(equal("(3, 6, Optional(2), Optional(7), Optional(1), Optional(8))"))
            expect("\(matches[06])").to(equal("(4, 7, Optional(3), Optional(4), Optional(2), Optional(5))"))
            expect("\(matches[07])").to(equal("(4, 8, Optional(1), Optional(6), Optional(11), Optional(7))"))
            expect("\(matches[08])").to(equal("(5, 9, Optional(2), Optional(3), Optional(1), Optional(4))"))
            expect("\(matches[09])").to(equal("(5, 10, Optional(11), Optional(5), Optional(10), Optional(6))"))
            expect("\(matches[10])").to(equal("(6, 11, Optional(1), Optional(2), Optional(11), Optional(3))"))
            expect("\(matches[11])").to(equal("(6, 12, Optional(10), Optional(4), Optional(9), Optional(5))"))
            expect("\(matches[12])").to(equal("(7, 13, Optional(11), Optional(1), Optional(10), Optional(2))"))
            expect("\(matches[13])").to(equal("(7, 14, Optional(9), Optional(3), Optional(8), Optional(4))"))
            expect("\(matches[14])").to(equal("(8, 15, Optional(10), Optional(11), Optional(9), Optional(1))"))
            expect("\(matches[15])").to(equal("(8, 16, Optional(8), Optional(2), Optional(7), Optional(3))"))
            expect("\(matches[16])").to(equal("(9, 17, Optional(9), Optional(10), Optional(8), Optional(11))"))
            expect("\(matches[17])").to(equal("(9, 18, Optional(7), Optional(1), Optional(6), Optional(2))"))
            expect("\(matches[18])").to(equal("(10, 19, Optional(8), Optional(9), Optional(7), Optional(10))"))
            expect("\(matches[19])").to(equal("(10, 20, Optional(6), Optional(11), Optional(5), Optional(1))"))
            expect("\(matches[20])").to(equal("(11, 21, Optional(7), Optional(8), Optional(6), Optional(9))"))
            expect("\(matches[21])").to(equal("(11, 22, Optional(5), Optional(10), Optional(4), Optional(11))"))
        }
        
        
        it("ends this spec") {
            expect(1-1).to(equal(0))
        }
    }
}
