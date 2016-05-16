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
            
            self.backgroundColor = viewModel.isLoserBracket ? UIColor.flatAsbestosColor().colorWithAlphaComponent(0.3) : UIColor.clearColor()
            self.indexLabel.text = "\(viewModel.index)"
            self.leftTeamButton.setTitle(viewModel.leftPrompt, forState: .Normal)
            self.rightTeamButton.setTitle(viewModel.rightPrompt, forState: .Normal)
            self.leftTeamButton.enabled = viewModel.leftPrompt != "BYE"
            self.rightTeamButton.enabled = viewModel.rightPrompt != "BYE"
            
            self.viewModel.leftTeam
                .asObservable()
                .subscribeNext { _ in
                    self.leftTeamButton.setTitle(self.viewModel.leftPrompt, forState: .Normal)
                }
                .addDisposableTo(disposeBag)
            
            self.viewModel.rightTeam
                .asObservable()
                .subscribeNext { _ in
                    self.rightTeamButton.setTitle(self.viewModel.rightPrompt, forState: .Normal)
                }
                .addDisposableTo(disposeBag)
            
            self.viewModel.winner
                .asObservable()
                .subscribeNext { [unowned self] winner in
                    
                    let winningColor = self.viewModel.isFinalElimination ? UIColor.flatCarrotColor().colorWithAlphaComponent(4.0) : UIColor.flatEmeraldColor().colorWithAlphaComponent(0.75)
                    let winningTextColor = UIColor.whiteColor()
                    let losingColor = UIColor.flatCloudsColor()
                    let losingTextColor = UIColor.init(colorLiteralRed: 0.0, green: 0.478431, blue: 1.0, alpha: 1.0)
                    let disabledTextColor = UIColor.init(colorLiteralRed: 176/256, green: 177/256, blue: 179/256, alpha: 1.0)
                    
                    if let winningTeam = winner {
                        if let left = self.viewModel.leftTeam.value where left.id == winningTeam.id {
                            self.leftTeamButton.backgroundColor = winningColor
                            self.leftTeamButton.setTitleColor(winningTextColor, forState: .Normal)
                            self.rightTeamButton.backgroundColor = losingColor
                            self.rightTeamButton.setTitleColor(losingTextColor, forState: .Normal)
                        } else if let right = self.viewModel.rightTeam.value where right.id == winningTeam.id {
                            self.leftTeamButton.backgroundColor = losingColor
                            self.leftTeamButton.setTitleColor(losingTextColor, forState: .Normal)
                            self.rightTeamButton.backgroundColor = winningColor
                            self.rightTeamButton.setTitleColor(winningTextColor, forState: .Normal)
                        }
                    } else {
                        self.leftTeamButton.backgroundColor = losingColor
                        self.leftTeamButton.setTitleColor(losingTextColor, forState: .Normal)
                        self.rightTeamButton.backgroundColor = losingColor
                        self.rightTeamButton.setTitleColor(losingTextColor, forState: .Normal)
                    }
                    
                    self.leftTeamButton.setTitleColor(disabledTextColor, forState: .Disabled)
                    self.rightTeamButton.setTitleColor(disabledTextColor, forState: .Disabled)
                }
                .addDisposableTo(disposeBag)
            
            self.leftTeamButton
                .rx_tap
                .asObservable()
                .subscribeNext{ [unowned self] something in
                    self.viewModel.setLeftTeamAsWinner()
                }
                .addDisposableTo(disposeBag)
            
            self.rightTeamButton
                .rx_tap
                .asObservable()
                .subscribeNext{ [unowned self] something in
                    self.viewModel.setRightTeamAsWinner()
                }
                .addDisposableTo(disposeBag)
            
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