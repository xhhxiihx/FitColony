//
//  CircleTwitterTableViewController.swift
//  FitColony
//
//  Created by 李方然 on 16/5/8.
//  Copyright © 2016年 li. All rights reserved.
//

import UIKit
import AVOSCloud

class CircleTwitterTableViewController: UITableViewController {

    var circle:FCHealthCircle?
    let user=AVUser.currentUser()
    var seleUser = UserProfile.query()
    var myProfile:UserProfile?
    var sele = FCHealthCircleTwitter.query()
    var twitters:[FCHealthCircleTwitter]?
    var addCircleTwitterVC:addCircleTwitterTableViewController?
    var headCell:circleheadTableViewCell?
    var twitterCells:[circleTwitterTableViewCell] = [circleTwitterTableViewCell]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "新活动", style: .Plain, target: self, action: #selector(CircleTwitterTableViewController.newEvent))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func newEvent(){
        self.performSegueWithIdentifier("newEventSegue",sender:self);
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newEventSegue"{
            addCircleTwitterVC = segue.destinationViewController as? addCircleTwitterTableViewController
            addCircleTwitterVC?.circle = self.circle!
        }
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
        sele.whereKey("circle", equalTo: circle)
        sele.orderByAscending("createdAt")
        twitters = sele.findObjects() as? [FCHealthCircleTwitter]
        var count = twitters?.count
        if count == nil{
            count = 0
        }
        return count!+1
    }


    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) && (indexPath.row == 0){
            if (headCell == nil){
                headCell = tableView.dequeueReusableCellWithIdentifier("headCell", forIndexPath: indexPath) as? circleheadTableViewCell
                seleUser.whereKey("user", equalTo: user)
                myProfile = seleUser.getFirstObject() as? UserProfile
                if (myProfile?.avartar != nil){
                    headCell!.avartar.image = UIImage(data:(myProfile?.avartar?.getData())!)
                }
            }
            return headCell!
        }else{
            if (twitterCells.count < twitters?.count){
                let cell = tableView.dequeueReusableCellWithIdentifier("twitterCell", forIndexPath: indexPath) as! circleTwitterTableViewCell
                seleUser.whereKey("user", equalTo: twitters![indexPath.row-1].user)
                let userProfile = seleUser.getFirstObject() as? UserProfile
                if (userProfile?.avartar != nil){
                    cell.avatar.image = UIImage(data:(userProfile?.avartar?.getData())!)
                }
                
                cell.user.text = userProfile?.name
                cell.time.text = dateformat.stringFromDate(twitters![indexPath.row-1].date)
                cell.comment.text = twitters![indexPath.row-1].comment
                var imageName:String?
                let event = twitters![indexPath.row-1].event
                if event == "步行"{
                    imageName = "walk"
                }
                if event == "慢跑"{
                    imageName = "jog"
                }
                if event == "游泳"{
                    imageName = "swim"
                }
                if event == "健身"{
                    imageName = "fit"
                }
                cell.picture.image = UIImage(named: imageName!)
                let count = String(twitters![indexPath.row-1].participate!.count)
                cell.participateNumber.text = "共\(count)人参加了活动"
                cell.currentUser = user
                cell.circleTwitter = twitters![indexPath.row-1]
                if twitters![indexPath.row-1].participate!.contains(user){
                    cell.join.setTitle("已加入", forState: .Normal)
                    cell.join.setTitleColor(UIColor.grayColor(), forState: .Normal)
                    
                }
                twitterCells.append(cell)
                return cell
            }
            return twitterCells[indexPath.row-1]
            
        }
        
    }

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
