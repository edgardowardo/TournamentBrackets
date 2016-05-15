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
                    if let winningTeam = winner {
                        if let left = self.viewModel.leftTeam.value where left.id == winningTeam.id {
                            self.leftTeamButton.backgroundColor = UIColor.flatEmeraldColor().colorWithAlphaComponent(0.5)
                            self.rightTeamButton.backgroundColor = UIColor.flatCloudsColor()
                        } else if let right = self.viewModel.rightTeam.value where right.id == winningTeam.id {
                            self.leftTeamButton.backgroundColor = UIColor.flatCloudsColor()
                            self.rightTeamButton.backgroundColor = UIColor.flatEmeraldColor().colorWithAlphaComponent(0.5)
                        }
                    } else {
                        self.leftTeamButton.backgroundColor = UIColor.flatCloudsColor()
                        self.rightTeamButton.backgroundColor = UIColor.flatCloudsColor()
                    }
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