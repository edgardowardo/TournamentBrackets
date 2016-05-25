//
//  ChartPieViewController.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 25/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit
import Charts

class ChartPieViewController : ChartBaseViewController {

    var viewModel : ChartsPieViewModel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var chart: PieChartView!
    
    override var pageIndex: Int {
        get {
            return viewModel.chartType.rawValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelSubtitle.text = "\(viewModel.chartType)"
    }
}
