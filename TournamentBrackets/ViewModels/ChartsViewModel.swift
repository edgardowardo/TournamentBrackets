//
//  ChartsViewModel.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 25/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import RxSwift

struct ChartsViewModel {
    
    var statsList: Variable<[TeamStats]> = Variable([])
    var group : Group!
    
    init(group : Group) {
        self.group = group
    }
    
}