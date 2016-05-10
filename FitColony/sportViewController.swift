//
//  sportViewController.swift
//  FitColony
//
//  Created by 李方然 on 16/3/10.
//  Copyright © 2016年 li. All rights reserved.
//

import UIKit
import Charts


class sportViewController: UIViewController,ChartViewDelegate{
    
    @IBOutlet weak var explain: UILabel!
    @IBOutlet weak var horizontalBarChartView: HorizontalBarChartView!
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var combinedChartView: CombinedChartView!
    
    var weekdata:(date:[String],duration:[Double],comsumption:[Double],oneweekdata:[onedaydata],wholeweekdata:onedaydata,outlastday:NSDate,outfirstday:NSDate)?
    let category:[String]=["日常","有氧","无氧"]
    let sportskind:[String]=["步行","慢跑","游泳","健身"]
    let colors: [UIColor] = [UIColor(netHex: 0xDBD03E),UIColor(netHex: 0xE8357A),UIColor(netHex: 0x656DFF)]

        
    
    @IBOutlet weak var swipegesture: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // charts init
        combinedChartView.delegate=self
        combinedChartView.drawBarShadowEnabled = false
        combinedChartView.xAxis.labelPosition = .Bottom
        combinedChartView.xAxis.drawAxisLineEnabled = false
        combinedChartView.xAxis.drawGridLinesEnabled = false
//        combinedChartView.leftAxis.rese
//        combinedChartView.leftAxis.customAxisMax = 5.5
        let format=NSNumberFormatter()
        format.maximumFractionDigits = 2
        format.minimumFractionDigits = 2
        format.minimumIntegerDigits = 1
        combinedChartView.leftAxis.valueFormatter = format
        combinedChartView.leftAxis.drawAxisLineEnabled = false
        combinedChartView.doubleTapToZoomEnabled = false
        combinedChartView.rightAxis.enabled = false
        combinedChartView.descriptionText = ""
       
        horizontalBarChartView.descriptionText = ""
        horizontalBarChartView.xAxis.drawGridLinesEnabled = false
        horizontalBarChartView.xAxis.labelPosition = .Bottom
        horizontalBarChartView.drawBarShadowEnabled = false
        horizontalBarChartView.doubleTapToZoomEnabled = false
//        horizontalBarChartView.leftAxis.customAxisMin = 0

        horizontalBarChartView.leftAxis.drawLabelsEnabled = false
        horizontalBarChartView.leftAxis.drawAxisLineEnabled = false
        horizontalBarChartView.leftAxis.drawGridLinesEnabled = false
        horizontalBarChartView.rightAxis.enabled=false
    }
    

    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        let piedata=getpiedata(category, prevalue: weekdata!.oneweekdata[entry.xIndex].pie,precolors: colors)
        pieChartView.setChart(piedata.datapoint, values: piedata.value,colors: piedata.colors)
        horizontalBarChartView.setChart(sportskind, values: weekdata!.oneweekdata[entry.xIndex].hbar)
    }
    
    func getpiedata(sport:[String],prevalue:[Double],precolors:[UIColor])->(datapoint:[String],value:[Double],colors:[UIColor]){
        var sport=sport
        var value=prevalue
        var count=value.count
        var colors=precolors
        var i=0
        while i<count{
            
            if value[i] == 0{
                value.removeAtIndex(i)
                sport.removeAtIndex(i)
                colors.removeAtIndex(i)
                count -= 1
            }else{
                i += 1
            }

        }
        if count==0{
            return (["没有运动"],[0.00001],[UIColor.grayColor()])
        }else{
            return (sport,value,colors)
        }
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase) {
        pieChartView.setChart(category, values: weekdata!.wholeweekdata.pie,colors: colors)
        horizontalBarChartView.setChart(sportskind, values: weekdata!.wholeweekdata.hbar)
        
    }
    var animationFinished=true
    
    func dateupdate(to:String) {
        if swipegesture.text != to && self.animationFinished {
            let updatedLabel = UILabel()
            updatedLabel.textColor = swipegesture.textColor
            updatedLabel.font = swipegesture.font
            updatedLabel.textAlignment = .Center
            updatedLabel.text = to
            updatedLabel.sizeToFit()
            updatedLabel.alpha = 0
            updatedLabel.center = self.swipegesture.center
            
            let offset = CGFloat(48)
            updatedLabel.transform = CGAffineTransformMakeTranslation(0, offset)
            updatedLabel.transform = CGAffineTransformMakeScale(1, 0.1)
            
            UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.animationFinished = false
                self.swipegesture.transform = CGAffineTransformMakeTranslation(0, -offset)
                self.swipegesture.transform = CGAffineTransformMakeScale(1, 0.1)
                self.swipegesture.alpha = 0
                
                updatedLabel.alpha = 1
                updatedLabel.transform = CGAffineTransformIdentity
                
                }) { _ in
                    
                    self.animationFinished = true
                    self.swipegesture.frame = updatedLabel.frame
                    self.swipegesture.text = updatedLabel.text
                    self.swipegesture.transform = CGAffineTransformIdentity
                    self.swipegesture.alpha = 1
                    updatedLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedLabel, aboveSubview: self.swipegesture)
        }
    }

    
    
}

