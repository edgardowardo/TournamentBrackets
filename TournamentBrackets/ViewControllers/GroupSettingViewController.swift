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


class TeamCell : UITableViewCell {
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textHandicapPoints: UITextField!    
}

class GroupSettingViewController: ViewController {

    let schedules = ScheduleType.schedules()
    @IBOutlet weak var textGroupName: UITextField!
    @IBOutlet weak var pickerTeamCount: AKPickerView!
    @IBOutlet weak var switchIsHandicapped: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.pickerTeamCount.delegate = self
        self.pickerTeamCount.dataSource = self
    }
}

extension GroupSettingViewController : AKPickerViewDelegate, AKPickerViewDataSource {
 
    func pickerView(pickerView: AKPickerView!, titleForItem item: Int) -> String! {
        if pickerView === self.pickerTeamCount {
            return "  \(ScheduleType(rawValue: 1)!.allowedTeamCounts[item])  "
        }
        return ""
    }
    
    func numberOfItemsInPickerView(pickerView: AKPickerView!) -> UInt {
        if pickerView === self.pickerTeamCount {
            // TODO: Create  View Model, store this schedule type there and observe it!
            return UInt(ScheduleType(rawValue: 1)!.allowedTeamCounts.count)
        }
        return 0
    }
}