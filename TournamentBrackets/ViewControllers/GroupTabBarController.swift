//
//  GroupTabBarController.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 19/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import GoogleMobileAds

class GroupTabBarController : UITabBarController {
    
    var interstitial: GADInterstitial!
    var viewModel : GroupTabViewModel! {
        didSet {
            self.title = self.viewModel.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let b = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(edit))
        let s = UIBarButtonItem(image: UIImage(named: "icon-share-white"), style: .Plain, target: self, action: #selector(share))
        self.navigationItem.rightBarButtonItems = [b,s]
        
        if let viewControllers = self.viewControllers {
            for (index, vc) in viewControllers.enumerate() {
                if let c = vc as? GroupDetailViewController {
                    c.viewModel = GroupDetailViewModel(group: viewModel.group, gameViewModels: viewModel.gameViewModels, isLoserBracket: (index == 1))
                } else if let c = vc as? TeamStatsListViewController {
                    c.viewModel = TeamStatsListViewModel(group: viewModel.group)
                } else if let c = vc as? ChartsViewController {
                    c.viewModel = ChartsViewModel(group: viewModel.group)
                }
            }
            if viewModel.group.schedule != .DoubleElimination {
                var newVCs = viewControllers
                newVCs.removeAtIndex(1)
                setViewControllers(newVCs, animated: false)
            }
        }
        
        if AppObject.sharedInstance?.isAdsShown == true {
            loadInterstitial()
            showInterstitial()
        }
    }

    @IBAction func share(sender: AnyObject) {
        guard MFMailComposeViewController.canSendMail() else { return }
        let name = viewModel.group.name
        let vc = MFMailComposeViewController()
        let html = "<p>Hello there!</p><p>Here is a copy of \(name).</p><p>You will need <a href=\"https://itunes.apple.com/gb/app/tournament-scheduler/id1091203816?mt=8.\">Tournament Scheduler</a>&nbsp;to open it.&nbsp;</p>"
        vc.navigationBar.tintColor = UIColor.whiteColor()
        vc.mailComposeDelegate = self
        vc.setSubject("Tournament Scheduler - \(name)")
        vc.setMessageBody(html, isHTML: true)
        vc.addAttachmentData(viewModel.share(), mimeType: "text", fileName: "group.schd")
        self.presentViewController(vc, animated: true) { UIApplication.sharedApplication().statusBarStyle = .LightContent }
    }
    
    @IBAction func edit(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("GroupSettingViewController") as! GroupSettingViewController
        vc.viewModel = GroupSettingViewModel(group: viewModel.group)
        let nc = UINavigationController(rootViewController: vc)
        presentViewController(nc, animated: true, completion: nil)
    }
}

extension GroupTabBarController : GADInterstitialDelegate {
    func interstitialDidFailToReceiveAdWithError(interstitial: GADInterstitial, error: GADRequestError) {
        print("\(error.localizedDescription)")
    }
    func loadInterstitial() {
        //interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910") // TEST
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-8499873478400384/2491617153") // LIVE
        interstitial?.delegate = self
        let r = GADRequest()
        r.testDevices = [kGADSimulatorID]
        interstitial?.loadRequest(GADRequest())
    }
    func showInterstitial() {
        backgroundThread(2.0) { 
            if self.interstitial?.isReady == true {
                self.interstitial?.presentFromRootViewController(self)
            }
        }
    }
}

extension GroupTabBarController : MFMailComposeViewControllerDelegate {
    func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
