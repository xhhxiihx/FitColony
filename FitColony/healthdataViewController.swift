//
//  FirstViewController.swift
//  FitColony
//
//  Created by 李方然 on 16/3/7.
//  Copyright © 2016年 li. All rights reserved.
//

import UIKit
import AVOSCloud

class healthdataViewController: UIViewController {
    @IBOutlet weak var sleepView: UIView!
    @IBOutlet weak var sportView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var healthdataSegmentController: UISegmentedControl!
    var sleepVC:sleepViewController?
    var sportVC:sportViewController?
    var profileVC:profileViewController?
    
    let category:[String]=["日常","有氧","无氧"]
    let sportskind:[String]=["步行","慢跑","游泳","健身"]
    let colors: [UIColor] = [UIColor(netHex: 0xDBD03E),UIColor(netHex: 0xE8357A),UIColor(netHex: 0x656DFF)]
    
    let user=AVUser.currentUser()
    
    var lasttouch:CGPoint?
    var lastdayforsport:NSDate=NSDate()
    var firstdayforsport:NSDate=NSDate().dateByAddingTimeInterval(-7*60*60)
    
    
    var lastdayforsleep:NSDate=NSDate()
    var firstdayforsleep:NSDate=NSDate().dateByAddingTimeInterval(-7*60*60)
    
    @IBAction func switchHealthData(sender: AnyObject) {
        switch healthdataSegmentController.selectedSegmentIndex{
        case 0:
            profileView.hidden=false
            sportView.hidden=true
            sleepView.hidden=true
        case 1:
            profileView.hidden=true
            sportView.hidden=false
            sleepView.hidden=true
            setsportView(NSDate())
            
        case 2:
            profileView.hidden=true
            sportView.hidden=true
            sleepView.hidden=false
            setsleepView(NSDate())
            
            
        default:break
        }
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let began = (touches as NSSet).anyObject() as! UITouch
        
        lasttouch=began.locationInView(self.view)
        
    }
    
    
    //mark: touches_gesture
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let end = (touches as NSSet).anyObject() as! UITouch

