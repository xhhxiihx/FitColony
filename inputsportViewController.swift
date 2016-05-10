//
//  mysportViewController.swift
//  FitColony
//
//  Created by 李方然 on 16/3/11.
//  Copyright © 2016年 li. All rights reserved.
//

import UIKit
import AVOSCloud
class inputsportViewController: UIViewController,ChooseSportDelegate,UITableViewDataSource,UITableViewDelegate {
    
    @IBAction func editbtn(sender: AnyObject) {
        if selesportTableView.editing==true{
             editdone.setTitle("edit", forState: .Normal)
            selesportTableView.editing=false
        }else{
            editdone.setTitle("done", forState: .Normal)
            selesportTableView.editing=true
        }
        
    }
    @IBOutlet weak var editdone: UIButton!
    @IBAction func cancel(sender: AnyObject) {
        flag = -1
        UIView.animateWithDuration(0.7) { () -> Void in
            self.newsportrecord.center.y=self.view.center.y+self.view.frame.height
        }
    }
    
    let user=AVUser.currentUser()
    var flag:Int = -1
    
    @IBOutlet weak var selesportTableView: UITableView!
    var selesportrecords:[HDsport]?
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 18))
        let label = UILabel(frame: CGRectMake(10, 5, tableView.frame.size.width, 18))
        
        label.font = UIFont.systemFontOfSize(14)
        label.text = "运动数据"
        
        view.addSubview(label)
        view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        return view
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let sele=HDsport.query()
        sele.cachePolicy = .CacheElseNetwork
        sele.whereKey("user", equalTo: user)
        sele.orderByDescending("updatedAt")
        selesportrecords=sele.findObjects() as? [HDsport]
        return (selesportrecords?.count)!
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.selesportTableView.dequeueReusableCellWithIdentifier("sportrecordcell", forIndexPath: indexPath) as! sportrecordTableViewCell
        
        let record=selesportrecords![indexPath.row]
        cell.textLabel?.text=record.sportname
        cell.detailTextLabel?.text=dayformat.stringFromDate(record.date)
        
        
        let durationHour=Int(record.duration/60)
        let durationMinute=Int(record.duration)-durationHour*60
        
        cell.duration.text="\(durationHour)小时\(durationMinute)分钟"
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            
            selesportrecords![indexPath.row].delete()
            self.selesportTableView.reloadData()
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        flag = indexPath.row
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        inputsportTVC?.currentdate=selesportrecords![flag].date
        inputsportTVC?.duration=selesportrecords![flag].duration
        inputsportTVC?.startAt=selesportrecords![flag].startAt
        inputsportTVC?.endAt=selesportrecords![flag].endAt
        
        inputsportTVC?.sport.text=selesportrecords![indexPath.row].sportname
        inputsportTVC?.date.text=dayformat.stringFromDate(selesportrecords![indexPath.row].date)
        inputsportTVC?.starttime.detailTextLabel?.text=hourformat.stringFromDate(selesportrecords![indexPath.row].startAt)
        inputsportTVC?.endtime.detailTextLabel?.text=hourformat.stringFromDate(selesportrecords![indexPath.row].endAt)
        
        inputsportTVC?.datepicker.date=selesportrecords![flag].date //reset datepicker
        
        let durationHour=Int(selesportrecords![indexPath.row].duration/60)
        let durationMinute=Int(selesportrecords![indexPath.row].duration)-durationHour*60
        inputsportTVC?.durationcell.detailTextLabel?.text="\(durationHour)小时\(durationMinute)分钟"
        
        UIView.animateWithDuration(0.7) { () -> Void in
            self.newsportrecord.center.y=self.view.center.y+75
        }
        
        
        
    }
    
    var inputsportTVC:inputsportTableViewController?
    
    var sportkind:sportkinds=sportkinds.walk
    
    func findsportkind(sportkind:sportkinds)->String{
        switch sportkind  {
        case .walk: return "步行"
        case .jog: return "慢跑"
        case .swim: return "游泳"
        case .fit: return "健身"
        }
    }
    
    func calculatecomsumption(sportkind:sportkinds,weight:Double,duration:Double)->Double{
        
        switch sportkind{
        case .walk: return (3.2*weight-6)*duration/60
        case .jog: return (9.4*weight+0.4)*duration/60
        case .swim: return (11.76*weight+3.6)*duration/60
        case .fit: return 9.48*weight*duration/60
        }
    }
    
    @IBOutlet weak var newsportrecord: UIView!
    
    @IBAction func savesportrecordbtn(sender: AnyObject) {
        
        
        
        
        let sportrecord=HDsport()
        
        let sele=HDprofile.query()
        sele.cachePolicy = .CacheElseNetwork
        
        sele.whereKey("user", equalTo: user)
        var profile:HDprofile?
        profile=sele.getFirstObject() as? HDprofile
        
        var weight:Double=50.0
        
        if profile==nil {
            
        }else{
            weight=profile!.weight
        }
        
        if flag == -1{
            
            sportrecord.comsumption=self.calculatecomsumption(self.sportkind, weight:weight, duration: (self.inputsportTVC?.duration)!)
            sportrecord.user=user
            sportrecord.date=(inputsportTVC?.currentdate)!
            sportrecord.duration=(inputsportTVC?.duration)!
            sportrecord.startAt=(inputsportTVC?.startAt)!
            sportrecord.endAt=(inputsportTVC?.endAt)!
            sportrecord.sportname=findsportkind(sportkind)
            sportrecord.save()
            
        }else{
            
            selesportrecords![flag].comsumption=self.calculatecomsumption(self.sportkind, weight:weight, duration: (self.inputsportTVC?.duration)!)
            
            selesportrecords![flag].date=(inputsportTVC?.currentdate)!
            selesportrecords![flag].duration=(inputsportTVC?.duration)!
            selesportrecords![flag].startAt=(inputsportTVC?.startAt)!
            selesportrecords![flag].endAt=(inputsportTVC?.endAt)!
            selesportrecords![flag].sportname=(inputsportTVC?.sport.text)!
            selesportrecords![flag].save()
        }
        
        sele.cachePolicy = .NetworkOnly
        selesportTableView.reloadData()
        
        flag = -1
        UIView.animateWithDuration(0.7) { () -> Void in
            self.newsportrecord.center.y=self.view.center.y+self.view.frame.height
        }
        
    }
    
    
    //newbtn
    @IBAction func newsportrecordBtn(sender: AnyObject) {
        
        
        inputsportTVC?.datepicker.date=NSDate() //reset datepicker
        
        flag = -1
        inputsportTVC?.sport.text="请选择"
        UIView.animateWithDuration(0.7) { () -> Void in
            self.newsportrecord.center.y=self.view.center.y+75
        }
        
        
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.newsportrecord.center.y=self.view.center.y+self.view.frame.height
    }
    
    func choosesport(){
        
        let choosesport=UIAlertController(title:"请选择进行的体育项目", message:"", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        
        let walkAction = UIAlertAction(title:sportkinds.walk.rawValue, style: UIAlertActionStyle.Default){
            (UIAlertAction) -> Void in
            self.inputsportTVC?.sport.text=sportkinds.walk.rawValue
            self.sportkind=sportkinds.walk
        }
        
        let jogAction = UIAlertAction(title:sportkinds.jog.rawValue, style: UIAlertActionStyle.Default){
            (UIAlertAction) -> Void in
            self.inputsportTVC?.sport.text=sportkinds.jog.rawValue
            self.sportkind=sportkinds.jog
        }
        
        let swimAction = UIAlertAction(title:sportkinds.swim.rawValue, style: UIAlertActionStyle.Default){
            (UIAlertAction) -> Void in
            self.inputsportTVC?.sport.text=sportkinds.swim.rawValue
            self.sportkind=sportkinds.swim
        }
        let fitAction = UIAlertAction(title:sportkinds.fit.rawValue, style: UIAlertActionStyle.Default){
            (UIAlertAction) -> Void in
            self.inputsportTVC?.sport.text=sportkinds.fit.rawValue
            self.sportkind=sportkinds.fit
        }
        
        
        choosesport.addAction(cancelAction)
        choosesport.addAction(walkAction)
        choosesport.addAction(jogAction)
        choosesport.addAction(swimAction)
        choosesport.addAction(fitAction)
        
        self.presentViewController(choosesport, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier=="sportdataSegue"{
            self.inputsportTVC=segue.destinationViewController as? inputsportTableViewController
            self.inputsportTVC!.delegate=self
        }
    }
}
