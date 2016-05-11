//
//  Wireframe.swift
//  Example
//
//  Created by Krunoslav Zaher on 4/3/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
import RxSwift
#endif

#if os(iOS)
import UIKit
#elseif os(OSX)
import Cocoa
#endif

enum RetryResult {
    case Retry
    case Cancel
}

protocol Wireframe {
    func openURL(URL: NSURL)
    func promptFor<Action: CustomStringConvertible>(message: String, cancelAction: Action, actions: [Action]) -> Observable<Action>
}


class DefaultWireframe: Wireframe {
    static let sharedInstance = DefaultWireframe()

    static func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func openURL(URL: NSURL) {
        #if os(iOS)
            UIApplication.sharedApplication().openURL(URL)
        #elseif os(OSX)
            NSWorkspace.sharedWorkspace().openURL(URL)
        #endif
    }

    #if os(iOS)
    private static func rootViewController() -> UIViewController {
        // cheating, I know
        return UIApplication.sharedApplication().keyWindow!.rootViewController!
    }
    #endif

    static func presentAlert(message: String) {
        #if os(iOS)
            let alertView = UIAlertController(title: "RxExample", message: message, preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel) { _ in
            })
            rootViewController().presentViewController(alertView, animated: true, completion: nil)
        #endif
    }

    func promptFor<Action : CustomStringConvertible>(message: String, cancelAction: Action, actions: [Action]) -> Observable<Action> {
        #if os(iOS)
        return Observable.create { observer in
            let alertView = UIAlertController(title: "RxExample", message: message, preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: cancelAction.description, style: .Cancel) { _ in
                observer.on(.Next(cancelAction))
            })

            for action in actions {
                alertView.addAction(UIAlertAction(title: action.description, style: .Default) { _ in
                    observer.on(.Next(action))
                })
            }

            DefaultWireframe.rootViewController().presentViewController(alertView, animated: true, completion: nil)

            return AnonymousDisposable {
                alertView.dismissViewControllerAnimated(false, completion: nil)
            }
        }
        #elseif os(OSX)
            return Observable.error(NSError(domain: "Unimplemented", code: -1, userInfo: nil))
        #endif
    }
}


extension RetryResult : CustomStringConvertible {
    var description: String {
        switch self {
        case .Retry:
            return "Retry"
        case .Cancel:
            return "Cancel"
        }
    }
}