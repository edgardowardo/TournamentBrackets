//
//  GroupListViewController.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 01/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation

import UIKit

import UIColor_FlatColors

import RxSwift
import RxCocoa

import RealmSwift
import RxRealm

class GroupListViewController: ViewController, UITextFieldDelegate {
    
    let realm = try! Realm()
    let bag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    var tournament : Tournament? = nil {
        didSet {
            if let t = tournament {
                self.title = t.name
            }
        }
    }
    
    // MARK: - Text field delegate -
    
    lazy var textField : UITextField = {
        let textfield = UITextField(frame: CGRectMake(0, 0, 10, 44))
        textfield.clearButtonMode = .Always
        textfield.borderStyle = .RoundedRect
        textfield.returnKeyType = .Done
        textfield.backgroundColor = UIColor.flatCloudsColor()
        textfield.delegate = self
        textfield.hidden = true
        textfield.autocapitalizationType = .Words
        return textfield
    }()
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return self.textField
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let text = textField.text, tourney = tournament where text.characters.count > 0 {
            try! realm.write {
                tourney.name = text
                realm.add(tourney, update: true)
            }
        }
        textField.resignFirstResponder()
        textField.hidden = true
        return true
    }
    
    // MARK: - View lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tournament = tournament {
            //
            // Observe changes for the title
            //
            let id = tournament.id
            let tourneyName = realm.objects(Tournament).filter("id == '\(id)'").asObservable()
            tourneyName.subscribeNext {[unowned self] elements in
                if let t = elements.filter("id == '\(id)'").first {
                    self.title = t.name
                }
                }.addDisposableTo(bag)

            //
            // Observe the list
            //
            let groups = tournament.groups.sorted("time", ascending: false).asObservableArray()
            groups.bindTo(tableView.rx_itemsWithCellIdentifier("GroupCell", cellType: UITableViewCell.self))  {row, element, cell in
                cell.textLabel!.text = element.name
                let handicapText : String = (element.isHandicap) ? ", handicapped" : ""
                let rounds = Array(element.games.map{ $0.round }).unique.count
                cell.detailTextLabel?.text = "\(element.schedule.description) \(element.teams.count) teams, \(element.games.count) games, \(rounds) rounds\(handicapText)"
            }.addDisposableTo(bag)
            
            //
            // Observe the delete swipe
            //
            tableView.rx_itemDeleted
                .subscribeNext { [unowned self] indexPath in
                    try! self.realm.write {
                        self.realm.delete(tournament.groups.sorted("time", ascending: false)[indexPath.row])
                    }
                }
                .addDisposableTo(disposeBag)
        }
        
        //
        // Observe the item selected
        //
        tableView.rx_itemSelected
            .subscribeNext { [unowned self] indexPath in
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            .addDisposableTo(disposeBag)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let d = segue.destinationViewController as? GroupSettingViewController where segue.identifier == "addGroup" {
            d.tournament = self.tournament
        } else if let d = segue.destinationViewController as? GroupTabBarController, tournament = self.tournament where segue.identifier == "showGroup" {
            var group : Group?
            if let cell = sender as? UITableViewCell, indexPath = tableView.indexPathForCell(cell) {
                group = tournament.groups.sorted("time", ascending: false)[indexPath.row]
            } else if let vc = sender as? GroupSettingViewController, g = vc.viewModel.group {
                group = g
            }
            if let g = group {
                d.viewModel = GroupTabViewModel(group: g)
            }
        }
    }
    
    @IBAction func unwindToGroupList(segue: UIStoryboardSegue) {
        backgroundThread(0.1, background: nil) {
            if let sender = segue.sourceViewController as? GroupSettingViewController where segue.identifier == "unwindToGroupAndSave" {
                self.performSegueWithIdentifier("showGroup", sender: sender)
            }
        }
    }
    
    @IBAction func editTapped(sender: AnyObject) {
        if let tourney = tournament {
            self.textField.text = tourney.name
        } else {
            self.textField.text = ""
        }
        self.textField.hidden = false
        self.textField.becomeFirstResponder()
    }
    
}
