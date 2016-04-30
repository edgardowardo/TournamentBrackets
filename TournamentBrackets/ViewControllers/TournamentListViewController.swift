//
//  TournamentListViewController.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 29/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class TournamentListViewController: ViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let dataSource = TournamentListViewController.configureDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let loadTournaments = TournamentListAPI.sharedAPI
            .getTournamentResultSet()
            .map(TournamentListCommand.SetTournaments)
        
        let initialLoadCommand =  loadTournaments
            .observeOn(MainScheduler.instance)
        
        let deleteCommand = tableView.rx_itemDeleted.map(TournamentListCommand.DeleteTournament)
        
        let initialState = TournamentListCommandViewModel(tournaments: [])
        
        let viewModel =  Observable.of(initialLoadCommand, deleteCommand)
            .merge()
            .scan(initialState) { $0.executeCommand($1) }
            .shareReplay(1)
        
        viewModel
            .map {
                [
                    SectionModel(model: "Tournaments", items: $0.tournaments),
                ]
            }
            .bindTo(tableView.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(disposeBag)
        
        tableView.rx_itemSelected
            .withLatestFrom(viewModel) { i, viewModel in
                let all = [viewModel.tournaments]
                return all[i.section][i.row]
            }
            .subscribeNext { [weak self] tourney in
                self?.showDetailsForTournament(tourney)
            }
            .addDisposableTo(disposeBag)
        
        // customization using delegate
        // RxTableViewDelegateBridge will forward correct messages
        tableView.rx_setDelegate(self)
            .addDisposableTo(disposeBag)
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.editing = editing
    }
    
    // MARK: Table view delegate ;)
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = dataSource.sectionAtIndex(section)
        
        let label = UILabel(frame: CGRect.zero)
        // hacky I know :)
        label.text = "  \(title)"
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor.darkGrayColor()
        label.alpha = 0.9
        
        return label
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // MARK: Navigation
    
    private func showDetailsForTournament(tourney: Tournament) {
//        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(identifier: "RxExample-iOS"))
//        let viewController = storyboard.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
//        viewController.user = user
//        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: Work over Variable
    
    static func configureDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String, Tournament>> {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Tournament>>()
        
        dataSource.configureCell = { (_, tv, ip, tourney: Tournament) in
            let cell = tv.dequeueReusableCellWithIdentifier("Cell")!
            cell.textLabel?.text = tourney.name
            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, sectionIndex in
            return dataSource.sectionAtIndex(sectionIndex).model
        }
        
        dataSource.canEditRowAtIndexPath = { (ds, ip) in
            return true
        }
        
        return dataSource
    }
    
}