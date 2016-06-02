//
//  ViewController.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 4/25/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation
import MBProgressHUD
import RxSwift
import RealmSwift
import GoogleMobileAds

class ViewController: UIViewController {
    #if TRACE_RESOURCES
    #if !RX_NO_MODULE
    private let startResourceCount = RxSwift.resourceCount
    #else
    private let startResourceCount = resourceCount
    #endif
    #endif
    
    let realm = try! Realm()
    var disposeBag = DisposeBag()
    @IBOutlet var constraintTableViewToSuperView: NSLayoutConstraint!
    @IBOutlet weak var advertView: UIView!
    @IBOutlet weak var buttonRemoveAdvert: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    // MARK: - View lifecycle -
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if AppObject.sharedInstance?.isAdsShown == false {
            self.removeAds()
        }
    }
    
    override func viewDidLoad() {
        #if TRACE_RESOURCES
            print("Number of start resources = \(resourceCount)")
        #endif

        if let bv = bannerView, button = buttonRemoveAdvert where AppObject.sharedInstance?.isAdsShown == true {
            bannerView.adUnitID = "ca-app-pub-8499873478400384/8183934759" // Live ID
            bv.rootViewController =  (self.tabBarController) ?? self
            bv.loadRequest(GADRequest())
            button.backgroundColor = UIColor.flatAlizarinColor()
        }
        
        //
        // Observe AppObject
        //
        realm.objects(AppObject)
            .asObservableArray()
            .subscribeNext { (objects) in
                if let a = objects.first where a.isAdsShown == false {
                    self.removeAds()
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    deinit {
        #if TRACE_RESOURCES
            print("View controller disposed with \(resourceCount) resources")
            
            /*
             !!! This cleanup logic is adapted for example app use case. !!!
             
             It is being used to detect memory leaks during pre release tests.
             
             !!! In case you want to have some resource leak detection logic, the simplest
             method is just printing out `RxSwift.resourceCount` periodically to output. !!!
             
             
             /* add somewhere in
             func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
             */
             _ = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
             .subscribeNext { _ in
             print("Resource count \(RxSwift.resourceCount)")
             }
             
             Most efficient way to test for memory leaks is:
             * navigate to your screen and use it
             * navigate back
             * observe initial resource count
             * navigate second time to your screen and use it
             * navigate back
             * observe final resource count
             
             In case there is a difference in resource count between initial and final resource counts, there might be a memory
             leak somewhere.
             
             The reason why 2 navigations are suggested is because first navigation forces loading of lazy resources.
             */
            
            let numberOfResourcesThatShouldRemain = startResourceCount
            let mainQueue = dispatch_get_main_queue()
            /*
             This first `dispatch_async` is here to compensate for CoreAnimation delay after
             changing view controller hierarchy. This time is usually ~100ms on simulator and less on device.
             
             If somebody knows more about why this delay happens, you can make a PR with explanation here.
             */
            dispatch_async(mainQueue) {
                
                /*
                 Some small additional period to clean things up. In case there were async operations fired,
                 they can't be cleaned up momentarily.
                 */
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC)))
                dispatch_after(time, mainQueue) {
                    // If this fails for you while testing, and you've been clicking fast, it's ok, just click slower,
                    // this is a debug build with resource tracing turned on.
                    //
                    // If this crashes when you've been clicking slowly, then it would be interesting to find out why.
                    // ¯\_(ツ)_/¯
                    assert(resourceCount <= numberOfResourcesThatShouldRemain, "Resources weren't cleaned properly")
                }
            }
        #endif
    }
    
    func showHud(text text : String) {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.dimBackground = true
        hud.labelText = text
    }
    
    func hideHud() {
        MBProgressHUD.hideAllHUDsForView(view, animated: true)
    }
    
    func removeAds() {
        guard let av = advertView, c = constraintTableViewToSuperView else { return }
        
        backgroundThread(background: nil) {
            av.hidden = true
            c.active = true
        }
    }
    
}