//
//  TeamStatsListViewController.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 22/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit
import RxDataSources
import RealmSwift

class TeamStatsListViewController : ViewController {

    var viewModel : TeamStatsListViewModel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadStatsList()
        tableView.reloadData()
    }
}

extension TeamStatsListViewController : UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.statsList.value.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TeamStatsCell") as! TeamStatsCell
        let stat = viewModel.statsList.value[indexPath.row]
        cell.viewModel = TeamStatsViewModel(teamstats: stat)
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UINib(nibName: "TeamStatsHeaderView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as? TeamStatsHeaderView
        if viewModel.group.schedule == .SingleElimination || viewModel.group.schedule == .DoubleElimination {
            view?.labelPlayed.text = "P"
        } else {
            view?.labelPlayed.text = "\(viewModel.countGames)/P"
        }
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36.0
    }
}

extension TeamStatsListViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
}