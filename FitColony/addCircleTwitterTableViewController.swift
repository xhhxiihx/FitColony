//
//  addCircleTwitterTableViewController.swift
//  FitColony
//
//  Created by 李方然 on 16/5/9.
//  Copyright © 2016年 li. All rights reserved.
//

import UIKit
import AVOSCloud

class addCircleTwitterTableViewController: UITableViewController {



    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var event: UILabel!
    
    @IBOutlet weak var comment: UITextField!
    
    var circle:FCHealthCircle?
    var user = AVUser.currentUser()
    var circleTwitter:FCHealthCircleTwitter = FCHealthCircleTwitter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func chooseact(){
        
        let chooseact=UIAlertController(title:"请选择项目", message:"", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        

        
        let walkAction = UIAlertAction(title: "步行", style: UIAlertActionStyle.Default){
            (UIAlertAction) -> Void in
            self.event.text = "步行"
            
        }
        
        let jogAction = UIAlertAction(title: "慢跑", style: UIAlertActionStyle.Default){
            (UIAlertAction) -> Void in
            self.event.text = "慢跑"
        }
        
        let swimAction = UIAlertAction(title: "游泳", style: UIAlertActionStyle.Default){
            (UIAlertAction) -> Void in
            self.event.text = "游泳"
        }
        let fitAction = UIAlertAction(title: "健身", style: UIAlertActionStyle.Default){
            (UIAlertAction) -> Void in
            self.event.text = "健身"
        }
        
        
        chooseact.addAction(cancelAction)

        chooseact.addAction(walkAction)
        chooseact.addAction(jogAction)
        chooseact.addAction(swimAction)
        chooseact.addAction(fitAction)
        
        self.presentViewController(chooseact, animated: true, completion: nil)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) && (indexPath.row == 0){
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            chooseact()
        }
        if (indexPath.section == 0) && (indexPath.row == 3){
            newTwitter()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.navigationController?.popViewControllerAnimated(true)
        }

    }
    func newTwitter(){
        circleTwitter.event = event.text!
        circleTwitter.date = datePicker.date
        if comment.text == "" {
            circleTwitter.comment = "来活动一下吧！"
        }else{
            circleTwitter.comment = comment.text!
        }
        
        circleTwitter.user = user
        circleTwitter.circle = circle!
        circleTwitter.participate = [user]
        circleTwitter.save()
    }
    
    
    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

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
