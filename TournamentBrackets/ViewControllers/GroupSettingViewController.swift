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
        
        backgroundThread(0.1, background: nil) {
            guard self.textGroupName.text?.characters.count == 0 else { return }
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
        
        func setTeamCountSchedule(schedule : ScheduleType, withOldSchedule oldschedule : ScheduleType) {
            let oldindex = Int(self.pickerTeamCount.selectedItem)
            var oldteamcount = oldschedule.allowedTeamCounts[oldindex]
            if let newindex = schedule.allowedTeamCounts.indexOf(oldteamcount) {
                self.pickerTeamCount.selectItem(UInt(newindex), animated: true)
            } else {
                oldteamcount = oldteamcount - 1
                if let newindex = schedule.allowedTeamCounts.indexOf(oldteamcount) {
                    self.pickerTeamCount.selectItem(UInt(newindex), animated: true)
                } else {
                    self.pickerTeamCount.selectItem(UInt(0), animated: true)
                }
            }
        }
        
        self.segmentedSchedule
            .rx_value
            .asObservable()
            .map{ (value) -> Int in
                let schedule = ScheduleType(rawValue: value)!
                return schedule.allowedTeamCounts.count
            }
            .distinctUntilChanged()
            .subscribeNext{ _ in
                let schedule = ScheduleType(rawValue: self.segmentedSchedule.selectedSegmentIndex)!
                if schedule == .RoundDoubles {
                    setTeamCountSchedule(schedule, withOldSchedule: ScheduleType.RoundRobin)
                    self.pickerTeamCount.reloadData()
                } else {
                    self.pickerTeamCount.reloadData()
                    setTeamCountSchedule(schedule, withOldSchedule: ScheduleType.RoundDoubles)
                }
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
        if let _ = segue.destinationViewController as? GroupListViewController, tournament = self.tournament where segue.identifier == "unwindToGroupAndSave" {
            self.viewModel.saveWithTournament(tournament)
        }
    }
    
    @IBAction func unwindToGroupSetting(segue: UIStoryboardSegue) {
        if let s = segue.sourceViewController as? TeamStatsListViewController, vm = s.viewModel where segue.identifier == "unwindToGroupSettingAndSave" {
            var newstatsList = vm.statsList
            var newcount = newstatsList.count
            if let newindex = viewModel.scheduleType.value.allowedTeamCounts.indexOf(newcount) {
                self.pickerTeamCount.selectItem(UInt(newindex), animated: true)
            } else {
                newcount = newcount - 1
                newstatsList.removeLast()
                if let newindex = viewModel.scheduleType.value.allowedTeamCounts.indexOf(newcount) {
                    self.pickerTeamCount.selectItem(UInt(newindex), animated: true)
                } else {
                    self.pickerTeamCount.selectItem(UInt(0), animated: true)
                }
            }
            viewModel.copyTeams(newstatsList)
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
        let schedule = ScheduleType(rawValue: self.segmentedSchedule.selectedSegmentIndex)!
        self.viewModel.teamCount = schedule.allowedTeamCounts[item]
    }
    
    func pickerView(pickerView: AKPickerView!, titleForItem item: Int) -> String! {
        let schedule = ScheduleType(rawValue: self.segmentedSchedule.selectedSegmentIndex)!
        return "  \(schedule.allowedTeamCounts[item])  "
    }
    
    func numberOfItemsInPickerView(pickerView: AKPickerView!) -> UInt {
        let schedule = ScheduleType(rawValue: self.segmentedSchedule.selectedSegmentIndex)!
        return UInt(schedule.allowedTeamCounts.count)
    }
}