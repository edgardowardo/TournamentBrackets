//
//  GroupSettingViewController.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 02/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation

import UIKit

import UIColor_FlatColors
import AKPickerView

import RxSwift
import RxCocoa
import RxDataSources

class GroupSettingViewController: ViewController {

    var tournament : Tournament? = nil
    let dataSource = GroupSettingViewController.configureDataSource()
    var viewModel : GroupSettingViewModel! = nil
    let schedules = ScheduleType.schedules()
    @IBOutlet weak var textGroupName: UITextField!
    @IBOutlet weak var segmentedSchedule: UISegmentedControl!
    @IBOutlet weak var pickerTeamCount: AKPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonShuffle: UIButton!
    @IBOutlet weak var buttonSort: UIButton!
    @IBOutlet weak var buttonReset: UIButton!
    @IBOutlet weak var buttonImport: UIButton!
    @IBOutlet weak var buttonHandicap: UIButton!
    @IBOutlet weak var buttonSave: UIBarButtonItem!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        DefaultWireframe.delay(0.25) { 
            self.textGroupName.becomeFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // Hacky to create multiline title on segmented control
        //
        self.segmentedSchedule.setImageAsMultilineTitle("Round \nRobin", atIndex: 0)
        self.segmentedSchedule.setImageAsMultilineTitle("American \nTournament", atIndex: 1)
        self.segmentedSchedule.setImageAsMultilineTitle("Single \nElimination", atIndex: 2)
        self.segmentedSchedule.setImageAsMultilineTitle("Double \nElimination", atIndex: 3)
        
        self.tableView.delegate = self
        self.tableView.scrollsToTop = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GroupSettingViewController.methodOfReceivedNotification_CellStartEditing(_:)), name: TeamCell.Notification.Identifier.CellStartEditing, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GroupSettingViewController.methodOfReceivedNotification_PreviousCellTextField(_:)), name: TeamCell.Notification.Identifier.PreviousCellTextField, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GroupSettingViewController.methodOfReceivedNotification_NextCellTextField(_:)), name: TeamCell.Notification.Identifier.NextCellTextField, object: nil)
        
        
        self.viewModel = GroupSettingViewModel(group: Group())
        self.pickerTeamCount.delegate = self
        self.pickerTeamCount.dataSource = self
        
        //
        // View Model Observations
        //
        self.viewModel.scheduleType
            .asObservable()
            .subscribeNext { index -> Void in
                self.segmentedSchedule.selectedSegmentIndex = index.rawValue
                self.pickerTeamCount.selectItem(0, animated: true)
                self.pickerTeamCount.reloadData()
            }
            .addDisposableTo(disposeBag)

        self.viewModel.teams
            .asObservable()
            .map{ teams in
                [SectionModel(model: "", items: teams)]
            }
            .bindTo(tableView.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(disposeBag)
        
        
        self.viewModel.isHandicap
            .asObservable()
            .subscribeNext { (value) in
                let tintColor = (value) ? UIColor.flatPeterRiverColor() : UIColor.darkGrayColor()
                self.buttonHandicap.tintColor = tintColor
                self.buttonHandicap.setTitleColor(tintColor, forState: .Normal)
                self.viewModel.setTeamsHandicap(value)
                self.tableView.reloadData()
            }
            .addDisposableTo(disposeBag)

        self.viewModel.isSorting
            .asObservable()
            .subscribeNext { (value) in
                let tintColor = (value) ? UIColor.flatPeterRiverColor() : UIColor.darkGrayColor()
                self.buttonSort.tintColor = tintColor
                self.buttonSort.setTitleColor(tintColor, forState: .Normal)
                self.tableView.setEditing(value, animated: true)
            }
            .addDisposableTo(disposeBag)
        
        //
        // Control bindings
        //
        self.textGroupName
            .rx_text
            .asObservable()
            .map{ (something) in something.characters.count > 0 }
            .bindTo(self.buttonSave.rx_enabled)
            .addDisposableTo(disposeBag)
        
        self.textGroupName
            .rx_text
            .asObservable()
            .subscribeNext{ (name) in
                self.viewModel.name = name
            }
            .addDisposableTo(disposeBag)
        
        self.segmentedSchedule
            .rx_value
            .asObservable()
            .filter{ $0 > -1 }
            .subscribeNext({ (value) in
                self.viewModel.scheduleType.value = ScheduleType(rawValue: value)!
            })
            .addDisposableTo(disposeBag)

        self.buttonShuffle
            .rx_tap
            .asObservable()
            .subscribeNext { _ in
                self.viewModel.shuffle()
            }
            .addDisposableTo(disposeBag)
        
        self.buttonReset
            .rx_tap
            .asObservable()
            .subscribeNext { _ in
                self.viewModel.reset()
            }
            .addDisposableTo(disposeBag)
        
        self.buttonHandicap
            .rx_tap
            .asObservable()
            .subscribeNext { _ in
                self.viewModel.isHandicap.value = !self.viewModel.isHandicap.value
            }
            .addDisposableTo(disposeBag)
        
        self.buttonSort
            .rx_tap
            .asObservable()
            .subscribeNext { _ in
                self.viewModel.isSorting.value = !self.viewModel.isSorting.value
            }
            .addDisposableTo(disposeBag)
        
        self.tableView.rx_itemMoved
            .subscribeNext{  (fromIndexPath, toIndexPath) in
                self.viewModel.moveElement(fromIndexPath, toIndexPath: toIndexPath)
            }
            .addDisposableTo(disposeBag)
    }
    
    
    static func configureDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String, Team>> {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Team>>()
        
        dataSource.configureCell = { (_, tv, ip, team: Team) in
            let cell = tv.dequeueReusableCellWithIdentifier("TeamCell") as! TeamCell
            cell.team = team
            return cell
        }
        
        dataSource.canEditRowAtIndexPath = { _ in
            return true
        }
        dataSource.canMoveRowAtIndexPath = { _ in
            return true
        }
        
        return dataSource
    }
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let _ = segue.destinationViewController as? GroupListViewController, tournament = self.tournament {
            let _ = self.viewModel.saveWithTournament(tournament)
            // TODO: this group may be automatically shown after unwind
            //            d.group = group
        }
    }
    
    //
    // Notification handlers. I know bad smell. Will revisit when understand more Rx implementationof this!
    //
    //
    @objc private func methodOfReceivedNotification_PreviousCellTextField(notification : NSNotification) {
        if let currentcell = notification.object as? TeamCell, indexPath = tableView.indexPathForCell(currentcell) {
            let nextindexpath = NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
            if let nextCell = tableView.cellForRowAtIndexPath(nextindexpath) as? TeamCell {
                if self.viewModel.isHandicap.value {
                    nextCell.textHandicapPoints.becomeFirstResponder()
                } else {
                    nextCell.textName.becomeFirstResponder()
                }
            }
        }
    }
    
    @objc private func methodOfReceivedNotification_NextCellTextField(notification : NSNotification) {
        if let currentcell = notification.object as? TeamCell, indexPath = tableView.indexPathForCell(currentcell) {
            let nextindexpath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
            if let nextCell = tableView.cellForRowAtIndexPath(nextindexpath) as? TeamCell {
                nextCell.textName.becomeFirstResponder()
            }
        }
    }

    @objc private func methodOfReceivedNotification_CellStartEditing(notification : NSNotification) {
        if let cell = notification.object as? TeamCell, indexPath = tableView.indexPathForCell(cell) {
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
        }
    }
}

extension GroupSettingViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
}

extension GroupSettingViewController : AKPickerViewDelegate, AKPickerViewDataSource {
 
    func pickerView(pickerView: AKPickerView!, didSelectItem item: Int) {
        if pickerView === self.pickerTeamCount {
            self.viewModel.teamCount = self.viewModel.scheduleType.value.allowedTeamCounts[item]
        }
    }
    
    func pickerView(pickerView: AKPickerView!, titleForItem item: Int) -> String! {
        if pickerView === self.pickerTeamCount {
            return "  \(self.viewModel.scheduleType.value.allowedTeamCounts[item])  "
        }
        return ""
    }
    
    func numberOfItemsInPickerView(pickerView: AKPickerView!) -> UInt {
        if pickerView === self.pickerTeamCount {
            return UInt(self.viewModel.scheduleType.value.allowedTeamCounts.count)
        }
        return 0
    }
}