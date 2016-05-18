//
//  GamesListViewController.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 10/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa

class GameListViewController: ViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel : GameListViewModel!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableDataSource()
    }
    
    func configureTableDataSource() {
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .None
        tableView.delegate = self
        tableView.registerNib(UINib(nibName: "GameCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        
        viewModel.games
            .bindTo(tableView.rx_itemsWithCellIdentifier("GameCell", cellType: GameCell.self)) {row, element, cell in
                cell.viewModel = self.viewModel.gameViewModels.filter{ (model) in model.index == element.index }.first
            }
            .addDisposableTo(bag)
    }
}

extension GameListViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
}