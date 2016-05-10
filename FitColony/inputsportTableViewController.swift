//
//  inputsportTableViewController.swift
//  FitColony
//
//  Created by 李方然 on 16/3/14.
//  Copyright © 2016年 li. All rights reserved.
//

import UIKit

class inputsportTableViewController: UITableViewController{
    
    var delegate:ChooseSportDelegate?
    var startAt:NSDate?
    var endAt:NSDate?
    var currentdate:NSDate=NSDate()
    var duration:Double=0.0
    
    @IBOutlet weak var sport: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var durationcell: UITableViewCell!
    @IBOutlet weak var endtime: UITableViewCell!
    @IBOutlet weak var starttime: UITableViewCell!
    @IBOutlet weak var datepicker: UIDatePicker!
    
    @IBAction func pickdate(sender: AnyObject) {
        
        let cdate=dayformat.stringFromDate(self.datepicker.date)
        self.date.text=cdate
        currentdate=dateformat.dateFromString(cdate+" 00:00")!
        
        
        if starttime.selected==true{
            
            let cdate=hourformat.stringFromDate(self.datepicker.date)
            self.starttime.detailTextLabel?.text=cdate
            startAt=dateformat.dateFromString(self.date.text!+" "+cdate)
        }
        
        if endtime.selected==true{
            
            let cdate=hourformat.stringFromDate(self.datepicker.date)
            self.endtime.detailTextLabel?.text=cdate
            endAt=dateformat.dateFromString(self.date.text!+" "+cdate)
        }
        
        let start=self.starttime.detailTextLabel!.text
        let end=self.endtime.detailTextLabel!.text
        let timeinterval:NSTimeInterval=hourformat.dateFromString(end!)!.timeIntervalSinceDate(hourformat.dateFromString(start!)!)
        let durationHour=Int(timeinterval/3600)
        let durationMinute=Int(timeinterval/60)-durationHour*60
        
        duration=timeinterval/60
        durationcell.detailTextLabel?.text="\(durationHour)小时\(durationMinute)分钟"
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    
        startAt=dateformat.dateFromString(dayformat.stringFromDate(NSDate())+" 00:00")
        endAt=dateformat.dateFromString(dayformat.stringFromDate(NSDate())+" 00:00")
        duration=0.0
        
        self.date.text=dayformat.stringFromDate(currentdate)
            
        starttime.detailTextLabel?.text=hourformat.stringFromDate(startAt!)
        endtime.detailTextLabel?.text=hourformat.stringFromDate(endAt!)
        
        let durationHour=Int(duration/60)
        let durationMinute=Int(duration)-durationHour*60
        durationcell.detailTextLabel?.text="\(durationHour)小时\(durationMinute)分钟"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row==0{
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.delegate?.choosesport()
        }
        
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
