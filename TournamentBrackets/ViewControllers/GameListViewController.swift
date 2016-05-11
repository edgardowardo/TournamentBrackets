//
//  GamesListViewController.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 10/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

import UIColor_FlatColors
import AKPickerView

import RxSwift
import RxCocoa
import RxDataSources

import RealmSwift
import RxRealm

class GameListViewController: ViewController {
    
    var group : Group? = nil {
        didSet {
            if let g = group {
                self.title = g.name
            }
        }
    }
    
    @IBAction func unwindToGameList(segue: UIStoryboardSegue) {
    }
    
}