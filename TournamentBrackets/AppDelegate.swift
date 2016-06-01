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
        
        let pageController = UIPageControl.appearance()
        pageController.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageController.currentPageIndicatorTintColor = UIColor.blackColor()
        pageController.backgroundColor = UIColor.clearColor()
        
        // Use Firebase library to configure APIs
        FIRApp.configure()
        
        AppObject.loadAppData()
        
        return true
    }

}

