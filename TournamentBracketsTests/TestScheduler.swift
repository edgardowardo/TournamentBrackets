//
//  TestScheduler.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 17/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RealmSwift
import Quick
import Nimble
@testable import TournamentBrackets

class Test_01SchedulerSpec : QuickSpec {
    override func spec() {
        
        beforeEach {
        }
        
        afterEach {
        }
        
        it("schedules single elimination with 01 team") {
            let teams : [Int?] = [1]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(0))
        }
        
        it("schedules single elimination with 02 teams") {
            let teams : [Int?] = [1,2]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(1))
            let first = matches.first
            if let f = first {
                expect(f.info).to(equal("1.1.1v2"))
            }
        }
        
        it("schedules single elimination with 03 teams") {
            let teams : [Int?] = [1,2,3]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(3))
            expect(matches[0].info).to(equal("2.3.W1v1"))
            expect(matches[1].info).to(equal("1.1.2v3"))
            expect(matches[2].info).to(equal("1.2.1vB"))
        }
        
        it("schedules single elimination with 04 teams") {
            let teams : [Int?] = [1,2,3,4]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(3))
            expect(matches[0].info).to(equal("2.3.W1vW2"))
            expect(matches[1].info).to(equal("1.1.2v3"))
            expect(matches[2].info).to(equal("1.2.1v4"))
        }
        
        it("schedules single elimination with 05 teams") {
            let teams : [Int?] = [1,2,3,4,5]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(7))
            expect(matches[0].info).to(equal("3.7.W5vW6"))
            expect(matches[1].info).to(equal("2.5.3v2"))
            expect(matches[2].info).to(equal("2.6.W1v1"))
            expect(matches[3].info).to(equal("1.1.4v5"))
            expect(matches[4].info).to(equal("1.2.3vB"))
            expect(matches[5].info).to(equal("1.3.2vB"))
            expect(matches[6].info).to(equal("1.4.1vB"))
        }
        
        it("schedules single elimination with 06 teams") {
            let teams : [Int?] = [1,2,3,4,5,6]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(7))
            expect(matches[0].info).to(equal("3.7.W5vW6"))
            expect(matches[1].info).to(equal("2.5.W2v2"))
            expect(matches[2].info).to(equal("2.6.W1v1"))
            expect(matches[3].info).to(equal("1.1.4v5"))
            expect(matches[4].info).to(equal("1.2.3v6"))
            expect(matches[5].info).to(equal("1.3.2vB"))
            expect(matches[6].info).to(equal("1.4.1vB"))
        }
        
        it("schedules single elimination with 07 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(7))
            expect(matches[0].info).to(equal("3.7.W5vW6"))
            expect(matches[1].info).to(equal("2.5.W2vW3"))
            expect(matches[2].info).to(equal("2.6.W1v1"))
            expect(matches[3].info).to(equal("1.1.4v5"))
            expect(matches[4].info).to(equal("1.2.3v6"))
            expect(matches[5].info).to(equal("1.3.2v7"))
            expect(matches[6].info).to(equal("1.4.1vB"))
        }
        
        it("schedules single elimination with 08 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(7))
            expect(matches[0].info).to(equal("3.7.W5vW6"))
            expect(matches[1].info).to(equal("2.5.W2vW3"))
            expect(matches[2].info).to(equal("2.6.W1vW4"))
            expect(matches[3].info).to(equal("1.1.4v5"))
            expect(matches[4].info).to(equal("1.2.3v6"))
            expect(matches[5].info).to(equal("1.3.2v7"))
            expect(matches[6].info).to(equal("1.4.1v8"))
        }
        
        it("schedules single elimination with 09 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(15))
            expect(matches[00].info).to(equal("4.15.W13vW14"))
            expect(matches[01].info).to(equal("3.13.W10vW11"))
            expect(matches[02].info).to(equal("3.14.W9vW12"))
            expect(matches[03].info).to(equal("2.9.5v4"))
            expect(matches[04].info).to(equal("2.10.6v3"))
            expect(matches[05].info).to(equal("2.11.7v2"))
            expect(matches[06].info).to(equal("2.12.W1v1"))
            expect(matches[07].info).to(equal("1.1.8v9"))
            expect(matches[08].info).to(equal("1.2.7vB"))
            expect(matches[09].info).to(equal("1.3.6vB"))
            expect(matches[10].info).to(equal("1.4.5vB"))
            expect(matches[11].info).to(equal("1.5.4vB"))
            expect(matches[12].info).to(equal("1.6.3vB"))
            expect(matches[13].info).to(equal("1.7.2vB"))
            expect(matches[14].info).to(equal("1.8.1vB"))
        }
        
        it("schedules single elimination with 10 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(15))
            expect(matches[00].info).to(equal("4.15.W13vW14"))
            expect(matches[01].info).to(equal("3.13.W10vW11"))
            expect(matches[02].info).to(equal("3.14.W9vW12"))
            expect(matches[03].info).to(equal("2.9.5v4"))
            expect(matches[04].info).to(equal("2.10.6v3"))
            expect(matches[05].info).to(equal("2.11.W2v2"))
            expect(matches[06].info).to(equal("2.12.W1v1"))
            expect(matches[07].info).to(equal("1.1.8v9"))
            expect(matches[08].info).to(equal("1.2.7v10"))
            expect(matches[09].info).to(equal("1.3.6vB"))
            expect(matches[10].info).to(equal("1.4.5vB"))
            expect(matches[11].info).to(equal("1.5.4vB"))
            expect(matches[12].info).to(equal("1.6.3vB"))
            expect(matches[13].info).to(equal("1.7.2vB"))
            expect(matches[14].info).to(equal("1.8.1vB"))
        }
        
        it("schedules single elimination with 11 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(15))
            expect(matches[00].info).to(equal("4.15.W13vW14"))
            expect(matches[01].info).to(equal("3.13.W10vW11"))
            expect(matches[02].info).to(equal("3.14.W9vW12"))
            expect(matches[03].info).to(equal("2.9.5v4"))
            expect(matches[04].info).to(equal("2.10.W3v3"))
            expect(matches[05].info).to(equal("2.11.W2v2"))
            expect(matches[06].info).to(equal("2.12.W1v1"))
            expect(matches[07].info).to(equal("1.1.8v9"))
            expect(matches[08].info).to(equal("1.2.7v10"))
            expect(matches[09].info).to(equal("1.3.6v11"))
            expect(matches[10].info).to(equal("1.4.5vB"))
            expect(matches[11].info).to(equal("1.5.4vB"))
            expect(matches[12].info).to(equal("1.6.3vB"))
            expect(matches[13].info).to(equal("1.7.2vB"))
            expect(matches[14].info).to(equal("1.8.1vB"))
        }
        
        it("schedules single elimination with 12 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(15))
            expect(matches[00].info).to(equal("4.15.W13vW14"))
            expect(matches[01].info).to(equal("3.13.W10vW11"))
            expect(matches[02].info).to(equal("3.14.W9vW12"))
            expect(matches[03].info).to(equal("2.9.W4v4"))
            expect(matches[04].info).to(equal("2.10.W3v3"))
            expect(matches[05].info).to(equal("2.11.W2v2"))
            expect(matches[06].info).to(equal("2.12.W1v1"))
            expect(matches[07].info).to(equal("1.1.8v9"))
            expect(matches[08].info).to(equal("1.2.7v10"))
            expect(matches[09].info).to(equal("1.3.6v11"))
            expect(matches[10].info).to(equal("1.4.5v12"))
            expect(matches[11].info).to(equal("1.5.4vB"))
            expect(matches[12].info).to(equal("1.6.3vB"))
            expect(matches[13].info).to(equal("1.7.2vB"))
            expect(matches[14].info).to(equal("1.8.1vB"))
        }
        
        it("schedules single elimination with 13 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12,13]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(15))
            expect(matches[00].info).to(equal("4.15.W13vW14"))
            expect(matches[01].info).to(equal("3.13.W10vW11"))
            expect(matches[02].info).to(equal("3.14.W9vW12"))
            expect(matches[03].info).to(equal("2.9.W4vW5"))
            expect(matches[04].info).to(equal("2.10.W3v3"))
            expect(matches[05].info).to(equal("2.11.W2v2"))
            expect(matches[06].info).to(equal("2.12.W1v1"))
            expect(matches[07].info).to(equal("1.1.8v9"))
            expect(matches[08].info).to(equal("1.2.7v10"))
            expect(matches[09].info).to(equal("1.3.6v11"))
            expect(matches[10].info).to(equal("1.4.5v12"))
            expect(matches[11].info).to(equal("1.5.4v13"))
            expect(matches[12].info).to(equal("1.6.3vB"))
            expect(matches[13].info).to(equal("1.7.2vB"))
            expect(matches[14].info).to(equal("1.8.1vB"))
        }

        it("schedules single elimination with 14 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(15))
            expect(matches[00].info).to(equal("4.15.W13vW14"))
            expect(matches[01].info).to(equal("3.13.W10vW11"))
            expect(matches[02].info).to(equal("3.14.W9vW12"))
            expect(matches[03].info).to(equal("2.9.W4vW5"))
            expect(matches[04].info).to(equal("2.10.W3vW6"))
            expect(matches[05].info).to(equal("2.11.W2v2"))
            expect(matches[06].info).to(equal("2.12.W1v1"))
            expect(matches[07].info).to(equal("1.1.8v9"))
            expect(matches[08].info).to(equal("1.2.7v10"))
            expect(matches[09].info).to(equal("1.3.6v11"))
            expect(matches[10].info).to(equal("1.4.5v12"))
            expect(matches[11].info).to(equal("1.5.4v13"))
            expect(matches[12].info).to(equal("1.6.3v14"))
            expect(matches[13].info).to(equal("1.7.2vB"))
            expect(matches[14].info).to(equal("1.8.1vB"))
        }
        
        it("schedules single elimination with 15 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(15))
            expect(matches[00].info).to(equal("4.15.W13vW14"))
            expect(matches[01].info).to(equal("3.13.W10vW11"))
            expect(matches[02].info).to(equal("3.14.W9vW12"))
            expect(matches[03].info).to(equal("2.9.W4vW5"))
            expect(matches[04].info).to(equal("2.10.W3vW6"))
            expect(matches[05].info).to(equal("2.11.W2vW7"))
            expect(matches[06].info).to(equal("2.12.W1v1"))
            expect(matches[07].info).to(equal("1.1.8v9"))
            expect(matches[08].info).to(equal("1.2.7v10"))
            expect(matches[09].info).to(equal("1.3.6v11"))
            expect(matches[10].info).to(equal("1.4.5v12"))
            expect(matches[11].info).to(equal("1.5.4v13"))
            expect(matches[12].info).to(equal("1.6.3v14"))
            expect(matches[13].info).to(equal("1.7.2v15"))
            expect(matches[14].info).to(equal("1.8.1vB"))
        }
        
        it("schedules single elimination with 16 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(15))
            expect(matches[00].info).to(equal("4.15.W13vW14"))
            expect(matches[01].info).to(equal("3.13.W10vW11"))
            expect(matches[02].info).to(equal("3.14.W9vW12"))
            expect(matches[03].info).to(equal("2.9.W4vW5"))
            expect(matches[04].info).to(equal("2.10.W3vW6"))
            expect(matches[05].info).to(equal("2.11.W2vW7"))
            expect(matches[06].info).to(equal("2.12.W1vW8"))
            expect(matches[07].info).to(equal("1.1.8v9"))
            expect(matches[08].info).to(equal("1.2.7v10"))
            expect(matches[09].info).to(equal("1.3.6v11"))
            expect(matches[10].info).to(equal("1.4.5v12"))
            expect(matches[11].info).to(equal("1.5.4v13"))
            expect(matches[12].info).to(equal("1.6.3v14"))
            expect(matches[13].info).to(equal("1.7.2v15"))
            expect(matches[14].info).to(equal("1.8.1v16"))
        }
        
        it("schedules single elimination with 17 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(31))
            expect(matches[00].info).to(equal("5.31.W29vW30"))
            expect(matches[01].info).to(equal("4.29.W26vW27"))
            expect(matches[02].info).to(equal("4.30.W25vW28"))
            expect(matches[03].info).to(equal("3.25.W20vW21"))
            expect(matches[04].info).to(equal("3.26.W19vW22"))
            expect(matches[05].info).to(equal("3.27.W18vW23"))
            expect(matches[06].info).to(equal("3.28.W17vW24"))
            expect(matches[07].info).to(equal("2.17.9v8"))
            expect(matches[08].info).to(equal("2.18.10v7"))
            expect(matches[09].info).to(equal("2.19.11v6"))
            expect(matches[10].info).to(equal("2.20.12v5"))
            expect(matches[11].info).to(equal("2.21.13v4"))
            expect(matches[12].info).to(equal("2.22.14v3"))
            expect(matches[13].info).to(equal("2.23.15v2"))
            expect(matches[14].info).to(equal("2.24.W1v1"))
            expect(matches[15].info).to(equal("1.1.16v17"))
            expect(matches[16].info).to(equal("1.2.15vB"))
            expect(matches[17].info).to(equal("1.3.14vB"))
            expect(matches[18].info).to(equal("1.4.13vB"))
            expect(matches[19].info).to(equal("1.5.12vB"))
            expect(matches[20].info).to(equal("1.6.11vB"))
            expect(matches[21].info).to(equal("1.7.10vB"))
            expect(matches[22].info).to(equal("1.8.9vB"))
            expect(matches[23].info).to(equal("1.9.8vB"))
            expect(matches[24].info).to(equal("1.10.7vB"))
            expect(matches[25].info).to(equal("1.11.6vB"))
            expect(matches[26].info).to(equal("1.12.5vB"))
            expect(matches[27].info).to(equal("1.13.4vB"))
            expect(matches[28].info).to(equal("1.14.3vB"))
            expect(matches[29].info).to(equal("1.15.2vB"))
            expect(matches[30].info).to(equal("1.16.1vB"))
        }
        
        
        it("ends this spec") {
            expect(1-1).to(equal(0))
        }
    }
}