        if (lasttouch != nil) && (lasttouch?.y > 345.0) && (lasttouch?.y < 370.0){
            switch healthdataSegmentController.selectedSegmentIndex{
            case 0:break
            case 1:
                if lasttouch!.x < end.locationInView(self.view).x - 10{
                    //                        print("right")
                    setsportView(lastdayforsport)
                    lasttouch=nil
                }else if lasttouch!.x > end.locationInView(self.view).x + 10{
                    //                        print("left")
                    setsportView(firstdayforsport)
                    lasttouch=nil
                }
            case 2:
            if lasttouch!.x < end.locationInView(self.view).x - 10{
                //                        print("right")
                setsleepView(lastdayforsleep)
                lasttouch=nil
            }else if lasttouch!.x > end.locationInView(self.view).x + 10{
                //                        print("left")
                setsleepView(firstdayforsleep)
                lasttouch=nil
                }
            default:break
            }
        }
        
    }
    
    
    func selesportdata(lastday:NSDate)->[HDsport]{
        let sele=HDsport.query()
        sele.whereKey("user", equalTo: user)
        sele.whereKey("date", lessThanOrEqualTo: lastday)
        sele.orderByDescending("date")
        let sports = sele.findObjects() as? [HDsport]
        return sports!
    }
    
    func sumsport(data:[HDsport],date:NSDate)->(duration:Double,comsumption:Double,n:Int,oneday:onedaydata){
        var sumduration:Double=0
        var sumcomsumption:Double=0
        var oneday:onedaydata=onedaydata()
        var n=0
        for i in data{
            if i.date==date{
                sumcomsumption=sumcomsumption+i.comsumption
                sumduration=sumduration+i.duration
                n += 1
                
                switch i.sportname{
                case "步行":
                    oneday.hbar[0]+=i.duration/60
                    oneday.pie[0]+=i.comsumption/1000
                case "慢跑":
                    oneday.hbar[1]+=i.duration/60
                    oneday.pie[1]+=i.comsumption/1000
                case "游泳":
                    oneday.hbar[2]+=i.duration/60
                    oneday.pie[1]+=i.comsumption/1000
                case "健身":
                    oneday.hbar[3]+=i.duration/60
                    oneday.pie[2]+=i.comsumption/1000
                default:break
                }
            }
        }
        return(sumduration,sumcomsumption,n,oneday)
        
    }
    
    
    
    func selesevendaysport(inlastday:NSDate)->(date:[String],duration:[Double],comsumption:[Double],oneweekdata:[onedaydata],wholeweekdata:onedaydata,outlastday:NSDate,outfirstday:NSDate){
        let data=selesportdata(inlastday)
        var j:Int=0
        var lastday=inlastday
        var firstday=inlastday
        var wholeweekdata=onedaydata()
        var oneweekdata=[onedaydata]()
        
        var date = [String]()
        var duration = [Double]()
        var comsumption = [Double]()
        
        if data.count != 0{
            lastday = data[0].date
        }
        
        for _ in 0...6{
            let dateString=weekdayformat.stringFromDate(lastday)
            date.insert(dateString, atIndex: 0)
            
            if (j > data.count-1)||(lastday != data[j].date){
                duration.insert(0.0, atIndex: 0)
                comsumption.insert(0.0, atIndex: 0)
                oneweekdata.insert(onedaydata(), atIndex: 0)
            }else{
                let onedaysport=sumsport(data, date: lastday)
                duration.insert(onedaysport.duration/60, atIndex:0)
                comsumption.insert(onedaysport.comsumption/1000, atIndex: 0)
                j=j+onedaysport.n
                oneweekdata.insert(onedaysport.oneday, atIndex: 0)
            }
            firstday=firstday.dateByAddingTimeInterval(24*60*60)
            lastday=lastday.dateByAddingTimeInterval(-24*60*60)
        }
        
        
        for i in 0...6{
            for k in 0...3{
                wholeweekdata.hbar[k]+=oneweekdata[i].hbar[k]
            }
            
            for k in 0...2{
                wholeweekdata.pie[k]+=oneweekdata[i].pie[k]
            }
        }
        
        return (date,duration,comsumption,oneweekdata,wholeweekdata,lastday,firstday)
    }
    
    
    
    func selebestsleeptime()->Double{
        let sele=HDprofile.query()
        sele.whereKey("user", equalTo: user)
        
        sele.orderByDescending("date")
        let profile=sele.getFirstObject() as! HDprofile
        let best=21-6*pow(profile.age,0.3)+profile.age/10
        return best
    }
    
    func selesleepdata(lastday:NSDate)->[HDsleep]{
        let sele=HDsleep.query()
        
        sele.whereKey("user", equalTo: user)
        sele.whereKey("date", lessThanOrEqualTo: lastday)
        sele.orderByDescending("date")
        
        //        sele.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
        //
        //        }
        let sleeps = sele.findObjects() as? [HDsleep]
        return sleeps!
    }
    
    func selesevendaysdata(inlastday:NSDate)->(date:[String],value:[Double],averagesleep:Double,outlastday:NSDate,outfirstday:NSDate,hhstart:[Int]){
        let data=selesleepdata(inlastday)
        var j:Int=0
        var average:Double=0
        var lastday=inlastday
        var firstday=inlastday
        
        var sum:Double=0.0
        var date = [String]()
        var value = [Double]()
        var start = [Int]()
        
        if data.count != 0{
            lastday = data[0].date
        }

        
        for _ in 0...6{
            let dateString=weekdayformat.stringFromDate(lastday)
            date.insert(dateString,atIndex: 0)
            
            if (j > data.count-1)||(lastday != data[j].date){
                value.insert(0.0, atIndex: 0)
                start.insert(-1, atIndex: 0)
            }else{
                value.insert(data[j].duration/60,atIndex:0)
                start.insert(Int(sleepformat.stringFromDate(data[j].startAt))!,atIndex:0)
                j += 1
            }
            
            sum=sum+value[0]
            firstday=firstday.dateByAddingTimeInterval(24*60*60)
            lastday=lastday.dateByAddingTimeInterval(-24*60*60)
        }
        
        if j != 0 {
            average=sum/Double(j)
        }
        return (date,value,average,lastday,firstday,start)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        switch segue.identifier{
        case "sleepSegue"?:
            sleepVC=segue.destinationViewController as? sleepViewController
        case "sportSegue"?:
            sportVC=segue.destinationViewController as? sportViewController
        case "basicSegue"?:
            profileVC=segue.destinationViewController as? profileViewController
        default:break
        }
        //        if segue.identifier=="sleepSegue"{
        //            sleepVC=segue.destinationViewController as? sleepViewController
        //        }
    }
    
    func setsportView(day:NSDate){
        
        
        sportVC?.explain.alpha = 0
        
        

        let weekdata=selesevendaysport(day)
        
        lastdayforsport=weekdata.outlastday
        firstdayforsport=weekdata.outfirstday
        
        sportVC?.weekdata=weekdata
        let piedata=sportVC?.getpiedata(category, prevalue: weekdata.wholeweekdata.pie,precolors: colors)
        sportVC?.pieChartView.setChart(piedata!.datapoint, values: piedata!.value,colors: piedata!.colors)
        sportVC?.horizontalBarChartView.setChart(sportskind, values: weekdata.wholeweekdata.hbar)
        UIView.animateWithDuration(2, animations: { () -> Void in
            self.sportVC?.explain.alpha = 1
        })
        let str = "< "+weekdata.date[0]+" — "+weekdata.date[6]+" >"
        sportVC?.dateupdate(str)
        sportVC?.combinedChartView.setChart(weekdata.date, yValuesLineChart: weekdata.comsumption, yValuesBarChart: weekdata.duration)
    }
    
    func setsleepView(day:NSDate){
//        sleepVC?.barChartView.rightAxis.removeAllLimitLines()
        let weekdata=selesevendaysdata(day)
        
        lastdayforsleep=weekdata.outlastday
        firstdayforsleep=weekdata.outfirstday
        sleepVC?.hhstart=weekdata.hhstart
        sleepVC?.barChartView.SetChart(weekdata.date, values: weekdata.value, label: "睡眠时间", color: [UIColor(netHex: 0x0033FF)]
        )
        
        sleepVC?.drawline(weekdata.averagesleep, color: UIColor.orangeColor(),label: "average")
        sleepVC?.drawline(selebestsleeptime(), color: UIColor.greenColor(),label: "best")
        
        let str = "< "+weekdata.date[0]+" — "+weekdata.date[6]+" >"
        sleepVC?.dateupdate(str)
            }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileVC?.user=self.user
        //  NSThread.sleepForTimeInterval(2.0)
        //        let user=AVUser.currentUser()
        //        print(user.username)
        //        print(user.password)
        //        print(user.objectId)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

