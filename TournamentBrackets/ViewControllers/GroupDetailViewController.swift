//
//  GroupDetailViewController.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 17/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class GroupDetailViewController: ViewController {

    var pageViewController : UIPageViewController!
    var viewModel : GroupDetailViewModel! {
        didSet {
            self.title = self.viewModel.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("GamePagesViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let startVC = self.viewControllerAtIndex(0)
        let viewControllers = [startVC]
        
        self.pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRectMake(0, 70, self.view.frame.width, self.view.frame.height - 100)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
    }
    
    func viewControllerAtIndex(index : Int) -> GameListViewController {
        
        guard viewModel.rounds.count > 0 && index < viewModel.rounds.count else {
            return GameListViewController()
        }
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("GameListViewController") as! GameListViewController
        let round = viewModel.rounds[index]
        var gameListViewModel = GameListViewModel(group: self.viewModel.group, gameViewModels: self.viewModel.gameViewModels, round: round, isLoserBracket: self.viewModel.showLoserBracket.value)
        gameListViewModel.pageIndex = index
        vc.viewModel = gameListViewModel
        
        return vc
    }
    
 
    
}

extension GroupDetailViewController : UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! GameListViewController
        var index = vc.viewModel.pageIndex as Int
        
        if (index == 0 || index == NSNotFound) {
            return nil
        }
        
        index = index - 1
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! GameListViewController
        var index = vc.viewModel.pageIndex as Int
        
        if (index == NSNotFound) {
            return nil
        }
        
        index = index + 1
        
        if index == self.viewModel.rounds.count {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
        
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.viewModel.rounds.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
