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

    let dataSource = TeamStatsListViewController.configureDataSource()
    var viewModel : TeamStatsListViewModel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self

        viewModel.statsList
            .asObservable()
            .map{ stats in
                [SectionModel(model: "STANDINGS", items: stats)]
            }
            .bindTo(tableView.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(disposeBag)
        
        viewModel.loadStatsList()
    }
    
    static func configureDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String, TeamStats>> {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, TeamStats>>()
        dataSource.configureCell = { (_, tv, ip, stat: TeamStats) in
            let cell = tv.dequeueReusableCellWithIdentifier("TeamStatsCell") as! TeamStatsCell
            cell.viewModel = TeamStatsViewModel(teamstats: stat)
            return cell
        }
        return dataSource
    }

}

extension TeamStatsListViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
}