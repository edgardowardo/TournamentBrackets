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

    let realm = try! Realm()
    let bag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!

    // MARK: - View lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableDataSource()
    }
    
    func configureTableDataSource() {
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .None
        tableView.delegate = self
        tableView.registerNib(UINib(nibName: "GameCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        
        if let g = group {
            let games = g.games.sorted("index", ascending: true).asObservableArray()
            let models = g.games.sorted("index", ascending: true).map{ (game) in GameViewModel(game: game) }
            
            for m in models {
                if let mElimination = m.game.elimination {
                    m.prevLeftGameViewModel = models.filter{ (model) in model.index == mElimination.leftGameIndex }.first
                    m.prevRightGameViewModel = models.filter{ (model) in model.index == mElimination.rightGameIndex }.first
                }
            }
            
            games.bindTo(tableView.rx_itemsWithCellIdentifier("GameCell", cellType: GameCell.self)) {row, element, cell in
                cell.viewModel = models.filter{ (model) in model.index == element.index }.first
                }
                .addDisposableTo(bag)
        }
    }
    
}

extension GameListViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
}