//
//  TeamsImportViewModel.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 26/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class TeamsImportItemCell : UITableViewCell {
    var viewModel : TeamsImportItemViewModel! {
        didSet {
            textLabel?.text = viewModel.text
            detailTextLabel?.text = viewModel.detailText
        }
    }
}