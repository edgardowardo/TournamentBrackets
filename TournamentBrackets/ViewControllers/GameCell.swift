//
//  GameCell.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 13/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import UIKit

class GameCell : UITableViewCell {

    @IBOutlet weak var leftScoreTextField: UITextField!
    @IBOutlet weak var leftTeamButton: UIButton!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var rightTeamButton: UIButton!
    @IBOutlet weak var rightScoreTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        leftTeamButton.backgroundColor = UIColor.flatCloudsColor()
        leftTeamButton.layer.cornerRadius = leftTeamButton.frame.size.height / 5
        rightTeamButton.backgroundColor = UIColor.flatCloudsColor()
        rightTeamButton.layer.cornerRadius = rightTeamButton.frame.size.height / 5
    }
}