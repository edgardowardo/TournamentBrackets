//
//  TeamStatsCell.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 22/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class TeamStatsCell : UITableViewCell {
 
    @IBOutlet weak var labelSeed: UILabel!
    @IBOutlet weak var labelDirection: UILabel!
    @IBOutlet weak var labelSeedDelta: UILabel!
    @IBOutlet weak var labelTeamName: UILabel!
    @IBOutlet weak var labelPlayed: UILabel!
    @IBOutlet weak var labelWon: UILabel!
    @IBOutlet weak var labelLost: UILabel!
    @IBOutlet weak var labelPointsFor: UILabel!
    @IBOutlet weak var labelPointsAgainst: UILabel!
    @IBOutlet weak var labelPointsDifference: UILabel!
    @IBOutlet weak var teamStack: UIStackView!
    
    var viewModel : TeamStatsViewModel! {
        didSet {
            labelSeed.text = viewModel.seed
            labelDirection.text = viewModel.seedDirection
            labelSeedDelta.text = viewModel.seedDelta
            labelTeamName.text = viewModel.name
            labelPlayed.text = viewModel.countPlayed
            labelWon.text = viewModel.countWins
            labelLost.text = viewModel.countLost
            labelPointsFor.text = viewModel.pointsFor
            labelPointsAgainst.text = viewModel.pointsAgainst
            labelPointsDifference.text = viewModel.pointsDifference
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(rotated), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            rotated()
        }
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