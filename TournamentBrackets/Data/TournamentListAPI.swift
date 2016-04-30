//
//  TournamentListAPI.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 30/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//


import Foundation
import RealmSwift
#if !RX_NO_MODULE
    import RxSwift
#endif

class TournamentListAPI {
    
    static let sharedAPI = TournamentListAPI()
    
    private init() {}
    
    var realm = try! Realm()
    
    func getTournamentResultSet() -> Observable<[Tournament]> {
        let tournaments = Array(realm.objects(Tournament))
        return Observable.just(tournaments)
    }
}
