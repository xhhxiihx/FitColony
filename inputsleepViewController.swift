//
//  mysleepViewController.swift
//  FitColony
//
//  Created by 李方然 on 16/3/11.
//  Copyright © 2016年 li. All rights reserved.
//

import UIKit
import AVOSCloud

class inputsleepViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var editdone: UIButton!
    
    let sele=HDsleep.query()
    let user=AVUser.currentUser()
    var selesleeprecords:[HDsleep]?
    var flag:Int = -1
    
    @IBAction func editbtn(sender: AnyObject) {
        
        if selesleepTableView.editing==true{
            editdone.setTitle("edit", forState: .Normal)
            selesleepTableView.editing=false
        }else{
            editdone.setTitle("done", forState: .Normal)
            selesleepTableView.editing=true
        }
        
    }
    @IBAction func cancel(sender: AnyObject) {
        flag = -1
        
        UIView.animateWithDuration(0.7) { () -> Void in
            self.newsleeprecord.center.y=self.view.center.y+self.view.frame.height
            
        }
        
    }
    
    @IBOutlet weak var newsleeprecord: UIView!
    @IBOutlet weak var selesleepTableView: UITableView!
    var inputsleepTVC:inputsleepTableViewController?
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 18))
        let label = UILabel(frame: CGRectMake(10, 5, tableView.frame.size.width, 18))
        label.font = UIFont.systemFontOfSize(14)
        label.text = "睡眠数据"
        view.addSubview(label)
        view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        return view
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        sele.whereKey("user", equalTo: user)
        sele.orderByDescending("updatedAt")
        selesleeprecords=sele.findObjects() as? [HDsleep]

        return (selesleeprecords?.count)!
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            
            selesleeprecords![indexPath.row].delete()
            self.selesleepTableView.reloadData()
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.selesleepTableView.dequeueReusableCellWithIdentifier("sleeprecordcell", forIndexPath: indexPath)
        
        let record=selesleeprecords![indexPath.row]
        cell.textLabel?.text=dayformat.stringFromDate(record.date)
        let durationHour=Int(record.duration/60)
        let durationMinute=Int(record.duration)-durationHour*60
        cell.detailTextLabel?.text="\(durationHour)小时\(durationMinute)分钟"
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        flag = indexPath.row
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
       
        
        inputsleepTVC?.currentdate=selesleeprecords![flag].date
        inputsleepTVC?.duration=selesleeprecords![flag].duration
        inputsleepTVC?.startAt=selesleeprecords![flag].startAt
        inputsleepTVC?.endAt=selesleeprecords![flag].endAt
        
        inputsleepTVC?.date.text=dayformat.stringFromDate(selesleeprecords![indexPath.row].date)
        inputsleepTVC?.starttime.detailTextLabel?.text=hourformat.stringFromDate(selesleeprecords![indexPath.row].startAt)
        inputsleepTVC?.endtime.detailTextLabel?.text=hourformat.stringFromDate(selesleeprecords![indexPath.row].endAt)
        
        inputsleepTVC?.datepicker.date=selesleeprecords![flag].date //reset datepicker
        
        let durationHour=Int(selesleeprecords![indexPath.row].duration/60)
        let durationMinute=Int(selesleeprecords![indexPath.row].duration)-durationHour*60
        inputsleepTVC?.durationcell.detailTextLabel?.text="\(durationHour)小时\(durationMinute)分钟"
        
        UIView.animateWithDuration(0.7) { () -> Void in
            self.newsleeprecord.center.y=self.view.center.y+75
            
        }
    }
    
    
    //save
    @IBAction func savesleep(sender: AnyObject) {
        let sleeprecord=HDsleep()
        
        if flag == -1{
        sleeprecord.user=user
        sleeprecord.startAt=(inputsleepTVC?.startAt)!
        sleeprecord.endAt=(inputsleepTVC?.endAt)!
        sleeprecord.duration=(inputsleepTVC?.duration)!
        sleeprecord.date=(inputsleepTVC?.currentdate)!
        sleeprecord.save()
        }else{
            selesleeprecords![flag].date=(inputsleepTVC?.currentdate)!
            selesleeprecords![flag].duration=(inputsleepTVC?.duration)!
            selesleeprecords![flag].startAt=(inputsleepTVC?.startAt)!
            selesleeprecords![flag].endAt=(inputsleepTVC?.endAt)!
            selesleeprecords![flag].save()
        }
        
        sele.cachePolicy = .NetworkOnly
        selesleepTableView.reloadData()
        flag = -1
        UIView.animateWithDuration(0.7) { () -> Void in
            self.newsleeprecord.center.y=self.view.center.y+self.view.frame.height
            
        }
    }
    
    
    //new
    
    @IBAction func newsleepbtn(sender: AnyObject) {
        
        flag = -1
        
        inputsleepTVC?.datepicker.date=NSDate() //reset datepicker
        
        UIView.animateWithDuration(0.7) { () -> Void in
            self.newsleeprecord.center.y=self.view.center.y+75
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier=="sleepdataSegue"{
            self.inputsleepTVC=segue.destinationViewController as? inputsleepTableViewController
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sele.cachePolicy = .CacheElseNetwork
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.newsleeprecord.center.y=self.view.center.y+self.view.frame.height
    }
}