//
//  GameCell.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 13/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import UIKit
import RxSwift

class GameCell : UITableViewCell {

    @IBOutlet weak var leftScoreTextField: UITextField!
    @IBOutlet weak var leftTeamButton: UIButton!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var rightTeamButton: UIButton!
    @IBOutlet weak var rightScoreTextField: UITextField!

    var disposeBag: DisposeBag?

    var viewModel : GameViewModel! {
        didSet {
            let disposeBag = DisposeBag()

            // TODO: Rx stuff here
            
            self.indexLabel.text = "\(viewModel.index)"
            self.leftTeamButton.setTitle(viewModel.leftPrompt, forState: .Normal)
            self.rightTeamButton.setTitle(viewModel.rightPrompt, forState: .Normal)
            
            self.leftTeamButton.enabled = viewModel.leftPrompt != "BYE"
            self.rightTeamButton.enabled = viewModel.rightPrompt != "BYE"
            
            self.disposeBag = disposeBag
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        leftTeamButton.backgroundColor = UIColor.flatCloudsColor()
        leftTeamButton.layer.cornerRadius = leftTeamButton.frame.size.height / 5
        rightTeamButton.backgroundColor = UIColor.flatCloudsColor()
        rightTeamButton.layer.cornerRadius = rightTeamButton.frame.size.height / 5
    }
    
    internal override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = nil
    }
    
}