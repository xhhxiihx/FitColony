//
//  addCircleTableViewController.swift
//  FitColony
//
//  Created by 李方然 on 16/5/8.
//  Copyright © 2016年 li. All rights reserved.
//

import UIKit
import AVOSCloud

class addCircleTableViewController: UITableViewController {

    @IBOutlet weak var circleNumber: UITextField!
    @IBOutlet weak var circleName: UITextField!
    @IBOutlet weak var circlePassword: UITextField!
    var randomId:String="ID"
    var circle:FCHealthCircle = FCHealthCircle()
    var userCircle:FCUserHealthCircle = FCUserHealthCircle()
    var delegate:refreshMyCircleDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarVisible(!tabBarIsVisible(), animated: true)
        for _ in 0...5{
            let random = Int(arc4random_uniform(9))
            randomId = randomId + String(random)
        }
        circleNumber.placeholder = randomId
        self.navigationItem.title = "新建/加入圈"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    //show tabBar
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        setTabBarVisible(!tabBarIsVisible(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row==1) && (indexPath.section==3){
            newCircle()
            delegate?.refreshMyCircle()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        if (indexPath.row==0) && (indexPath.section==3){
            if joinCircle(){
                delegate?.refreshMyCircle()
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                self.navigationController?.popViewControllerAnimated(true)
            }else{
                alert("加入失败,请重新检查信息")
            }
        }
    }
    
    func alert(text:String){
        let alertController = UIAlertController(title: "警告", message: text, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.navigationController?.popViewControllerAnimated(true)
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    func newCircle(){
        circle.circleNumber = randomId
        if (circleName.text != nil){
            circle.circleName = circleName.text!
        }
        if (circlePassword.text != nil){
            circle.circlePassword = circlePassword.text!
        }
        circle.save()
        userCircle.circle = circle
        userCircle.user = AVUser.currentUser()
        userCircle.save()
    }
    func joinCircle()->Bool{
        let sele = FCHealthCircle.query()
        var _circleNumber:String = "ID"
        if (circleNumber.text != nil){
            _circleNumber = circleNumber.text!
        }
        sele.whereKey("circleNumber", equalTo: _circleNumber)
        if (sele.countObjects()==0){
            return false
        }else{
            circle = sele.getFirstObject() as! FCHealthCircle
            if circle.circlePassword != circlePassword.text{
                return false
            }
        }
        let seleRelationUser = FCUserHealthCircle.query()
        seleRelationUser.whereKey("user", equalTo: AVUser.currentUser())
        let seleRelationCircle = FCUserHealthCircle.query()
        seleRelationCircle.whereKey("circle", equalTo: circle)
        let seleRelation: AVQuery = AVQuery.andQueryWithSubqueries([seleRelationUser, seleRelationCircle])
        if seleRelation.countObjects() == 0 {
            userCircle.user = AVUser.currentUser()
            userCircle.circle = circle
            return userCircle.save()
        }else{
            return false
        }
        
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
