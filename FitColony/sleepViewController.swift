//
//  HealthDataSleepbarChart.swift
//  FitColony
//
//  Created by 李方然 on 16/3/7.
//  Copyright © 2016年 li. All rights reserved.
//

import UIKit
import Charts


import AVOSCloud
class sleepViewController: UIViewController,ChartViewDelegate{

    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var swipegesture: UILabel!
    
    var hhstart:[Int]?
    
    func drawline(average:Double,color:UIColor,label:String){
        let al = colorLimitLine(limit: average, label: label)
        al.addcolor(color)
        al.valueTextColor=color
        self.barChartView.rightAxis.addLimitLine(al)
        
    }
    
    func drawsleepcondition(){
        let deep = ChartLimitLine(limit: 8, label: "深度睡眠")
        let shallow = ChartLimitLine(limit: 4, label: "浅睡眠")
        deep.lineColor = UIColor(netHex: 0x100F7F)
        deep.valueTextColor = UIColor(netHex: 0x100F7F)
        shallow.lineColor = UIColor(netHex: 0x63E8FF)
        shallow.valueTextColor = UIColor(netHex: 0x63E8FF)
        
        self.lineChartView.rightAxis.addLimitLine(deep)
        self.lineChartView.rightAxis.addLimitLine(shallow)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        barChartView.delegate=self
        
        barChartView.xAxis.labelPosition = .Bottom
        barChartView.noDataTextDescription = "等待数据加载"
//        barChartView.leftAxis.customAxisMin = 0.0
//        barChartView.leftAxis.customAxisMax = 13.0
//        barChartView.rightAxis.customAxisMin = 0.0
//        barChartView.rightAxis.customAxisMax = 13.0
        barChartView.descriptionText = ""
        
        barChartView.xAxis.drawAxisLineEnabled = true
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawLabelsEnabled = true
        
        barChartView.doubleTapToZoomEnabled = false
        
        barChartView.leftAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawLabelsEnabled = false
        barChartView.drawValueAboveBarEnabled = false
        
//        lineChartView.leftAxis.customAxisMin = 0.0
//        lineChartView.leftAxis.customAxisMax = 12.0
//        lineChartView.rightAxis.customAxisMin = 0.0
//        lineChartView.rightAxis.customAxisMax = 12.0
        
        lineChartView.descriptionText = ""
        lineChartView.noDataText = "please choose one day"
        lineChartView.noDataTextDescription = "请选择某一天的数据"
        lineChartView.doubleTapToZoomEnabled = false
        
        lineChartView.xAxis.drawAxisLineEnabled = true
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.drawLabelsEnabled = true
        lineChartView.xAxis.labelPosition = .Bottom
        
        
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = true
        lineChartView.leftAxis.labelTextColor=UIColor.clearColor()
        
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        
        drawsleepcondition()

        
    }
    
    
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {

        var datapoint=[String]()
        var value=[Double]()
        var start=hhstart![entry.xIndex]
        
        for _ in 0...Int(entry.value){
            if start==24{
                start=0
            }
            datapoint.append(String(start)+":00")
            value.append(Double(Int(arc4random_uniform(10))+1))
            start += 1
        }
        
        
        lineChartView.setChart(datapoint, values: value)

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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension BarChartView{
    
    func SetChart(dataPoints:[String],values:[Double],label:String,color:[Charts.NSUIColor]){
        self.rightAxis.removeAllLimitLines()
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value:values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: label)
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        chartDataSet.colors = color
        
        self.data=chartData
        self.animate(xAxisDuration: 0.7, yAxisDuration: 2.0, easingOption: .EaseInOutQuint)
        
    }
    
}

class colorLimitLine:ChartLimitLine{
    
    override init(limit:Double,label:String){
        super.init(limit:limit,label:label)
    }
    func addcolor(color:Charts.NSUIColor){
        super.lineColor=color
    }
}


extension LineChartView{
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineDataSet = LineChartDataSet(yVals: dataEntries, label: "睡眠状态")
        lineDataSet.drawCubicEnabled = true
        lineDataSet.drawFilledEnabled = true
        lineDataSet.drawCircleHoleEnabled = false
        lineDataSet.drawCirclesEnabled = false
        
        lineDataSet.fillColor = UIColor.greenColor()
        lineDataSet.colors = [UIColor.greenColor()]
        lineDataSet.drawValuesEnabled = false
        lineDataSet.cubicIntensity = 0.3
        
        let linedata = LineChartData(xVals: dataPoints, dataSet: lineDataSet)
        self.data = linedata
        
        
        self.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInOutQuint)
        
    }
    
    
    
    
}
