//
//  ChartsViewController.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 25/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class ChartBaseViewController : ViewController {
    var pageIndex : Int {
        get {
            return 0
        }
    }
}

class ChartsViewController : UIViewController {
    
    var viewModel : ChartsViewModel!
    var pageViewController : UIPageViewController!
    var viewControllers : [ChartBaseViewController]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = TournamentChart.all.map{ (chart) in viewControllerForTournamentChart(chart) }
        self.pageViewController.dataSource = self
        self.pageViewController.setViewControllers([viewControllers[0]], direction: .Forward, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let pageVC = segue.destinationViewController as? UIPageViewController where segue.identifier == "segueEmbedPageVC" {
            self.pageViewController = pageVC
        }
    }
    
    func viewControllerForTournamentChart(chart : TournamentChart) -> ChartBaseViewController {
        guard let storyboard = self.storyboard else { return ChartBaseViewController() }
        switch chart {
        case .Played:
            fallthrough
        case .Won:
            fallthrough
        case .Earned:
            fallthrough
        case .Conceded:
            let vc = storyboard.instantiateViewControllerWithIdentifier("ChartPieViewController") as! ChartPieViewController
            vc.viewModel = ChartsPieViewModel(group: viewModel.group, chartType: chart, helper: viewModel.helper)
            return vc
        case .PlayedPerTeam:
            let vc = storyboard.instantiateViewControllerWithIdentifier("ChartHorizontalBarViewController") as! ChartHorizontalBarViewController
            vc.viewModel = ChartsHorizontalBarViewModel(group: viewModel.group, chartType: chart, helper: viewModel.helper)
            return vc
        }
    }
}


extension ChartsViewController : UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ChartBaseViewController
        var index = vc.pageIndex
        
        if (index == 0 || index == NSNotFound) {
            return nil
        }
        
        index = index - 1
        
        return self.viewControllers[index]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ChartBaseViewController
        var index = vc.pageIndex
        
        if (index == NSNotFound) {
            return nil
        }
        
        index = index + 1
        
        if index == self.viewControllers.count {
            return nil
        }
        
        return self.viewControllers[index]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.viewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
