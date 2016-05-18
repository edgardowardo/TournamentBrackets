//
//  AppDelegate.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 15/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import UIKit

let formatter: NSDateFormatter = {
    let f = NSDateFormatter()
    f.timeStyle = .LongStyle
    return f
}()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let pageController = UIPageControl.appearance()
        pageController.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageController.currentPageIndicatorTintColor = UIColor.blackColor()
        pageController.backgroundColor = UIColor.whiteColor()
        
        return true
    }

}

