//
//  CircleTableViewController.swift
//  
//
//  Created by 李方然 on 16/5/8.
//
//

import UIKit
import AVOSCloud

class CircleTableViewController: UITableViewController,refreshMyCircleDelegate {

    var myCircles:[FCUserHealthCircle]?
    var sele = FCUserHealthCircle.query()
    var circleVC:CircleTwitterTableViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        sele.whereKey("user", equalTo: AVUser.currentUser())
        myCircles = sele.findObjects() as? [FCUserHealthCircle]
        return (myCircles?.count)!
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("circleCell", forIndexPath: indexPath)
        let record=myCircles![indexPath.row]
        let seleCircle = FCHealthCircle.query()
        seleCircle.whereKey("objectId", equalTo: record.circle.objectId)
        let mycell = seleCircle.getFirstObject() as! FCHealthCircle
        cell.textLabel?.text = mycell.circleName
        cell.detailTextLabel?.text = mycell.circleNumber
        return cell
    }
    
    func refreshMyCircle() {
        self.tableView.reloadData()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addCircleSegue"{
            let addCircleVC = segue.destinationViewController as! addCircleTableViewController
            addCircleVC.delegate = self
        }
        if segue.identifier == "healthCircleSegue"{
            circleVC = segue.destinationViewController as? CircleTwitterTableViewController
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("healthCircleSegue",sender:self);
        circleVC?.circle = myCircles![indexPath.row].circle
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

