//
//  UISegmentedControl+Multiline.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 04/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    var imageFromLayer : UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UISegmentedControl {
 
    func setImageAsMultilineTitle(title : String, atIndex segment : Int) {

        let label = UILabel(frame: CGRectZero)
        label.textColor = self.tintColor
        label.backgroundColor = UIColor.clearColor()
        label.font = UIFont.systemFontOfSize(13)
        label.textAlignment = .Center
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 0
        label.text = title
        label.sizeToFit()
  
        self.setImage(label.imageFromLayer, forSegmentAtIndex: segment)
    }
}