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

import RealmSwift
import RxRealm

class GroupSettingViewController: ViewController {

    var viewModel : GroupSettingViewModel! = nil
    let schedules = ScheduleType.schedules()
    @IBOutlet weak var textGroupName: UITextField!
    @IBOutlet weak var segmentedSchedule: UISegmentedControl!
    @IBOutlet weak var pickerTeamCount: AKPickerView!
    @IBOutlet weak var switchIsHandicapped: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // Hacky to create multiline title on segmented control
        //
        self.segmentedSchedule.setImageAsMultilineTitle("Round \nRobin", atIndex: 0)
        self.segmentedSchedule.setImageAsMultilineTitle("Round \nDoubles", atIndex: 1)
        self.segmentedSchedule.setImageAsMultilineTitle("Single \nElimination", atIndex: 2)
        self.segmentedSchedule.setImageAsMultilineTitle("Double \nElimination", atIndex: 3)
        
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
            .bindTo(tableView.rx_itemsWithCellIdentifier("TeamCell")) { (row, element, cell) in
                if let c = cell as? TeamCell {
                    c.team = element
                    c.textHandicapPoints.hidden = !self.viewModel.isHandicap.value
                }
            }
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