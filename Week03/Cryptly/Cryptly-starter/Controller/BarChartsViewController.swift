/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import Charts

class BarChartsViewController: UIViewController {

    @IBOutlet private weak var barChartView: BarChartView!
  
      var currencies: [CryptoCurrency]!
      var barChartColor = UIColor()
      var barChartDescription: String!

      override func viewDidLoad() {
        super.viewDidLoad()
                
        barChartView.pinchZoomEnabled = false
        barChartView.drawBarShadowEnabled = false
        barChartView.drawBordersEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.drawGridBackgroundEnabled = true
        barChartView.chartDescription?.text = ""
        barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)

        let currentValues = currencies.map{ $0.currentValue }
        let previousValues = currencies.map{ $0.previousValue }
        let currencySymbols = currencies.map{ $0.symbol }
        setChart(currencySymbols: currencySymbols, currentValues: currentValues, previousValues: previousValues)
        
        setupViewForCurrentTheme()
    }
    
    
  private func setChart(currencySymbols: [String], currentValues: [Double], previousValues: [Double]) {
            
      var dataEntries: [BarChartDataEntry] = []
      var dataEntries1: [BarChartDataEntry] = []

      for i in 0..<currencySymbols.count {
        let dataEntry = BarChartDataEntry(x: Double(i), y: Double(previousValues[i]))
        dataEntries.append(dataEntry)
        
        let dataEntry1 = BarChartDataEntry(x: Double(i) , y: currentValues[i])
        dataEntries1.append(dataEntry1)
      }
      
      let xaxis = barChartView.xAxis
      xaxis.drawGridLinesEnabled = true
      xaxis.labelPosition = .bottom
      xaxis.centerAxisLabelsEnabled = true
      xaxis.granularity = 1
      xaxis.valueFormatter = IndexAxisValueFormatter(values: currencySymbols)
      
      let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Previous Value in USD")
      chartDataSet.colors = [UIColor.orange]
      
      let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Current Value in USD")
      chartDataSet1.colors = [UIColor.blue]

      let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1]

      let chartData = BarChartData(dataSets: dataSets)
      barChartView.data = chartData
      
      let groupSpace = 0.3
      let barSpace = 0.05
      let barWidth = 0.3

      let groupCount = currencySymbols.count
      let startPt = 0

      chartData.barWidth = barWidth;
      barChartView.xAxis.axisMinimum = Double(startPt)
      let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
//      print("Groupspace: \(gg)")
      barChartView.xAxis.axisMaximum = Double(startPt) + gg * Double(groupCount)

      chartData.groupBars(fromX: Double(startPt), groupSpace: groupSpace, barSpace: barSpace)
      barChartView.notifyDataSetChanged()

      barChartView.data = chartData
      
    }

    private func setupViewForCurrentTheme() {
    
      guard let currentTheme = ThemeManager.shared.currentTheme else {
        return
      }
      view.backgroundColor = currentTheme.backgroundColor
      barChartView.legend.textColor = currentTheme.textColor
      barChartView.xAxis.labelTextColor = currentTheme.textColor
      barChartView.leftAxis.labelTextColor = currentTheme.textColor
      barChartView.rightAxis.labelTextColor = currentTheme.textColor

  }
}

