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
    
    @IBOutlet weak var labelPlayed: UILabel!
    @IBOutlet weak var labelPointsFor: UILabel!
    @IBOutlet weak var labelPointsAgainst: UILabel!
    @IBOutlet weak var labelPointsDifference: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = backgroundColor?.colorWithAlphaComponent(0.9)
    }    
}