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
    
    @IBAction func update() {
        let alert = UIAlertController(title: "Save", message: "Saving will clear game progress. Continue?", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction( UIAlertAction(title: "Continue", style: .Destructive) { (_) in
            self.viewModel.updateGroup()
            self.performSegueWithIdentifier("unwindToGroupAndSave", sender: self)
            })
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
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

        //
        // Edit or
        //
        if let first = navigationController?.viewControllers.first where first == self {
            self.navigationItem.rightBarButtonItems?.removeAtIndex(0)
            let u = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(update))
            self.navigationItem.rightBarButtonItem = u
            let b = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancel))
            self.navigationItem.leftBarButtonItem = b
            self.title = "Update Group"            
        } else {
            //
            // Insert mode
            //
            self.viewModel = GroupSettingViewModel(group: Group())
        }
        
        self.pickerTeamCount.delegate = self
        self.pickerTeamCount.dataSource = self
        self.pickerTeamCount.font = font17
        self.pickerTeamCount.textColor = UIColor.lightGrayColor()
        self.pickerTeamCount.highlightedFont = font25
        self.pickerTeamCount.highlightedTextColor = UIColor.flatCarrotColor()
        
        //
        // Setup observers
        //
        setupScheduleTypeObserver()
        setupTableViewObserver()
        
        setupGroupNameObserver()
        setupButtonHandicapObserver()
        setupButtonSortingObserver()
        setupButtonObservers()

        self.pickerTeamCount.selectItem(UInt(viewModel.teamCountIndex), animated: true)
        
    }
    
    private func setupScheduleTypeObserver() {
        
        self.viewModel.scheduleType
            .asObservable()
            .map{ $0.rawValue }
            .bindTo(segmentedSchedule.rx_value)
            .addDisposableTo(disposeBag)
        
        self.segmentedSchedule
            .rx_value
            .asObservable()
            .map{ (value) -> (Int) in return (ScheduleType(rawValue: value)!.allowedTeamCounts.count) }
            .distinctUntilChanged()
            .subscribeNext{ (x) in
                let oldTeamCountValue = self.viewModel.teamCountValue
                backgroundThread(0.1, completion: {
                    let s = self.viewModel.scheduleType.value
                    if s != .RoundDoubles {
                        self.pickerTeamCount.reloadData()
                    }
                    if let index = s.allowedTeamCounts.indexOf(oldTeamCountValue) {
                        self.pickerTeamCount.selectItem(UInt(index), animated: true)
                    } else {
                        let newTeamCountValue = oldTeamCountValue - 1
                        if let index = s.allowedTeamCounts.indexOf(newTeamCountValue) {
                            self.pickerTeamCount.selectItem(UInt(index), animated: true)
                        } else {
                            self.pickerTeamCount.selectItem(UInt(0), animated: true)
                        }
                    }
                    if s == .RoundDoubles {
                        self.pickerTeamCount.reloadData()
                    }
                })
            }
            .addDisposableTo(disposeBag)
        
        
        self.segmentedSchedule
            .rx_value
            .asObservable()
            .subscribeNext({ (value) in
                self.viewModel.scheduleType.value = ScheduleType(rawValue: value)!
            })
            .addDisposableTo(disposeBag)
    }
    
    func setupTableViewObserver() {
        self.viewModel.teams
            .asObservable()
            .map{ teams in
                [SectionModel(model: "", items: teams)]
            }
            .bindTo(tableView.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(disposeBag)
        
        self.tableView.rx_itemMoved
            .subscribeNext{  (fromIndexPath, toIndexPath) in
                self.viewModel.moveElement(fromIndexPath, toIndexPath: toIndexPath)
            }
            .addDisposableTo(disposeBag)
    }
    
    private func setupGroupNameObserver() {
        self.viewModel.name
            .asObservable()
            .bindTo(textGroupName.rx_text)
            .addDisposableTo(disposeBag)
        
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
                self.viewModel.name.value = name
            }
            .addDisposableTo(disposeBag)
    }
    
    private func setupButtonHandicapObserver() {
        self.buttonHandicap
            .rx_tap
            .asObservable()
            .subscribeNext { _ in
                self.viewModel.isHandicap.value = !self.viewModel.isHandicap.value
            }
            .addDisposableTo(disposeBag)
        
        self.viewModel.isHandicap
            .asObservable()
            .subscribeNext { (value) in
                let tintColor = (value) ? UIColor.flatCarrotColor() : UIColor.darkGrayColor()
                self.buttonHandicap.tintColor = tintColor
                self.buttonHandicap.setTitleColor(tintColor, forState: .Normal)
                self.viewModel.setTeamsHandicap(value)
                self.tableView.reloadData()
            }
            .addDisposableTo(disposeBag)
    }
    
    private func setupButtonSortingObserver() {
        self.buttonSort
            .rx_tap
            .asObservable()
            .subscribeNext { _ in
                self.viewModel.isSorting.value = !self.viewModel.isSorting.value
            }
            .addDisposableTo(disposeBag)
        
        self.viewModel.isSorting
            .asObservable()
            .subscribeNext { (value) in
                let tintColor = (value) ? UIColor.flatCarrotColor() : UIColor.darkGrayColor()
                self.buttonSort.tintColor = tintColor
                self.buttonSort.setTitleColor(tintColor, forState: .Normal)
                self.tableView.setEditing(value, animated: true)
            }
            .addDisposableTo(disposeBag)
    }
    
    private func setupButtonObservers() {
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
        if let _ = segue.destinationViewController as? GroupListViewController where segue.identifier == "unwindToGroupAndSave" {
            if let tournament = self.tournament {
                self.viewModel.saveWithTournament(tournament)
            }
        }
    }
    
    @IBAction func unwindToGroupSetting(segue: UIStoryboardSegue) {
        if let s = segue.sourceViewController as? TeamStatsListViewController, vm = s.viewModel where segue.identifier == "unwindToGroupSettingAndSave" {
            
            backgroundThread(0.5, background: nil, completion: {
                let alert = UIAlertController(title: "Copy", message: "Would you like to add or override to the existing teams?", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                alert.addAction( UIAlertAction(title: "Override", style: .Destructive) { (_) in
                    self.addOrOverrideTeams(false, toSourceViewModel: vm)
                    })
                alert.addAction( UIAlertAction(title: "Add", style: .Default) { (_) in
                    self.addOrOverrideTeams(true, toSourceViewModel: vm)
                    })
                self.presentViewController(alert, animated: true, completion: nil)
            })
        }
    }
    
    func addOrOverrideTeams(isAdd : Bool, toSourceViewModel vm : TeamStatsListViewModel) {
        
        var statsList = vm.statsList
        let additionalcount = (isAdd) ? viewModel.teams.value.count : 0
        var totalcount = statsList.count + additionalcount
        
        if let newindex = viewModel.scheduleType.value.allowedTeamCounts.indexOf(totalcount) {
            self.pickerTeamCount.selectItem(UInt(newindex), animated: true)
        } else {
            if totalcount > 32 {
                totalcount = 32
                let startofrange = 32 - viewModel.teams.value.count
                let r = startofrange..<statsList.count
                statsList.removeRange(r)
                
                selectTeamCount(32)
            } else {
                if let newindex = viewModel.scheduleType.value.allowedTeamCounts.indexOf(totalcount) {
                    self.pickerTeamCount.selectItem(UInt(newindex), animated: true)
                } else {
                    totalcount = totalcount - 1
                    statsList.removeLast()
                    
                    selectTeamCount(totalcount)
                }
            }
        }
        
        viewModel.copyTeams(statsList)        
    }
    
    
    func selectTeamCount(count : Int) {
        if let newindex = viewModel.scheduleType.value.allowedTeamCounts.indexOf(count) {
            self.pickerTeamCount.selectItem(UInt(newindex), animated: true)
        } else {
            self.pickerTeamCount.selectItem(UInt(0), animated: true)
        }
    }
    
    //
    // Notification handlers. I know bad smell. Will revisit when understand more Rx implementationof this!
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
        viewModel.teamCountIndex = item
    }
    
    func pickerView(pickerView: AKPickerView!, titleForItem item: Int) -> String! {
        return viewModel.getAllowedTeamCountText(item)
    }
    
    func numberOfItemsInPickerView(pickerView: AKPickerView!) -> UInt {
        return UInt(viewModel.scheduleType.value.allowedTeamCounts.count)
    }
}