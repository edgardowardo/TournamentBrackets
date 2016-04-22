//
//  RootViewController.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 21/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public class RootViewController : UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
            ])
        
        items
            .bindTo(tableView.rx_itemsWithCellIdentifier("Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .addDisposableTo(disposeBag)
        
        
        tableView
            .rx_modelSelected(String)
            .subscribeNext { value in
                DefaultWireframe.presentAlert("Tapped `\(value)`")
            }
            .addDisposableTo(disposeBag)
        
        tableView
            .rx_itemAccessoryButtonTapped
            .subscribeNext { indexPath in
                DefaultWireframe.presentAlert("Tapped Detail @ \(indexPath.section),\(indexPath.row)")
            }
            .addDisposableTo(disposeBag)
        
    }
}