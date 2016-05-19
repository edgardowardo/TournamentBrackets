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
    var viewControllers : [GameListViewController]!
    var viewModel : GroupDetailViewModel!
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let item = tabBarItem {
            item.title = viewModel.mainTitle
            item.image = UIImage(named: viewModel.mainIconName)
        }
        
        let color : UIColor = viewModel.isLoserBracket ? UIColor().loserBackgroundColor : UIColor.clearColor()
        self.pageViewController.view.backgroundColor = color
        self.pageViewController.dataSource = self
        self.viewControllers = self.viewModel.rounds.map{ (index) in self.viewControllerAtIndex(index - viewModel.indexOffset) }
        
        // scroll to first unfinished or last one
        let unfinished = self.viewControllers.filter{ (vc) in !vc.viewModel.isRoundFinished }.first
        if let u = unfinished, index = self.viewControllers.indexOf(u) {
            selectedIndex = index
        } else {
            selectedIndex = self.viewControllers.count - 1
        }
        
        // load all controllers! and only one scrolling to top!
        for i in 0 ..< self.viewModel.rounds.count {
            self.pageViewController.setViewControllers([viewControllers[i]], direction: .Forward, animated: true, completion: nil)
            viewControllers[i].tableView.scrollsToTop = false
        }
        self.pageViewController.setViewControllers([viewControllers[selectedIndex]], direction: .Forward, animated: true, completion: nil)
        viewControllers[selectedIndex].tableView.scrollsToTop = true
    }
    
    func viewControllerAtIndex(index : Int) -> GameListViewController {
        
        guard viewModel.rounds.count > 0 && index < viewModel.rounds.count else {
            return GameListViewController()
        }
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("GameListViewController") as! GameListViewController
        let round = viewModel.rounds[index]
        var gameListViewModel = GameListViewModel(group: self.viewModel.group, gameViewModels: self.viewModel.gameViewModels, round: round, isLoserBracket: self.viewModel.isLoserBracket)
        gameListViewModel.pageIndex = index
        vc.viewModel = gameListViewModel
        
        return vc
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let pageVC = segue.destinationViewController as? UIPageViewController where segue.identifier == "segueEmbedPageVC" {
            self.pageViewController = pageVC
        }
    }
}

extension GroupDetailViewController : UIPageViewControllerDataSource {
    
    func resetScrollsToTopWithIndex(index : Int) {
        if index-2 >= 0 {
            self.viewControllers[index-2].tableView.scrollsToTop = false
        }
        if index-1 >= 0 {
            self.viewControllers[index-1].tableView.scrollsToTop = false
        }
        self.viewControllers[index].tableView.scrollsToTop = true
        
        if index+1 < self.viewControllers.count {
            self.viewControllers[index+1].tableView.scrollsToTop = false
        }
        if index+2 < self.viewControllers.count {
            self.viewControllers[index+2].tableView.scrollsToTop = false
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! GameListViewController
        var index = vc.viewModel.pageIndex as Int

        resetScrollsToTopWithIndex(index)
        
        if (index == 0 || index == NSNotFound) {
            return nil
        }

        index = index - 1

        return self.viewControllers[index]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! GameListViewController
        var index = vc.viewModel.pageIndex as Int
        
        resetScrollsToTopWithIndex(index)
        
        if (index == NSNotFound) {
            return nil
        }
        
        index = index + 1
        
        if index == self.viewModel.rounds.count {
            return nil
        }

        return self.viewControllers[index]        
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.viewModel.rounds.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.selectedIndex
    }
}