extension CombinedChartView{
    func setChart(xValues: [String], yValuesLineChart: [Double], yValuesBarChart: [Double]) {
        self.noDataText = "数据正在加载"
        self.noDataTextDescription = "数据正在加载"
        
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        var yVals2 : [BarChartDataEntry] = [BarChartDataEntry]()
        
        for i in 0..<xValues.count {
            
            yVals1.append(ChartDataEntry(value: yValuesLineChart[i], xIndex: i))
            yVals2.append(BarChartDataEntry(value: yValuesBarChart[i], xIndex: i))
            
        }
        
        let lineChartSet = LineChartDataSet(yVals: yVals1, label: "热量消耗(千卡)")
        let barChartSet: BarChartDataSet = BarChartDataSet(yVals: yVals2, label: "时间(小时)")
        lineChartSet.drawCubicEnabled = true
        lineChartSet.cubicIntensity=0.2
        lineChartSet.colors = [UIColor(netHex: 0xFFA311)]
        lineChartSet.circleColors = [UIColor(netHex: 0xFFA311)]
        lineChartSet.valueColors=[UIColor(netHex: 0xFFA311)]
        lineChartSet.valueFont=UIFont(name: "AmericanTypewriter-Bold", size: 8)!
        barChartSet.colors=[UIColor(netHex: 0x21FF79)]
        barChartSet.valueColors=[UIColor(netHex: 0x21FF79)]
        barChartSet.valueFont=UIFont(name: "AmericanTypewriter-Bold", size: 8)!
        
        let data: CombinedChartData = CombinedChartData(xVals: xValues)
        data.barData = BarChartData(xVals: xValues, dataSets: [barChartSet])
        data.lineData = LineChartData(xVals: xValues, dataSets: [lineChartSet])
        let format=NSNumberFormatter()
        format.maximumFractionDigits = 2
        format.minimumFractionDigits = 2
        format.minimumIntegerDigits = 1
        data.setValueFormatter(format)
        
        self.data = data
        self.animate(xAxisDuration: 1.0, yAxisDuration: 2.0, easingOption: .EaseInOutQuint)
    }
}

extension PieChartView{
    func setChart(dataPoints: [String], values: [Double],colors: [UIColor]) {
        
        var chartDataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            
            let chartDataEntry = ChartDataEntry(value: values[i], xIndex: i)
            chartDataEntries.append(chartDataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: chartDataEntries, label: "运动消耗(千卡)")
        
        pieChartDataSet.colors = colors
        
        
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        self.data = pieChartData
        self.descriptionText = ""
        self.animate(xAxisDuration: 2, yAxisDuration: 2, easingOption: .EaseInOutQuint)
    }
}

extension HorizontalBarChartView{
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "运动时间(小时)")
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        self.data = chartData
        
        self.animate(xAxisDuration: 0.2, yAxisDuration: 2.0, easingOption: .EaseInOutQuint)
        
    }
}



