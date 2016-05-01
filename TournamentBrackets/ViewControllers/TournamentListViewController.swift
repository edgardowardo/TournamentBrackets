//
//  TournamentListViewController.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 29/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import UIKit

import UIColor_FlatColors

import RxSwift
import RxCocoa

import RealmSwift
import RxRealm

class TournamentListViewController: ViewController, UITextFieldDelegate {

    let realm = try! Realm()
    let bag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    lazy var textField : UITextField = {
        let textfield = UITextField(frame: CGRectMake(0, 0, 10, 44))
        textfield.clearButtonMode = .Always
        textfield.borderStyle = .RoundedRect
        textfield.returnKeyType = .Done
        textfield.backgroundColor = UIColor.flatCloudsColor()
        textfield.delegate = self
        textfield.hidden = true
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
        if let text = textField.text where text.characters.count > 0 {
            let tourney = Tournament()
            tourney.name = text
            try! realm.write {
                realm.add(tourney)
            }
        }
        textField.resignFirstResponder()
        textField.hidden = true
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadInputViews()
        
        let add = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addTapped))
        
        navigationItem.rightBarButtonItems = [add]
        
        //
        // Observe for the title with count
        //
        let tourneyCount = realm.objects(Tournament).asObservable().map {tourneys in "Tournaments (\(tourneys.count))"}
        tourneyCount.subscribeNext { [unowned self] text in
            self.title = text
            }.addDisposableTo(bag)

        //
        // Observe the list
        //
        let tourneys = realm.objects(Tournament).sorted("time", ascending: false).asObservableArray()
        tourneys.bindTo(tableView.rx_itemsWithCellIdentifier("Cell", cellType: UITableViewCell.self)) {row, element, cell in
            cell.textLabel!.text = element.name
            }.addDisposableTo(bag)

        //
        // Observe the delete swipe
        //
        tableView.rx_itemDeleted
            .subscribeNext { [unowned self] indexPath in
                let t = self.realm.objects(Tournament).sorted("time", ascending: false)
                try! self.realm.write {
                    self.realm.delete(t[indexPath.row])
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    func addTapped(sender: UIBarButtonItem) {
        self.textField.text = ""
        self.textField.hidden = false
        self.textField.becomeFirstResponder()
    }
    
}