//
//  ImportTeamsViewController.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 26/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class TeamsImportListViewController: ViewController {
    
    var viewModel : TeamsImportListViewModel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        viewModel = TeamsImportListViewModel()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let d = segue.destinationViewController as? TeamStatsListViewController, cell = sender as? UITableViewCell, indexPath = tableView.indexPathForCell(cell) where segue.identifier == "showTeamStatsList" {

            let g = viewModel.tournaments[indexPath.section].groups[indexPath.row]
            d.viewModel = TeamStatsListViewModel(group: g)
        }
    }
}

extension TeamsImportListViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.tournaments.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tournaments[section].groups.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TeamsImportItemCell") as! TeamsImportItemCell
        let g = viewModel.tournaments[indexPath.section].groups[indexPath.row]
        cell.viewModel = TeamsImportItemViewModel(group: g)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let t = viewModel.tournaments[section]
        return t.name
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36.0
    }
}

extension TeamsImportListViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
}
