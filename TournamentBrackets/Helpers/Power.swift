//
//  Power.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 17/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation

infix operator ^^ { }
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}