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
            
            self.backgroundColor = UIColor.clearColor()
            self.indexLabel.text = "\(viewModel.index)"
            self.leftTeamButton.setTitle(viewModel.leftPrompt, forState: .Normal)
            self.rightTeamButton.setTitle(viewModel.rightPrompt, forState: .Normal)
            self.leftTeamButton.enabled = viewModel.leftPrompt != "BYE"
            self.rightTeamButton.enabled = viewModel.rightPrompt != "BYE"
            self.leftScoreTextField.enabled = !(viewModel.leftPrompt == "BYE" || viewModel.rightPrompt == "BYE")
            self.rightScoreTextField.enabled = !(viewModel.leftPrompt == "BYE" || viewModel.rightPrompt == "BYE")
            
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
                    
                    let winningColor = self.viewModel.isFinalElimination ? UIColor.flatCarrotColor() : UIColor.flatEmeraldColor()
                    let drawnColor = UIColor.flatPeterRiverColor()
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
                        if self.viewModel.game.isDraw {
                            self.leftTeamButton.backgroundColor = drawnColor
                            self.leftTeamButton.setTitleColor(winningTextColor, forState: .Normal)
                            self.rightTeamButton.backgroundColor = drawnColor
                            self.rightTeamButton.setTitleColor(winningTextColor, forState: .Normal)
                        } else {
                            self.leftTeamButton.backgroundColor = losingColor
                            self.leftTeamButton.setTitleColor(losingTextColor, forState: .Normal)
                            self.rightTeamButton.backgroundColor = losingColor
                            self.rightTeamButton.setTitleColor(losingTextColor, forState: .Normal)
                        }
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
            
            self.leftScoreTextField.text = "\(self.viewModel.game.leftScore)"
            self.rightScoreTextField.text = "\(self.viewModel.game.rightScore)"
            
            self.disposeBag = disposeBag
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        leftTeamButton.backgroundColor = UIColor.flatCloudsColor()
        leftTeamButton.layer.cornerRadius = leftTeamButton.frame.size.height / 5
        rightTeamButton.backgroundColor = UIColor.flatCloudsColor()
        rightTeamButton.layer.cornerRadius = rightTeamButton.frame.size.height / 5
        
        self.leftScoreTextField.delegate = self
        self.rightScoreTextField.delegate = self

        let clearButton1 = UIBarButtonItem(title: "Clear", style: .Plain, target: self, action: #selector(clear))
        let clearButton2 = UIBarButtonItem(title: "Clear", style: .Plain, target: self, action: #selector(clear))
        let drawButton1 = UIBarButtonItem(title: "Draw", style: .Plain, target: self, action: #selector(drawn))
        let drawButton2 = UIBarButtonItem(title: "Draw", style: .Plain, target: self, action: #selector(drawn))
        let negateButton1 = UIBarButtonItem(title: "Negate", style: .Plain, target: self, action: #selector(negate))
        let negateButton2 = UIBarButtonItem(title: "Negate", style: .Plain, target: self, action: #selector(negate))
        self.leftScoreTextField.addDoneToolbar([clearButton1, drawButton1], rightbuttons: [negateButton1])
        self.rightScoreTextField.addDoneToolbar([clearButton2, drawButton2], rightbuttons: [negateButton2])
    }
    
    internal override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = nil
    }
}

extension GameCell : UITextFieldDelegate {
    
    private var activeTextField : UITextField {
        get {
            return leftScoreTextField.isFirstResponder() ? leftScoreTextField : rightScoreTextField
        }
    }

    @objc private func drawn() {
        viewModel.setDrawn()
        activeTextField.resignFirstResponder()
    }
    
    @objc private func clear() {
        activeTextField.text = ""
    }
    
    @objc private func negate() {
        if let text = activeTextField.text, handicap = Int(text) where handicap != 0 {
            activeTextField.text = "\(-handicap)"
        }
    }
    
    private func saveTextField(textField: UITextField, withText text : String) {
        switch textField {
        case self.leftScoreTextField:
            viewModel.leftScore = text
        case self.rightScoreTextField:
            viewModel.rightScore = text
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        saveTextField(textField, withText: textField.text!)
    }
}
