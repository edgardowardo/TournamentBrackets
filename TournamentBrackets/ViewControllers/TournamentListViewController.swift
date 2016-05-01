//
//  TournamentListViewController.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 29/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import RealmSwift
import RxRealm

class TournamentListViewController: ViewController {
    
    let bag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let edit = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addTapped))
        let play = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: #selector(addTapped))
        
        navigationItem.rightBarButtonItems = [edit, play]
        
        let realm = try! Realm()
        let tourneyCount = realm.objects(Tournament).asObservable().map {tourneys in "Tournaments (\(tourneys.count))"}
        tourneyCount.subscribeNext {[unowned self]text in
            self.title = text
            }.addDisposableTo(bag)
        
        let tourneys = realm.objects(Tournament).sorted("time", ascending: false).asObservableArray()
        tourneys.bindTo(tableView.rx_itemsWithCellIdentifier("Cell", cellType: UITableViewCell.self)) {row, element, cell in
            cell.textLabel!.text = formatter.stringFromDate(NSDate(timeIntervalSinceReferenceDate: element.time))
            }.addDisposableTo(bag)
    }
    
    func addTapped() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(Tournament())
        }
    }
    
}