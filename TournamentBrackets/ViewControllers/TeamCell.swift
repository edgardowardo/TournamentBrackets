//
//  TeamCell.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 05/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import UIKit

class TeamCell : UITableViewCell {
    @IBOutlet weak var textSeed: UILabel!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textHandicapPoints: UITextField!
    
    var team : Team? {
        didSet {
            self.layoutCell()
        }
    }
    
    private func layoutCell() {
        if let t = team {
            self.textSeed.text = "\(t.seed)."
            self.textName.text = t.name
            self.textHandicapPoints.text = "\(t.handicap)"
        }
    }
}
