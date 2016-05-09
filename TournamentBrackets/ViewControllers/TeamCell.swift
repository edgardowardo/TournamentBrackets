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
    
    struct Notification {
        struct Identifier {
            static let CellStartEditing = "NotificationIdentifierOf_CellStartEditing"
            static let PreviousCellTextField = "NotificationIdentifierOf_PreviousCellTextField"
            static let NextCellTextField = "NotificationIdentifierOf_NextCellTextField"
        }
    }
    
    var team : Team? {
        didSet {
            self.layoutCell()
        }
    }
    
    private var activeTextField : UITextField {
        get {
            return self.textName.isFirstResponder() ? self.textName : self.textHandicapPoints
        }
    }
    
    private func layoutCell() {
        if let t = team {
            self.textSeed.text = "\(t.seed)."
            self.textName.text = t.name
            self.textHandicapPoints.text = "\(t.handicap)"
            self.textHandicapPoints.hidden = !t.isHandicapped
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.textName.delegate = self
        self.textHandicapPoints.delegate = self

        let negateButton = UIBarButtonItem(title: "Negate", style: .Plain, target: self, action: #selector(negate))
        
        navButtonForTextField(self.textName)
        navButtonForTextField(self.textHandicapPoints, extraButtons: [negateButton])
    }
    
    private func navButtonForTextField(textField : UITextField, extraButtons : [UIBarButtonItem] = []) {
        let prevButton = UIBarButtonItem(title: "Previous", style: .Plain, target: self, action: #selector(prev))
        let nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(next))
        textField.addDoneToolbar([prevButton, nextButton], rightbuttons: extraButtons)
    }
    
    @objc private func prev() {
        if self.activeTextField === self.textName {
            NSNotificationCenter.defaultCenter().postNotificationName(Notification.Identifier.PreviousCellTextField, object: self)
        } else {
            self.textName.becomeFirstResponder()
        }
    }
    
    @objc private func next() {
        guard let team = self.team else { return }
        
        if self.activeTextField === self.textHandicapPoints || !team.isHandicapped {
            NSNotificationCenter.defaultCenter().postNotificationName(Notification.Identifier.NextCellTextField, object: self)
        } else {
            self.textHandicapPoints.becomeFirstResponder()
        }
    }
    
    @objc private func negate() {
        if let handicapText = self.textHandicapPoints.text, handicap = Double(handicapText) where handicap != 0.0 {
            self.textHandicapPoints.text = "\(-handicap)"
        }
    }
}

extension TeamCell : UITextFieldDelegate {
    
    private func saveTextField(textField: UITextField) {
        switch textField {
        case self.textName:
            if let text = textField.text, team = self.team where text.characters.count > 0 {
                team.name = text
            }
        case self.textHandicapPoints:
            if let text = textField.text, seed = Double(text), team = self.team where text.characters.count > 0 {
                team.handicap = seed
            }
        default:
            break
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        NSNotificationCenter.defaultCenter().postNotificationName(Notification.Identifier.CellStartEditing, object: self)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        saveTextField(textField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        saveTextField(textField)
        textField.resignFirstResponder()
        return true
    }
}
