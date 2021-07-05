//
//  StatsTableViewCell.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 22.06.21.
//

import UIKit
import Charts

class StatsTableViewCell: UITableViewCell {

    @IBOutlet weak var combinedChartsView: CombinedChartView!
    
    var xAxis: [String]?
    var timeAxis: [Double]?
    var distanceAxis: [Double]?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // make sure this is not nil!
        setChart(xValues: xAxis!, yValuesBarChart: timeAxis!, yValuesLineChart: distanceAxis!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setChart(xValues: [String], yValuesBarChart: [Double], yValuesLineChart: [Double]) {
        
        var timeValues: [BarChartDataEntry] = [BarChartDataEntry]()
        var distanceValues: [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0..<xValues.count {
            timeValues.append(BarChartDataEntry(x: Double(i), y: yValuesBarChart[i]))
            distanceValues.append(ChartDataEntry(x: Double(i), y: yValuesLineChart[i]))
        }
        
        let barChartSet: BarChartDataSet = BarChartDataSet(entries: timeValues, label: "Walked Time")
        let lineChartSet: LineChartDataSet = LineChartDataSet(entries: distanceValues, label: "Walked Distance")
        
        let data: CombinedChartData = CombinedChartData(dataSets: [lineChartSet, barChartSet])
        data.barData = BarChartData(dataSets: [barChartSet])
        data.lineData = LineChartData(dataSets: [lineChartSet])
        
        combinedChartsView.data = data
        combinedChartsView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxis!)
        
    }
    
}
