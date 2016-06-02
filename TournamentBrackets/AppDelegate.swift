//
//  AppDelegate.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 15/04/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit
import Firebase

let formatter: NSDateFormatter = {
    let f = NSDateFormatter()
    f.timeStyle = .LongStyle
    return f
}()

let font9 = UIFont(name: "RoundedEleganceNew-Regular", size: 9)!
let font11 = UIFont(name: "RoundedEleganceNew-Regular", size: 11)!
let font15 = UIFont(name: "RoundedEleganceNew-Regular", size: 15)!
let font17 = UIFont(name: "RoundedEleganceNew-Regular", size: 17)!
let font20 = UIFont(name: "RoundedEleganceNew-Regular", size: 20)!

func backgroundThread(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
        if(background != nil){ background!(); }
        
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue()) {
            if(completion != nil){ completion!(); }
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        FIRApp.configure()
        AppObject.loadAppData()
        reskinApp(application)
        return true
    }
    
    func reskinApp(application: UIApplication) {
        
        application.statusBarStyle = .LightContent
        
        let pageController = UIPageControl.appearance()
        pageController.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageController.currentPageIndicatorTintColor = UIColor.blackColor()
        pageController.backgroundColor = UIColor.clearColor()
        
        UINavigationBar.appearance().barTintColor = UIColor.flatCarrotColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font20, NSForegroundColorAttributeName : UIColor.whiteColor()]

        UITextField.appearanceWhenContainedInInstancesOfClasses([UIView.self]).font = font17
        UILabel.appearanceWhenContainedInInstancesOfClasses([UIButton.self]).font = font15
        UITabBar.appearance().tintColor = UIColor.flatCarrotColor()
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: font11], forState: .Normal)
        UISegmentedControl.appearance().tintColor = UIColor.flatCarrotColor()
        
    }
}

