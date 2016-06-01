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

class RemoveAdvertsViewController: UIViewController {
 
    @IBOutlet weak var buttonRemoveAdverts: UIButton!
    @IBOutlet weak var buttonRestore: UIButton!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let b = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = b
        self.title = "Remove Adverts"
        
        let cornerRadius = buttonRemoveAdverts.frame.size.height / 5
        buttonRemoveAdverts.layer.cornerRadius = cornerRadius
        buttonRestore.layer.cornerRadius = cornerRadius
        
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