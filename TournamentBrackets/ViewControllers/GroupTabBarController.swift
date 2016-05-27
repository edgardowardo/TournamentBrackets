//
//  GroupTabBarController.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 19/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class GroupTabBarController : UITabBarController {
    
    var viewModel : GroupTabViewModel! {
        didSet {
            self.title = self.viewModel.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let b = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(edit))
        self.navigationItem.rightBarButtonItem = b
        
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
    }
    
    @IBAction func edit(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("GroupSettingViewController") as! GroupSettingViewController
        vc.viewModel = GroupSettingViewModel(group: viewModel.group)
        //        vc.tournament = TODO: pass this into the viewModel
        let nc = UINavigationController(rootViewController: vc)
        presentViewController(nc, animated: true, completion: nil)
    }
}