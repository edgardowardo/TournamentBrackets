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

import RealmSwift
import RxRealm

class GroupSettingViewController: ViewController {

    let dataSource = GroupSettingViewController.configureDataSource()
    var viewModel : GroupSettingViewModel! = nil
    let schedules = ScheduleType.schedules()
    @IBOutlet weak var textGroupName: UITextField!
    @IBOutlet weak var segmentedSchedule: UISegmentedControl!
    @IBOutlet weak var pickerTeamCount: AKPickerView!
    @IBOutlet weak var switchIsHandicapped: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.setEditing(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // Hacky to create multiline title on segmented control
        //
        self.segmentedSchedule.setImageAsMultilineTitle("Round \nRobin", atIndex: 0)
        self.segmentedSchedule.setImageAsMultilineTitle("Round \nDoubles", atIndex: 1)
        self.segmentedSchedule.setImageAsMultilineTitle("Single \nElimination", atIndex: 2)
        self.segmentedSchedule.setImageAsMultilineTitle("Double \nElimination", atIndex: 3)
        
        self.tableView.delegate = self
        self.viewModel = GroupSettingViewModel(group: Group())
        self.pickerTeamCount.delegate = self
        self.pickerTeamCount.dataSource = self
        
        //
        // Observation of schedule type
        //
        self.viewModel.scheduleType
            .asObservable()
            .subscribeNext { index -> Void in
                self.segmentedSchedule.selectedSegmentIndex = index.rawValue
                self.pickerTeamCount.selectItem(0, animated: true)
                self.pickerTeamCount.reloadData()
            }
            .addDisposableTo(disposeBag)

        //
        // Observation of team list
        //
        self.viewModel.teams
            .asObservable()
            .map{ teams in
                [SectionModel(model: "", items: teams)]
            }
            .bindTo(tableView.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(disposeBag)
        
        
        //
        // Observation of is handicap
        //
        self.viewModel.isHandicap
            .asObservable()
            .subscribeNext { (value) in
                self.switchIsHandicapped.on = value
                self.tableView.reloadData()
            }
            .addDisposableTo(disposeBag)
        
        //
        // Reactive binding
        //
        self.segmentedSchedule
            .rx_value
            .asObservable()
            .filter{ $0 > -1 }
            .subscribeNext({ (value) in
                self.viewModel.scheduleType.value = ScheduleType(rawValue: value)!
            })
            .addDisposableTo(disposeBag)

        //
        // Reactive binding
        //
        self.switchIsHandicapped
            .rx_value
            .asObservable()
            .subscribeNext { (value) in
                self.viewModel.isHandicap.value = value
            }
            .addDisposableTo(disposeBag)
        
        //
        // Observe move row
        //
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
            
//            cell.textHandicapPoints.hidden = !self.viewModel.isHandicap.value
            
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