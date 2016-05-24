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
    @IBOutlet weak var labelDrawn: UILabel!
    @IBOutlet weak var labelPointsFor: UILabel!
    @IBOutlet weak var labelPointsAgainst: UILabel!
    @IBOutlet weak var labelPointsDifference: UILabel!
    
    var viewModel : TeamStatsViewModel! {
        didSet {
            labelSeed.text = viewModel.seed
            labelDirection.text = viewModel.seedDirection
            labelSeedDelta.text = viewModel.seedDelta
            labelTeamName.text = viewModel.name
            labelPlayed.text = viewModel.countPlayed
            labelWon.text = viewModel.countWins
            labelLost.text = viewModel.countLost
            labelDrawn.text = viewModel.countDrawn
            labelPointsFor.text = viewModel.pointsFor
            labelPointsAgainst.text = viewModel.pointsAgainst
            labelPointsDifference.text = viewModel.pointsDifference
        }
    }
}