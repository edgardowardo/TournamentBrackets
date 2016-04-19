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
        
        ///
        /// SINGLE ELIMINATION
        ///
        
        it("schedules single elimination with 00 team") {
            let teams : [Int?] = []
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(0))
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
                expect(f.info).to(equal("R1.1.1v2"))
            }
        }
        
        it("schedules single elimination with 03 teams") {
            let teams : [Int?] = [1,2,3]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(3))
            expect(matches[0].info).to(equal("R1.1.2v3"))
            expect(matches[1].info).to(equal("R1.2.1vB"))
            expect(matches[2].info).to(equal("R2.3.W1v1"))
        }
        
        it("schedules single elimination with 04 teams") {
            let teams : [Int?] = [1,2,3,4]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(3))
            expect(matches[0].info).to(equal("R1.1.2v3"))
            expect(matches[1].info).to(equal("R1.2.1v4"))
            expect(matches[2].info).to(equal("R2.3.W1vW2"))
        }
        
        it("schedules single elimination with 05 teams") {
            let teams : [Int?] = [1,2,3,4,5]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(7))
            expect(matches[0].info).to(equal("R1.1.4v5"))
            expect(matches[1].info).to(equal("R1.2.3vB"))
            expect(matches[2].info).to(equal("R1.3.2vB"))
            expect(matches[3].info).to(equal("R1.4.1vB"))
            expect(matches[4].info).to(equal("R2.5.3v2"))
            expect(matches[5].info).to(equal("R2.6.W1v1"))
            expect(matches[6].info).to(equal("R3.7.W5vW6"))
        }
        
        it("schedules single elimination with 06 teams") {
            let teams : [Int?] = [1,2,3,4,5,6]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(7))
            expect(matches[0].info).to(equal("R1.1.4v5"))
            expect(matches[1].info).to(equal("R1.2.3v6"))
            expect(matches[2].info).to(equal("R1.3.2vB"))
            expect(matches[3].info).to(equal("R1.4.1vB"))
            expect(matches[4].info).to(equal("R2.5.W2v2"))
            expect(matches[5].info).to(equal("R2.6.W1v1"))
            expect(matches[6].info).to(equal("R3.7.W5vW6"))
        }
        
        it("schedules single elimination with 07 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(7))
            expect(matches[0].info).to(equal("R1.1.4v5"))
            expect(matches[1].info).to(equal("R1.2.3v6"))
            expect(matches[2].info).to(equal("R1.3.2v7"))
            expect(matches[3].info).to(equal("R1.4.1vB"))
            expect(matches[4].info).to(equal("R2.5.W2vW3"))
            expect(matches[5].info).to(equal("R2.6.W1v1"))
            expect(matches[6].info).to(equal("R3.7.W5vW6"))
        }
        
        it("schedules single elimination with 08 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(7))
            expect(matches[0].info).to(equal("R1.1.4v5"))
            expect(matches[1].info).to(equal("R1.2.3v6"))
            expect(matches[2].info).to(equal("R1.3.2v7"))
            expect(matches[3].info).to(equal("R1.4.1v8"))
            expect(matches[4].info).to(equal("R2.5.W2vW3"))
            expect(matches[5].info).to(equal("R2.6.W1vW4"))
            expect(matches[6].info).to(equal("R3.7.W5vW6"))
        }
        
        it("schedules single elimination with 09 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(15))
            expect(matches[00].info).to(equal("R1.1.8v9"))
            expect(matches[01].info).to(equal("R1.2.7vB"))
            expect(matches[02].info).to(equal("R1.3.6vB"))
            expect(matches[03].info).to(equal("R1.4.5vB"))
            expect(matches[04].info).to(equal("R1.5.4vB"))
            expect(matches[05].info).to(equal("R1.6.3vB"))
            expect(matches[06].info).to(equal("R1.7.2vB"))
            expect(matches[07].info).to(equal("R1.8.1vB"))
            expect(matches[08].info).to(equal("R2.9.5v4"))
            expect(matches[09].info).to(equal("R2.10.6v3"))
            expect(matches[10].info).to(equal("R2.11.7v2"))
            expect(matches[11].info).to(equal("R2.12.W1v1"))
            expect(matches[12].info).to(equal("R3.13.W10vW11"))
            expect(matches[13].info).to(equal("R3.14.W9vW12"))
            expect(matches[14].info).to(equal("R4.15.W13vW14"))
            
        }
        
        it("schedules single elimination with 10 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(15))
            expect(matches[00].info).to(equal("R1.1.8v9"))
            expect(matches[01].info).to(equal("R1.2.7v10"))
            expect(matches[02].info).to(equal("R1.3.6vB"))
            expect(matches[03].info).to(equal("R1.4.5vB"))
            expect(matches[04].info).to(equal("R1.5.4vB"))
            expect(matches[05].info).to(equal("R1.6.3vB"))
            expect(matches[06].info).to(equal("R1.7.2vB"))
            expect(matches[07].info).to(equal("R1.8.1vB"))
            expect(matches[08].info).to(equal("R2.9.5v4"))
            expect(matches[09].info).to(equal("R2.10.6v3"))
            expect(matches[10].info).to(equal("R2.11.W2v2"))
            expect(matches[11].info).to(equal("R2.12.W1v1"))
            expect(matches[12].info).to(equal("R3.13.W10vW11"))
            expect(matches[13].info).to(equal("R3.14.W9vW12"))
            expect(matches[14].info).to(equal("R4.15.W13vW14"))
        }
        
        it("schedules single elimination with 11 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(15))
            expect(matches[00].info).to(equal("R1.1.8v9"))
            expect(matches[01].info).to(equal("R1.2.7v10"))
            expect(matches[02].info).to(equal("R1.3.6v11"))
            expect(matches[03].info).to(equal("R1.4.5vB"))
            expect(matches[04].info).to(equal("R1.5.4vB"))
            expect(matches[05].info).to(equal("R1.6.3vB"))
            expect(matches[06].info).to(equal("R1.7.2vB"))
            expect(matches[07].info).to(equal("R1.8.1vB"))
            expect(matches[08].info).to(equal("R2.9.5v4"))
            expect(matches[09].info).to(equal("R2.10.W3v3"))
            expect(matches[10].info).to(equal("R2.11.W2v2"))
            expect(matches[11].info).to(equal("R2.12.W1v1"))
            expect(matches[12].info).to(equal("R3.13.W10vW11"))
            expect(matches[13].info).to(equal("R3.14.W9vW12"))
            expect(matches[14].info).to(equal("R4.15.W13vW14"))
        }
        
        it("schedules single elimination with 12 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(15))
            expect(matches[00].info).to(equal("R1.1.8v9"))
            expect(matches[01].info).to(equal("R1.2.7v10"))
            expect(matches[02].info).to(equal("R1.3.6v11"))
            expect(matches[03].info).to(equal("R1.4.5v12"))
            expect(matches[04].info).to(equal("R1.5.4vB"))
            expect(matches[05].info).to(equal("R1.6.3vB"))
            expect(matches[06].info).to(equal("R1.7.2vB"))
            expect(matches[07].info).to(equal("R1.8.1vB"))
            expect(matches[08].info).to(equal("R2.9.W4v4"))
            expect(matches[09].info).to(equal("R2.10.W3v3"))
            expect(matches[10].info).to(equal("R2.11.W2v2"))
            expect(matches[11].info).to(equal("R2.12.W1v1"))
            expect(matches[12].info).to(equal("R3.13.W10vW11"))
            expect(matches[13].info).to(equal("R3.14.W9vW12"))
            expect(matches[14].info).to(equal("R4.15.W13vW14"))
        }
        
        it("schedules single elimination with 13 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12,13]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(15))
            expect(matches[00].info).to(equal("R1.1.8v9"))
            expect(matches[01].info).to(equal("R1.2.7v10"))
            expect(matches[02].info).to(equal("R1.3.6v11"))
            expect(matches[03].info).to(equal("R1.4.5v12"))
            expect(matches[04].info).to(equal("R1.5.4v13"))
            expect(matches[05].info).to(equal("R1.6.3vB"))
            expect(matches[06].info).to(equal("R1.7.2vB"))
            expect(matches[07].info).to(equal("R1.8.1vB"))
            expect(matches[08].info).to(equal("R2.9.W4vW5"))
            expect(matches[09].info).to(equal("R2.10.W3v3"))
            expect(matches[10].info).to(equal("R2.11.W2v2"))
            expect(matches[11].info).to(equal("R2.12.W1v1"))
            expect(matches[12].info).to(equal("R3.13.W10vW11"))
            expect(matches[13].info).to(equal("R3.14.W9vW12"))
            expect(matches[14].info).to(equal("R4.15.W13vW14"))
        }

        it("schedules single elimination with 14 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(15))
            expect(matches[00].info).to(equal("R1.1.8v9"))
            expect(matches[01].info).to(equal("R1.2.7v10"))
            expect(matches[02].info).to(equal("R1.3.6v11"))
            expect(matches[03].info).to(equal("R1.4.5v12"))
            expect(matches[04].info).to(equal("R1.5.4v13"))
            expect(matches[05].info).to(equal("R1.6.3v14"))
            expect(matches[06].info).to(equal("R1.7.2vB"))
            expect(matches[07].info).to(equal("R1.8.1vB"))
            expect(matches[08].info).to(equal("R2.9.W4vW5"))
            expect(matches[09].info).to(equal("R2.10.W3vW6"))
            expect(matches[10].info).to(equal("R2.11.W2v2"))
            expect(matches[11].info).to(equal("R2.12.W1v1"))
            expect(matches[12].info).to(equal("R3.13.W10vW11"))
            expect(matches[13].info).to(equal("R3.14.W9vW12"))
            expect(matches[14].info).to(equal("R4.15.W13vW14"))
        }
        
        it("schedules single elimination with 15 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(15))
            expect(matches[00].info).to(equal("R1.1.8v9"))
            expect(matches[01].info).to(equal("R1.2.7v10"))
            expect(matches[02].info).to(equal("R1.3.6v11"))
            expect(matches[03].info).to(equal("R1.4.5v12"))
            expect(matches[04].info).to(equal("R1.5.4v13"))
            expect(matches[05].info).to(equal("R1.6.3v14"))
            expect(matches[06].info).to(equal("R1.7.2v15"))
            expect(matches[07].info).to(equal("R1.8.1vB"))
            expect(matches[08].info).to(equal("R2.9.W4vW5"))
            expect(matches[09].info).to(equal("R2.10.W3vW6"))
            expect(matches[10].info).to(equal("R2.11.W2vW7"))
            expect(matches[11].info).to(equal("R2.12.W1v1"))
            expect(matches[12].info).to(equal("R3.13.W10vW11"))
            expect(matches[13].info).to(equal("R3.14.W9vW12"))
            expect(matches[14].info).to(equal("R4.15.W13vW14"))
        }
        
        it("schedules single elimination with 16 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(15))
            expect(matches[00].info).to(equal("R1.1.8v9"))
            expect(matches[01].info).to(equal("R1.2.7v10"))
            expect(matches[02].info).to(equal("R1.3.6v11"))
            expect(matches[03].info).to(equal("R1.4.5v12"))
            expect(matches[04].info).to(equal("R1.5.4v13"))
            expect(matches[05].info).to(equal("R1.6.3v14"))
            expect(matches[06].info).to(equal("R1.7.2v15"))
            expect(matches[07].info).to(equal("R1.8.1v16"))
            expect(matches[08].info).to(equal("R2.9.W4vW5"))
            expect(matches[09].info).to(equal("R2.10.W3vW6"))
            expect(matches[10].info).to(equal("R2.11.W2vW7"))
            expect(matches[11].info).to(equal("R2.12.W1vW8"))
            expect(matches[12].info).to(equal("R3.13.W10vW11"))
            expect(matches[13].info).to(equal("R3.14.W9vW12"))
            expect(matches[14].info).to(equal("R4.15.W13vW14"))
            
        }
        
        it("schedules single elimination with 17 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]
            let matches = Scheduler.singleElimination(1, row: teams)
            expect(matches.count).to(equal(31))
            expect(matches[00].info).to(equal("R1.1.16v17"))
            expect(matches[01].info).to(equal("R1.2.15vB"))
            expect(matches[02].info).to(equal("R1.3.14vB"))
            expect(matches[03].info).to(equal("R1.4.13vB"))
            expect(matches[04].info).to(equal("R1.5.12vB"))
            expect(matches[05].info).to(equal("R1.6.11vB"))
            expect(matches[06].info).to(equal("R1.7.10vB"))
            expect(matches[07].info).to(equal("R1.8.9vB"))
            expect(matches[08].info).to(equal("R1.9.8vB"))
            expect(matches[09].info).to(equal("R1.10.7vB"))
            expect(matches[10].info).to(equal("R1.11.6vB"))
            expect(matches[11].info).to(equal("R1.12.5vB"))
            expect(matches[12].info).to(equal("R1.13.4vB"))
            expect(matches[13].info).to(equal("R1.14.3vB"))
            expect(matches[14].info).to(equal("R1.15.2vB"))
            expect(matches[15].info).to(equal("R1.16.1vB"))
            expect(matches[16].info).to(equal("R2.17.9v8"))
            expect(matches[17].info).to(equal("R2.18.10v7"))
            expect(matches[18].info).to(equal("R2.19.11v6"))
            expect(matches[19].info).to(equal("R2.20.12v5"))
            expect(matches[20].info).to(equal("R2.21.13v4"))
            expect(matches[21].info).to(equal("R2.22.14v3"))
            expect(matches[22].info).to(equal("R2.23.15v2"))
            expect(matches[23].info).to(equal("R2.24.W1v1"))
            expect(matches[24].info).to(equal("R3.25.W20vW21"))
            expect(matches[25].info).to(equal("R3.26.W19vW22"))
            expect(matches[26].info).to(equal("R3.27.W18vW23"))
            expect(matches[27].info).to(equal("R3.28.W17vW24"))
            expect(matches[28].info).to(equal("R4.29.W26vW27"))
            expect(matches[29].info).to(equal("R4.30.W25vW28"))
            expect(matches[30].info).to(equal("R5.31.W29vW30"))
        }
        
        ///
        /// DOUBLE ELIMINATION
        ///
        
        it("schedules double elimination with 0 teams") {
            let teams : [Int?] = []
            let matches = Scheduler.doubleElimination(1, row: teams)
            expect(matches.count).to(equal(0))
        }
        
        it("schedules double elimination with 1 teams") {
            let teams : [Int?] = [1]
            let matches = Scheduler.doubleElimination(1, row: teams)
            expect(matches.count).to(equal(0))
        }

        it("schedules double elimination with 2 teams") {
            let teams : [Int?] = [1,2]
            let matches = Scheduler.doubleElimination(1, row: teams)
            expect(matches.count).to(equal(6))
            expect(matches[00].info).to(equal("R1.1.2vB"))
            expect(matches[01].info).to(equal("R1.2.1vB"))
            expect(matches[02].info).to(equal("R2.3.2v1"))
            expect(matches[03].info).to(equal("LR2.4.L1vL2"))
            expect(matches[04].info).to(equal("LR3.5.L3vW4"))
            expect(matches[05].info).to(equal("R3.6.W3vW5"))
        }
        
        it("schedules double elimination with 3 teams") {
            let teams : [Int?] = [1,2,3]
            let matches = Scheduler.doubleElimination(1, row: teams)
            expect(matches.count).to(equal(6))
            expect(matches[00].info).to(equal("R1.1.2v3"))
            expect(matches[01].info).to(equal("R1.2.1vB"))
            expect(matches[02].info).to(equal("R2.3.W1v1"))
            expect(matches[03].info).to(equal("LR2.4.L1vL2"))
            expect(matches[04].info).to(equal("LR3.5.L3vW4"))
            expect(matches[05].info).to(equal("R3.6.W3vW5"))
        }
        
        it("schedules double elimination with 4 teams") {
            let teams : [Int?] = [1,2,3,4]
            let matches = Scheduler.doubleElimination(1, row: teams)
            expect(matches.count).to(equal(6))
            expect(matches[00].info).to(equal("R1.1.2v3"))
            expect(matches[01].info).to(equal("R1.2.1v4"))
            expect(matches[02].info).to(equal("R2.3.W1vW2"))
            expect(matches[03].info).to(equal("LR2.4.L1vL2"))
            expect(matches[04].info).to(equal("LR3.5.L3vW4"))
            expect(matches[05].info).to(equal("R3.6.W3vW5"))
        }
        
        it("schedules double elimination with 5 teams") {
            let teams : [Int?] = [1,2,3,4,5]
            let matches = Scheduler.doubleElimination(1, row: teams)
            expect(matches.count).to(equal(14))
            expect(matches[00].info).to(equal("R1.1.4v5"))
            expect(matches[01].info).to(equal("R1.2.3vB"))
            expect(matches[02].info).to(equal("R1.3.2vB"))
            expect(matches[03].info).to(equal("R1.4.1vB"))
            expect(matches[04].info).to(equal("R2.5.3v2"))
            expect(matches[05].info).to(equal("R2.6.W1v1"))
            expect(matches[06].info).to(equal("R3.7.W5vW6"))
            expect(matches[07].info).to(equal("LR2.8.L1vL2"))
            expect(matches[08].info).to(equal("LR2.9.L3vL4"))
            expect(matches[09].info).to(equal("LR3.10.L5vW8"))
            expect(matches[10].info).to(equal("LR3.11.L6vW9"))
            expect(matches[11].info).to(equal("LR4.12.W10vW11"))
            expect(matches[12].info).to(equal("LR5.13.L7vW12"))
            expect(matches[13].info).to(equal("R4.14.W7vW13"))
        }

        it("schedules double elimination with 6 teams") {
            let teams : [Int?] = [1,2,3,4,5,6]
            let matches = Scheduler.doubleElimination(1, row: teams)
            expect(matches.count).to(equal(14))
            expect(matches[00].info).to(equal("R1.1.4v5"))
            expect(matches[01].info).to(equal("R1.2.3v6"))
            expect(matches[02].info).to(equal("R1.3.2vB"))
            expect(matches[03].info).to(equal("R1.4.1vB"))
            expect(matches[04].info).to(equal("R2.5.W2v2"))
            expect(matches[05].info).to(equal("R2.6.W1v1"))
            expect(matches[06].info).to(equal("R3.7.W5vW6"))
            expect(matches[07].info).to(equal("LR2.8.L1vL2"))
            expect(matches[08].info).to(equal("LR2.9.L3vL4"))
            expect(matches[09].info).to(equal("LR3.10.L5vW8"))
            expect(matches[10].info).to(equal("LR3.11.L6vW9"))
            expect(matches[11].info).to(equal("LR4.12.W10vW11"))
            expect(matches[12].info).to(equal("LR5.13.L7vW12"))
            expect(matches[13].info).to(equal("R4.14.W7vW13"))
        }
        
        
        it("schedules double elimination with 7 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7]
            let matches = Scheduler.doubleElimination(1, row: teams)
            expect(matches.count).to(equal(14))
            expect(matches[00].info).to(equal("R1.1.4v5"))
            expect(matches[01].info).to(equal("R1.2.3v6"))
            expect(matches[02].info).to(equal("R1.3.2v7"))
            expect(matches[03].info).to(equal("R1.4.1vB"))
            expect(matches[04].info).to(equal("R2.5.W2vW3"))
            expect(matches[05].info).to(equal("R2.6.W1v1"))
            expect(matches[06].info).to(equal("R3.7.W5vW6"))
            expect(matches[07].info).to(equal("LR2.8.L1vL2"))
            expect(matches[08].info).to(equal("LR2.9.L3vL4"))
            expect(matches[09].info).to(equal("LR3.10.L5vW8"))
            expect(matches[10].info).to(equal("LR3.11.L6vW9"))
            expect(matches[11].info).to(equal("LR4.12.W10vW11"))
            expect(matches[12].info).to(equal("LR5.13.L7vW12"))
            expect(matches[13].info).to(equal("R4.14.W7vW13"))
        }
        
        it("schedules double elimination with 8 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8]
            let matches = Scheduler.doubleElimination(1, row: teams)
            expect(matches.count).to(equal(14))
            expect(matches[00].info).to(equal("R1.1.4v5"))
            expect(matches[01].info).to(equal("R1.2.3v6"))
            expect(matches[02].info).to(equal("R1.3.2v7"))
            expect(matches[03].info).to(equal("R1.4.1v8"))
            expect(matches[04].info).to(equal("R2.5.W2vW3"))
            expect(matches[05].info).to(equal("R2.6.W1vW4"))
            expect(matches[06].info).to(equal("R3.7.W5vW6"))
            expect(matches[07].info).to(equal("LR2.8.L1vL2"))
            expect(matches[08].info).to(equal("LR2.9.L3vL4"))
            expect(matches[09].info).to(equal("LR3.10.L5vW8"))
            expect(matches[10].info).to(equal("LR3.11.L6vW9"))
            expect(matches[11].info).to(equal("LR4.12.W10vW11"))
            expect(matches[12].info).to(equal("LR5.13.L7vW12"))
            expect(matches[13].info).to(equal("R4.14.W7vW13"))
        }
        
        
        it("schedules double elimination with 9 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9]
            let matches = Scheduler.doubleElimination(1, row: teams)
            expect(matches.count).to(equal(30))
            expect(matches[00].info).to(equal("R1.1.8v9"))
            expect(matches[01].info).to(equal("R1.2.7vB"))
            expect(matches[02].info).to(equal("R1.3.6vB"))
            expect(matches[03].info).to(equal("R1.4.5vB"))
            expect(matches[04].info).to(equal("R1.5.4vB"))
            expect(matches[05].info).to(equal("R1.6.3vB"))
            expect(matches[06].info).to(equal("R1.7.2vB"))
            expect(matches[07].info).to(equal("R1.8.1vB"))
            expect(matches[08].info).to(equal("R2.9.5v4"))
            expect(matches[09].info).to(equal("R2.10.6v3"))
            expect(matches[10].info).to(equal("R2.11.7v2"))
            expect(matches[11].info).to(equal("R2.12.W1v1"))
            expect(matches[12].info).to(equal("R3.13.W10vW11"))
            expect(matches[13].info).to(equal("R3.14.W9vW12"))
            expect(matches[14].info).to(equal("R4.15.W13vW14"))
            expect(matches[15].info).to(equal("LR2.16.L1vL2"))
            expect(matches[16].info).to(equal("LR2.17.L3vL4"))
            expect(matches[17].info).to(equal("LR2.18.L5vL6"))
            expect(matches[18].info).to(equal("LR2.19.L7vL8"))
            expect(matches[19].info).to(equal("LR3.20.L9vW16"))
            expect(matches[20].info).to(equal("LR3.21.L10vW17"))
            expect(matches[21].info).to(equal("LR3.22.L11vW18"))
            expect(matches[22].info).to(equal("LR3.23.L12vW19"))
            expect(matches[23].info).to(equal("LR4.24.W20vW21"))
            expect(matches[24].info).to(equal("LR4.25.W22vW23"))
            expect(matches[25].info).to(equal("LR5.26.L13vW24"))
            expect(matches[26].info).to(equal("LR5.27.L14vW25"))
            expect(matches[27].info).to(equal("LR6.28.W26vW27"))
            expect(matches[28].info).to(equal("LR7.29.L15vW28"))
            expect(matches[29].info).to(equal("R5.30.W15vW29"))
        }
        
        it("schedules double elimination with 10 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10]
            let matches = Scheduler.doubleElimination(1, row: teams)
            expect(matches.count).to(equal(30))
            expect(matches[00].info).to(equal("R1.1.8v9"))
            expect(matches[01].info).to(equal("R1.2.7v10"))
            expect(matches[02].info).to(equal("R1.3.6vB"))
            expect(matches[03].info).to(equal("R1.4.5vB"))
            expect(matches[04].info).to(equal("R1.5.4vB"))
            expect(matches[05].info).to(equal("R1.6.3vB"))
            expect(matches[06].info).to(equal("R1.7.2vB"))
            expect(matches[07].info).to(equal("R1.8.1vB"))
            expect(matches[08].info).to(equal("R2.9.5v4"))
            expect(matches[09].info).to(equal("R2.10.6v3"))
            expect(matches[10].info).to(equal("R2.11.W2v2"))
            expect(matches[11].info).to(equal("R2.12.W1v1"))
            expect(matches[12].info).to(equal("R3.13.W10vW11"))
            expect(matches[13].info).to(equal("R3.14.W9vW12"))
            expect(matches[14].info).to(equal("R4.15.W13vW14"))
            expect(matches[15].info).to(equal("LR2.16.L1vL2"))
            expect(matches[16].info).to(equal("LR2.17.L3vL4"))
            expect(matches[17].info).to(equal("LR2.18.L5vL6"))
            expect(matches[18].info).to(equal("LR2.19.L7vL8"))
            expect(matches[19].info).to(equal("LR3.20.L9vW16"))
            expect(matches[20].info).to(equal("LR3.21.L10vW17"))
            expect(matches[21].info).to(equal("LR3.22.L11vW18"))
            expect(matches[22].info).to(equal("LR3.23.L12vW19"))
            expect(matches[23].info).to(equal("LR4.24.W20vW21"))
            expect(matches[24].info).to(equal("LR4.25.W22vW23"))
            expect(matches[25].info).to(equal("LR5.26.L13vW24"))
            expect(matches[26].info).to(equal("LR5.27.L14vW25"))
            expect(matches[27].info).to(equal("LR6.28.W26vW27"))
            expect(matches[28].info).to(equal("LR7.29.L15vW28"))
            expect(matches[29].info).to(equal("R5.30.W15vW29"))
        }
        
        it("schedules double elimination with 11 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11]
            let matches = Scheduler.doubleElimination(1, row: teams)
            expect(matches.count).to(equal(30))
            expect(matches[00].info).to(equal("R1.1.8v9"))
            expect(matches[01].info).to(equal("R1.2.7v10"))
            expect(matches[02].info).to(equal("R1.3.6v11"))
            expect(matches[03].info).to(equal("R1.4.5vB"))
            expect(matches[04].info).to(equal("R1.5.4vB"))
            expect(matches[05].info).to(equal("R1.6.3vB"))
            expect(matches[06].info).to(equal("R1.7.2vB"))
            expect(matches[07].info).to(equal("R1.8.1vB"))
            expect(matches[08].info).to(equal("R2.9.5v4"))
            expect(matches[09].info).to(equal("R2.10.W3v3"))
            expect(matches[10].info).to(equal("R2.11.W2v2"))
            expect(matches[11].info).to(equal("R2.12.W1v1"))
            expect(matches[12].info).to(equal("R3.13.W10vW11"))
            expect(matches[13].info).to(equal("R3.14.W9vW12"))
            expect(matches[14].info).to(equal("R4.15.W13vW14"))
            expect(matches[15].info).to(equal("LR2.16.L1vL2"))
            expect(matches[16].info).to(equal("LR2.17.L3vL4"))
            expect(matches[17].info).to(equal("LR2.18.L5vL6"))
            expect(matches[18].info).to(equal("LR2.19.L7vL8"))
            expect(matches[19].info).to(equal("LR3.20.L9vW16"))
            expect(matches[20].info).to(equal("LR3.21.L10vW17"))
            expect(matches[21].info).to(equal("LR3.22.L11vW18"))
            expect(matches[22].info).to(equal("LR3.23.L12vW19"))
            expect(matches[23].info).to(equal("LR4.24.W20vW21"))
            expect(matches[24].info).to(equal("LR4.25.W22vW23"))
            expect(matches[25].info).to(equal("LR5.26.L13vW24"))
            expect(matches[26].info).to(equal("LR5.27.L14vW25"))
            expect(matches[27].info).to(equal("LR6.28.W26vW27"))
            expect(matches[28].info).to(equal("LR7.29.L15vW28"))
            expect(matches[29].info).to(equal("R5.30.W15vW29"))
        }
        
        
        it("schedules double elimination with 12 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12]
            let matches = Scheduler.doubleElimination(1, row: teams)
            expect(matches.count).to(equal(30))
            expect(matches[00].info).to(equal("R1.1.8v9"))
            expect(matches[01].info).to(equal("R1.2.7v10"))
            expect(matches[02].info).to(equal("R1.3.6v11"))
            expect(matches[03].info).to(equal("R1.4.5v12"))
            expect(matches[04].info).to(equal("R1.5.4vB"))
            expect(matches[05].info).to(equal("R1.6.3vB"))
            expect(matches[06].info).to(equal("R1.7.2vB"))
            expect(matches[07].info).to(equal("R1.8.1vB"))
            expect(matches[08].info).to(equal("R2.9.W4v4"))
            expect(matches[09].info).to(equal("R2.10.W3v3"))
            expect(matches[10].info).to(equal("R2.11.W2v2"))
            expect(matches[11].info).to(equal("R2.12.W1v1"))
            expect(matches[12].info).to(equal("R3.13.W10vW11"))
            expect(matches[13].info).to(equal("R3.14.W9vW12"))
            expect(matches[14].info).to(equal("R4.15.W13vW14"))
            expect(matches[15].info).to(equal("LR2.16.L1vL2"))
            expect(matches[16].info).to(equal("LR2.17.L3vL4"))
            expect(matches[17].info).to(equal("LR2.18.L5vL6"))
            expect(matches[18].info).to(equal("LR2.19.L7vL8"))
            expect(matches[19].info).to(equal("LR3.20.L9vW16"))
            expect(matches[20].info).to(equal("LR3.21.L10vW17"))
            expect(matches[21].info).to(equal("LR3.22.L11vW18"))
            expect(matches[22].info).to(equal("LR3.23.L12vW19"))
            expect(matches[23].info).to(equal("LR4.24.W20vW21"))
            expect(matches[24].info).to(equal("LR4.25.W22vW23"))
            expect(matches[25].info).to(equal("LR5.26.L13vW24"))
            expect(matches[26].info).to(equal("LR5.27.L14vW25"))
            expect(matches[27].info).to(equal("LR6.28.W26vW27"))
            expect(matches[28].info).to(equal("LR7.29.L15vW28"))
            expect(matches[29].info).to(equal("R5.30.W15vW29"))
        }
        
        it("schedules double elimination with 13 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12,13]
            let matches = Scheduler.doubleElimination(1, row: teams)
            expect(matches.count).to(equal(30))
            expect(matches[00].info).to(equal("R1.1.8v9"))
            expect(matches[01].info).to(equal("R1.2.7v10"))
            expect(matches[02].info).to(equal("R1.3.6v11"))
            expect(matches[03].info).to(equal("R1.4.5v12"))
            expect(matches[04].info).to(equal("R1.5.4v13"))
            expect(matches[05].info).to(equal("R1.6.3vB"))
            expect(matches[06].info).to(equal("R1.7.2vB"))
            expect(matches[07].info).to(equal("R1.8.1vB"))
            expect(matches[08].info).to(equal("R2.9.W4vW5"))
            expect(matches[09].info).to(equal("R2.10.W3v3"))
            expect(matches[10].info).to(equal("R2.11.W2v2"))
            expect(matches[11].info).to(equal("R2.12.W1v1"))
            expect(matches[12].info).to(equal("R3.13.W10vW11"))
            expect(matches[13].info).to(equal("R3.14.W9vW12"))
            expect(matches[14].info).to(equal("R4.15.W13vW14"))
            expect(matches[15].info).to(equal("LR2.16.L1vL2"))
            expect(matches[16].info).to(equal("LR2.17.L3vL4"))
            expect(matches[17].info).to(equal("LR2.18.L5vL6"))
            expect(matches[18].info).to(equal("LR2.19.L7vL8"))
            expect(matches[19].info).to(equal("LR3.20.L9vW16"))
            expect(matches[20].info).to(equal("LR3.21.L10vW17"))
            expect(matches[21].info).to(equal("LR3.22.L11vW18"))
            expect(matches[22].info).to(equal("LR3.23.L12vW19"))
            expect(matches[23].info).to(equal("LR4.24.W20vW21"))
            expect(matches[24].info).to(equal("LR4.25.W22vW23"))
            expect(matches[25].info).to(equal("LR5.26.L13vW24"))
            expect(matches[26].info).to(equal("LR5.27.L14vW25"))
            expect(matches[27].info).to(equal("LR6.28.W26vW27"))
            expect(matches[28].info).to(equal("LR7.29.L15vW28"))
            expect(matches[29].info).to(equal("R5.30.W15vW29"))
        }
        
        it("schedules double elimination with 14 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
            let matches = Scheduler.doubleElimination(1, row: teams)
            expect(matches.count).to(equal(30))
            expect(matches[00].info).to(equal("R1.1.8v9"))
            expect(matches[01].info).to(equal("R1.2.7v10"))
            expect(matches[02].info).to(equal("R1.3.6v11"))
            expect(matches[03].info).to(equal("R1.4.5v12"))
            expect(matches[04].info).to(equal("R1.5.4v13"))
            expect(matches[05].info).to(equal("R1.6.3v14"))
            expect(matches[06].info).to(equal("R1.7.2vB"))
            expect(matches[07].info).to(equal("R1.8.1vB"))
            expect(matches[08].info).to(equal("R2.9.W4vW5"))
            expect(matches[09].info).to(equal("R2.10.W3vW6"))
            expect(matches[10].info).to(equal("R2.11.W2v2"))
            expect(matches[11].info).to(equal("R2.12.W1v1"))
            expect(matches[12].info).to(equal("R3.13.W10vW11"))
            expect(matches[13].info).to(equal("R3.14.W9vW12"))
            expect(matches[14].info).to(equal("R4.15.W13vW14"))
            expect(matches[15].info).to(equal("LR2.16.L1vL2"))
            expect(matches[16].info).to(equal("LR2.17.L3vL4"))
            expect(matches[17].info).to(equal("LR2.18.L5vL6"))
            expect(matches[18].info).to(equal("LR2.19.L7vL8"))
            expect(matches[19].info).to(equal("LR3.20.L9vW16"))
            expect(matches[20].info).to(equal("LR3.21.L10vW17"))
            expect(matches[21].info).to(equal("LR3.22.L11vW18"))
            expect(matches[22].info).to(equal("LR3.23.L12vW19"))
            expect(matches[23].info).to(equal("LR4.24.W20vW21"))
            expect(matches[24].info).to(equal("LR4.25.W22vW23"))
            expect(matches[25].info).to(equal("LR5.26.L13vW24"))
            expect(matches[26].info).to(equal("LR5.27.L14vW25"))
            expect(matches[27].info).to(equal("LR6.28.W26vW27"))
            expect(matches[28].info).to(equal("LR7.29.L15vW28"))
            expect(matches[29].info).to(equal("R5.30.W15vW29"))
        }
        
        it("schedules double elimination with 15 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
            let matches = Scheduler.doubleElimination(1, row: teams)
            expect(matches.count).to(equal(30))
            expect(matches[00].info).to(equal("R1.1.8v9"))
            expect(matches[01].info).to(equal("R1.2.7v10"))
            expect(matches[02].info).to(equal("R1.3.6v11"))
            expect(matches[03].info).to(equal("R1.4.5v12"))
            expect(matches[04].info).to(equal("R1.5.4v13"))
            expect(matches[05].info).to(equal("R1.6.3v14"))
            expect(matches[06].info).to(equal("R1.7.2v15"))
            expect(matches[07].info).to(equal("R1.8.1vB"))
            expect(matches[08].info).to(equal("R2.9.W4vW5"))
            expect(matches[09].info).to(equal("R2.10.W3vW6"))
            expect(matches[10].info).to(equal("R2.11.W2vW7"))
            expect(matches[11].info).to(equal("R2.12.W1v1"))
            expect(matches[12].info).to(equal("R3.13.W10vW11"))
            expect(matches[13].info).to(equal("R3.14.W9vW12"))
            expect(matches[14].info).to(equal("R4.15.W13vW14"))
            expect(matches[15].info).to(equal("LR2.16.L1vL2"))
            expect(matches[16].info).to(equal("LR2.17.L3vL4"))
            expect(matches[17].info).to(equal("LR2.18.L5vL6"))
            expect(matches[18].info).to(equal("LR2.19.L7vL8"))
            expect(matches[19].info).to(equal("LR3.20.L9vW16"))
            expect(matches[20].info).to(equal("LR3.21.L10vW17"))
            expect(matches[21].info).to(equal("LR3.22.L11vW18"))
            expect(matches[22].info).to(equal("LR3.23.L12vW19"))
            expect(matches[23].info).to(equal("LR4.24.W20vW21"))
            expect(matches[24].info).to(equal("LR4.25.W22vW23"))
            expect(matches[25].info).to(equal("LR5.26.L13vW24"))
            expect(matches[26].info).to(equal("LR5.27.L14vW25"))
            expect(matches[27].info).to(equal("LR6.28.W26vW27"))
            expect(matches[28].info).to(equal("LR7.29.L15vW28"))
            expect(matches[29].info).to(equal("R5.30.W15vW29"))
        }
        
        it("schedules double elimination with 16 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
            let matches = Scheduler.doubleElimination(1, row: teams)
            expect(matches.count).to(equal(30))
            expect(matches[00].info).to(equal("R1.1.8v9"))
            expect(matches[01].info).to(equal("R1.2.7v10"))
            expect(matches[02].info).to(equal("R1.3.6v11"))
            expect(matches[03].info).to(equal("R1.4.5v12"))
            expect(matches[04].info).to(equal("R1.5.4v13"))
            expect(matches[05].info).to(equal("R1.6.3v14"))
            expect(matches[06].info).to(equal("R1.7.2v15"))
            expect(matches[07].info).to(equal("R1.8.1v16"))
            expect(matches[08].info).to(equal("R2.9.W4vW5"))
            expect(matches[09].info).to(equal("R2.10.W3vW6"))
            expect(matches[10].info).to(equal("R2.11.W2vW7"))
            expect(matches[11].info).to(equal("R2.12.W1vW8"))
            expect(matches[12].info).to(equal("R3.13.W10vW11"))
            expect(matches[13].info).to(equal("R3.14.W9vW12"))
            expect(matches[14].info).to(equal("R4.15.W13vW14"))
            expect(matches[15].info).to(equal("LR2.16.L1vL2"))
            expect(matches[16].info).to(equal("LR2.17.L3vL4"))
            expect(matches[17].info).to(equal("LR2.18.L5vL6"))
            expect(matches[18].info).to(equal("LR2.19.L7vL8"))
            expect(matches[19].info).to(equal("LR3.20.L9vW16"))
            expect(matches[20].info).to(equal("LR3.21.L10vW17"))
            expect(matches[21].info).to(equal("LR3.22.L11vW18"))
            expect(matches[22].info).to(equal("LR3.23.L12vW19"))
            expect(matches[23].info).to(equal("LR4.24.W20vW21"))
            expect(matches[24].info).to(equal("LR4.25.W22vW23"))
            expect(matches[25].info).to(equal("LR5.26.L13vW24"))
            expect(matches[26].info).to(equal("LR5.27.L14vW25"))
            expect(matches[27].info).to(equal("LR6.28.W26vW27"))
            expect(matches[28].info).to(equal("LR7.29.L15vW28"))
            expect(matches[29].info).to(equal("R5.30.W15vW29"))
        }
        
        it("schedules double elimination with 17 teams") {
            let teams : [Int?] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]
            let matches = Scheduler.doubleElimination(1, row: teams)
            expect(matches.count).to(equal(62))
            expect(matches[00].info).to(equal("R1.1.16v17"))
            expect(matches[01].info).to(equal("R1.2.15vB"))
            expect(matches[02].info).to(equal("R1.3.14vB"))
            expect(matches[03].info).to(equal("R1.4.13vB"))
            expect(matches[04].info).to(equal("R1.5.12vB"))
            expect(matches[05].info).to(equal("R1.6.11vB"))
            expect(matches[06].info).to(equal("R1.7.10vB"))
            expect(matches[07].info).to(equal("R1.8.9vB"))
            expect(matches[08].info).to(equal("R1.9.8vB"))
            expect(matches[09].info).to(equal("R1.10.7vB"))
            expect(matches[10].info).to(equal("R1.11.6vB"))
            expect(matches[11].info).to(equal("R1.12.5vB"))
            expect(matches[12].info).to(equal("R1.13.4vB"))
            expect(matches[13].info).to(equal("R1.14.3vB"))
            expect(matches[14].info).to(equal("R1.15.2vB"))
            expect(matches[15].info).to(equal("R1.16.1vB"))
            expect(matches[16].info).to(equal("R2.17.9v8"))
            expect(matches[17].info).to(equal("R2.18.10v7"))
            expect(matches[18].info).to(equal("R2.19.11v6"))
            expect(matches[19].info).to(equal("R2.20.12v5"))
            expect(matches[20].info).to(equal("R2.21.13v4"))
            expect(matches[21].info).to(equal("R2.22.14v3"))
            expect(matches[22].info).to(equal("R2.23.15v2"))
            expect(matches[23].info).to(equal("R2.24.W1v1"))
            expect(matches[24].info).to(equal("R3.25.W20vW21"))
            expect(matches[25].info).to(equal("R3.26.W19vW22"))
            expect(matches[26].info).to(equal("R3.27.W18vW23"))
            expect(matches[27].info).to(equal("R3.28.W17vW24"))
            expect(matches[28].info).to(equal("R4.29.W26vW27"))
            expect(matches[29].info).to(equal("R4.30.W25vW28"))
            expect(matches[30].info).to(equal("R5.31.W29vW30"))
            expect(matches[31].info).to(equal("LR2.32.L1vL2"))
            expect(matches[32].info).to(equal("LR2.33.L3vL4"))
            expect(matches[33].info).to(equal("LR2.34.L5vL6"))
            expect(matches[34].info).to(equal("LR2.35.L7vL8"))
            expect(matches[35].info).to(equal("LR2.36.L9vL10"))
            expect(matches[36].info).to(equal("LR2.37.L11vL12"))
            expect(matches[37].info).to(equal("LR2.38.L13vL14"))
            expect(matches[38].info).to(equal("LR2.39.L15vL16"))
            expect(matches[39].info).to(equal("LR3.40.L17vW32"))
            expect(matches[40].info).to(equal("LR3.41.L18vW33"))
            expect(matches[41].info).to(equal("LR3.42.L19vW34"))
            expect(matches[42].info).to(equal("LR3.43.L20vW35"))
            expect(matches[43].info).to(equal("LR3.44.L21vW36"))
            expect(matches[44].info).to(equal("LR3.45.L22vW37"))
            expect(matches[45].info).to(equal("LR3.46.L23vW38"))
            expect(matches[46].info).to(equal("LR3.47.L24vW39"))
            expect(matches[47].info).to(equal("LR4.48.W40vW41"))
            expect(matches[48].info).to(equal("LR4.49.W42vW43"))
            expect(matches[49].info).to(equal("LR4.50.W44vW45"))
            expect(matches[50].info).to(equal("LR4.51.W46vW47"))
            expect(matches[51].info).to(equal("LR5.52.L25vW48"))
            expect(matches[52].info).to(equal("LR5.53.L26vW49"))
            expect(matches[53].info).to(equal("LR5.54.L27vW50"))
            expect(matches[54].info).to(equal("LR5.55.L28vW51"))
            expect(matches[55].info).to(equal("LR6.56.W52vW53"))
            expect(matches[56].info).to(equal("LR6.57.W54vW55"))
            expect(matches[57].info).to(equal("LR7.58.L29vW56"))
            expect(matches[58].info).to(equal("LR7.59.L30vW57"))
            expect(matches[59].info).to(equal("LR8.60.W58vW59"))
            expect(matches[60].info).to(equal("LR9.61.L31vW60"))
            expect(matches[61].info).to(equal("R6.62.W31vW61"))
        }
        
        it("ends this spec") {
            expect(1-1).to(equal(0))
        }
    }
}
