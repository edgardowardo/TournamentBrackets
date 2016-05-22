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
        
        if let viewControllers = self.viewControllers {
            for (index, vc) in viewControllers.enumerate() {
                if let groupDetailVC = vc as? GroupDetailViewController {
                    groupDetailVC.viewModel = GroupDetailViewModel(group: viewModel.group, gameViewModels: viewModel.gameViewModels, isLoserBracket: (index == 1))
                } else if let teamStatsVC = vc as? TeamStatsListViewController {
                    teamStatsVC.viewModel = TeamStatsListViewModel(group: viewModel.group)
                }
            }
            if viewModel.group.schedule != .DoubleElimination {
                var newVCs = viewControllers
                newVCs.removeAtIndex(1)
                setViewControllers(newVCs, animated: false)
            }
        }
    }
}