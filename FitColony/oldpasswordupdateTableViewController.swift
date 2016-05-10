//
//  oldpasswordupdateTableViewController.swift
//  FitColony
//
//  Created by 李方然 on 16/4/1.
//  Copyright © 2016年 li. All rights reserved.
//

import UIKit
import AVOSCloud

class oldpasswordupdateTableViewController: UITableViewController {

    @IBOutlet weak var newpasswordagain: UITextField!
    @IBOutlet weak var newpassword: UITextField!
    @IBOutlet weak var oldpassword: UITextField!
    
    func alert(text:String){
        let alertController = UIAlertController(title: "密码重置", message: text, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.navigationController?.popViewControllerAnimated(true)
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    
    func alertdiffer(text:String){
        let alertController = UIAlertController(title: "密码重置", message: text, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    
    func save(){
        
        if newpassword.text == newpasswordagain.text{
            let user = AVUser.currentUser()
            user.updatePassword(oldpassword.text, newPassword: newpassword.text, block: { (object:AnyObject!, error:NSError!) -> Void in
                if error != nil{
                    self.alert("修改成功")
                }else{
                    self.alert("修改失败,请检查网络")
                }
            })
            
        }else{
            alertdiffer("两次输入的新密码不同,请重新输入")
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="重置密码"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "save", style: .Plain, target: self, action: #selector(oldpasswordupdateTableViewController.save))
        newpasswordagain.secureTextEntry = true
        newpassword.secureTextEntry = true
        oldpassword.secureTextEntry = true
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
