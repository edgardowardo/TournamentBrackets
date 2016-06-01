//
//  RemoveAdvertsViewController.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 01/06/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class RemoveAdvertsViewController: ViewController {
 
    @IBOutlet weak var buttonRemoveAdverts: UIButton!
    @IBOutlet weak var buttonRestore: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let b = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = b
        self.title = "Remove Adverts"
        
        self.buttonRemoveAdverts
            .rx_tap
            .asObservable()
            .subscribeNext { (_) in
                AppObject.sharedInstance?.isAdsShown = false
                self.cancel()
            }
            .addDisposableTo(disposeBag)
    }
    
    @IBAction func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}