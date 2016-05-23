//
//  TeamStatsHeaderView.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 23/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class TeamStatsHeaderView : UIView {
    
    @IBOutlet weak var teamStack: UIStackView!
    @IBOutlet weak var labelPlayed: UILabel!
    @IBOutlet weak var labelPointsFor: UILabel!
    @IBOutlet weak var labelPointsAgainst: UILabel!
    @IBOutlet weak var labelPointsDifference: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = backgroundColor?.colorWithAlphaComponent(0.9)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(rotated), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        rotated()
    }
    
    func rotated() {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
            teamStack.addArrangedSubview(labelPointsFor)
            teamStack.addArrangedSubview(labelPointsAgainst)
            teamStack.addArrangedSubview(labelPointsDifference)
        }
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)) {
            teamStack.removeArrangedSubview(labelPointsFor)
            teamStack.removeArrangedSubview(labelPointsAgainst)
            teamStack.removeArrangedSubview(labelPointsDifference)
        }
    }
}