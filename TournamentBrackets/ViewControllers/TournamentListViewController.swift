//
//  TournamentListViewController.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 29/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import UIKit

import UIColor_FlatColors
import GoogleMobileAds
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

class TournamentListViewController: ViewController, UITextFieldDelegate {

    let realm = try! Realm()
    let bag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
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
    
    // MARK: - View lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadInputViews()
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())
        
        //
        // Observe the list
        //
        let tourneys = realm.objects(Tournament).sorted("time", ascending: false).asObservableArray()
        tourneys.bindTo(tableView.rx_itemsWithCellIdentifier("Cell", cellType: UITableViewCell.self)) {row, element, cell in
            cell.textLabel?.text = element.name
            cell.detailTextLabel?.text = "\(element.groups.count) groups"
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
        if let d = segue.destinationViewController as? GroupListViewController, cell = sender as? UITableViewCell, indexPath = tableView.indexPathForCell(cell) where segue.identifier == "showTournament" {
            let tourneys = realm.objects(Tournament).sorted("time", ascending: false)
            d.tournament = tourneys[indexPath.row]
        }
    }
    
    @IBAction func addTap(sender: AnyObject) {
        self.textField.text = ""
        self.textField.hidden = false
        self.textField.becomeFirstResponder()
    }
}