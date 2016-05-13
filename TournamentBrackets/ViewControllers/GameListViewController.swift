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
            games.bindTo(tableView.rx_itemsWithCellIdentifier("GameCell", cellType: GameCell.self)) {row, element, cell in
                cell.indexLabel.text = "\(element.index)"
                cell.leftTeamButton.setTitle(element.leftPrompt, forState: .Normal)
                cell.rightTeamButton.setTitle(element.rightPrompt, forState: .Normal)
                
                }.addDisposableTo(bag)
        }
    }
    
}

extension GameListViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
}

extension Game {
    var leftPrompt : String {
        get {
            if let l = leftTeam {
                return l.name
            } else {
                return ""
            }
        }
    }
    
    var rightPrompt : String {
        get {
            if let r = rightTeam {
                return r.name
            } else {
                return ""
            }
        }
    }
}
