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
        setup()        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setData()
    }
    
    func setData() {
        viewModel.loadData()
        
        var yVals = [BarChartDataEntry]()
        for (i, y) in viewModel.yAxis.enumerate() {
            yVals.append(BarChartDataEntry(value: y, xIndex: i))
        }
        let dataset = BarChartDataSet(yVals: yVals, label: "\(viewModel.chartType)")
        let data = BarChartData(xVals: viewModel.xAxis, dataSets: [dataset])
        if viewModel.yAxisMaxValue > 0 {
            chart.leftYAxisRenderer.yAxis?.axisMaxValue = Double(viewModel.yAxisMaxValue)
            chart.rightYAxisRenderer.yAxis?.axisMaxValue = Double(viewModel.yAxisMaxValue)
        }        
        chart.data = data
        self.chart.animate(yAxisDuration: 0.75, easingOption: .EaseOutBack)
    }
    
    func setup() {

        chart.descriptionText = ""
        chart.noDataTextDescription = "You need to provide data for the chart."
        chart.drawGridBackgroundEnabled = false
        chart.dragEnabled = true
        chart.setScaleEnabled(true)
        chart.pinchZoomEnabled = false
        chart.xAxis.labelPosition = .Bottom
        chart.rightAxis.enabled = false        
        
        chart.drawBarShadowEnabled = false
        chart.drawValueAboveBarEnabled = true
        chart.maxVisibleValueCount = 60
        
        let xAxis = chart.xAxis
        xAxis.labelPosition = .Bottom;
        xAxis.labelFont = UIFont.systemFontOfSize(10.0)
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = true
        xAxis.gridLineWidth = 0.3
        
        let leftAxis = chart.leftAxis;
        leftAxis.labelFont = UIFont.systemFontOfSize(10.0)
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.gridLineWidth = 0.3
        leftAxis.resetCustomAxisMin()
        
        let rightAxis = chart.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = UIFont.systemFontOfSize(10.0)
        rightAxis.drawAxisLineEnabled = true
        rightAxis.drawGridLinesEnabled = false
        rightAxis.resetCustomAxisMin()
        
        chart.legend.position = .BelowChartLeft
        chart.legend.form = .Square
        chart.legend.formSize = 8.0
        chart.legend.font = UIFont(name: "HelveticaNeue-Light", size: 11.0)!
        chart.legend.xEntrySpace = 4.0
    }
}