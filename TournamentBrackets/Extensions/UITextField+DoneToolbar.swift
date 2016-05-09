//
//  UITextField+DoneToolbar.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 09/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

extension UIToolbar {
    struct Size {
        static let Width = UIScreen.mainScreen().bounds.size.width
        static let Height = CGFloat(44 )
    }
}

extension UITextField {
    func addDoneToolbar(leftbuttons : [UIBarButtonItem] = [], rightbuttons : [UIBarButtonItem] = []) {
        let doneToolbar = UIToolbar(frame: CGRectMake(0, 0, UIToolbar.Size.Width, UIToolbar.Size.Height))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(doneTappedGeneric))
        doneToolbar.setItems(leftbuttons + [flexibleSpace] + rightbuttons + [doneButton], animated: true)
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
    func doneTappedGeneric() {
        self.resignFirstResponder()
    }
}

