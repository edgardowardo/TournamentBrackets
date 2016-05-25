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
        setup()
        
        viewModel.group.games
            .asObservableArray()
            .subscribeNext{ _ in
                self.setData()
                self.chart.animate(xAxisDuration: 1.4, easingOption: .EaseOutBack)
            }.addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setData() {
        viewModel.reload()
        
        var yVals = [BarChartDataEntry]()
        for (i, y) in viewModel.yAxis.enumerate() {
            yVals.append(BarChartDataEntry(value: y, xIndex: i))
        }
        let dataset = PieChartDataSet(yVals: yVals, label: nil)
        dataset.sliceSpace = 2.0
        dataset.colors = viewModel.colorSet

        let data = PieChartData(xVals: viewModel.xAxis, dataSet: dataset)
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .PercentStyle
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1
        formatter.percentSymbol = ""
        data.setValueFormatter(formatter)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 11.0))
        data.setValueTextColor(UIColor.whiteColor())
        chart.data = data
    }
    
    func setup()  {
        chart.usePercentValuesEnabled = false
        chart.drawHoleEnabled = viewModel.drawHoleEnabled
        chart.holeRadiusPercent = 0.58
        chart.transparentCircleRadiusPercent = 0.61
        chart.descriptionText = ""
        chart.setExtraOffsets(left: 5.0, top: 10.0, right: 5.0, bottom: 5.0)
        chart.drawCenterTextEnabled = false
        chart.rotationAngle = 0.0;
        chart.rotationEnabled = true
        chart.highlightPerTapEnabled = true
        let l = chart.legend
        l.position = .RightOfChart
        l.xEntrySpace = 7.0
        l.yEntrySpace = 0.0
        l.yOffset = 0.0
    }
}
