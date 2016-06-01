//
//  TBAcknowledgementsViewController.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 01/06/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit
import VTAcknowledgementsViewController

class TBAcknowledgementsViewController : VTAcknowledgementsViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let ack = self.acknowledgements![indexPath.row]
        let ackController = VTAcknowledgementViewController(title: ack.title, text: ack.text)!
        self.navigationController?.pushViewController(ackController, animated: true)
    }
}