//
//  ChartHorizontalBarViewController.swift
//  TournamentBrackets
//
//  Created by EDGARDO AGNO on 25/05/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit
import Charts

class ChartHorizontalBarViewController : ChartBaseViewController {
 
    var viewModel : ChartsHorizontalBarViewModel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var chart: HorizontalBarChartView!
    
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