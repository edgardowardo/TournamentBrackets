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
    
    var tournament : Tournament? = nil
    let realm = try! Realm()
    let bag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Text field delegate -
    
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

        //
        // Observe changes for the title
        //
        if let id = tournament?.id {
            let tourneyName = realm.objects(Tournament).filter("id == '\(id)'").asObservable()
            tourneyName.subscribeNext {[unowned self] elements in
                if let t = elements.filter("id == '\(id)'").first {
                    self.title = t.name
                }
                }.addDisposableTo(bag)
        }
    }
    
    @IBAction func addTapped(sender: AnyObject) {
    
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