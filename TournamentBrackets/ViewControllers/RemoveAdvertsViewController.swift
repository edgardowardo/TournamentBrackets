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
import StoreKit
import MBProgressHUD

class RemoveAdvertsViewController: UIViewController {
    enum Product : String {
        case NoAdverts = "TS_T5_NoAdverts"
    }
    @IBOutlet weak var buttonRemoveAdverts: UIButton!
    @IBOutlet weak var buttonRestore: UIButton!
    let disposeBag = DisposeBag()
    var products : [String : SKProduct] = [String : SKProduct]()
    var hud : MBProgressHUD?
    var transactionInProgress = false
    
    func showHud(text text : String) {
        self.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.hud?.dimBackground = true
        self.hud?.labelText = text
    }
    func hideHud() {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let b = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = b
        self.title = "Remove Adverts"
        
        let cornerRadius = buttonRemoveAdverts.frame.size.height / 5
        buttonRemoveAdverts.layer.cornerRadius = cornerRadius
        buttonRestore.layer.cornerRadius = cornerRadius
        buttonRemoveAdverts.alpha = 0.2
        buttonRemoveAdverts.enabled = false
        buttonRestore.alpha = 0.2
        buttonRestore.enabled = false
        
        self.buttonRemoveAdverts
            .rx_tap
            .asObservable()
            .subscribeNext { (_) in
                self.handleOneoff(self)
            }
            .addDisposableTo(disposeBag)
        
        self.buttonRestore
            .rx_tap
            .asObservable()
            .subscribeNext { (_) in
                self.handleRestore(self)
            }
            .addDisposableTo(disposeBag)
        
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        requestProductInfo()
    }
    
    @IBAction func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func handleOneoff(sender: AnyObject) {
        if transactionInProgress {
            return
        }
        transactionInProgress = true
        let payment = SKPayment(product: self.products[Product.NoAdverts.rawValue]!)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    @IBAction func handleRestore(sender: AnyObject) {
        if transactionInProgress {
            return
        }
        transactionInProgress = true
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }    
    
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            showHud(text: "Requesting apple")
            let productIdentifiers = NSSet(array: [Product.NoAdverts.rawValue])
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            print("Cannot perform In App Purchases.")
        }
    }
}

extension RemoveAdvertsViewController : SKPaymentTransactionObserver {
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        for t in queue.transactions {
            let transaction = t
            if transaction.payment.productIdentifier == Product.NoAdverts.rawValue {
                print("Transaction restored successfully.")
                AppObject.sharedInstance?.isAdsShown = false
                transactionInProgress = false
                self.cancel()
                break
            }
        }
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.Purchased:
                print("Transaction completed successfully.")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                AppObject.sharedInstance?.isAdsShown = false
                transactionInProgress = false
                self.cancel()
            case SKPaymentTransactionState.Failed:
                print("Transaction Failed");
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                transactionInProgress = false
            default:
                print(transaction.transactionState.rawValue)
            }
        }
    }
}

extension RemoveAdvertsViewController : SKProductsRequestDelegate {
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        hideHud()
        if response.products.count != 0 {
            for product in response.products {
                let p = product
                self.products[p.productIdentifier] = p
                switch p.productIdentifier {
                case Product.NoAdverts.rawValue :
                    UIView.animateWithDuration(0.35, animations: { () -> Void in
                        self.buttonRemoveAdverts.alpha = 1.0
                        self.buttonRemoveAdverts.enabled = true
                        self.buttonRestore.alpha = 1.0
                        self.buttonRestore.enabled = true
                    })
                default :
                    assertionFailure("Unknown product")
                }
            }
        }
        else {
            assertionFailure("There are no product")
        }
        if response.invalidProductIdentifiers.count != 0 {
            print("Invalid products: \(response.invalidProductIdentifiers.description)")
        }
    }
}
