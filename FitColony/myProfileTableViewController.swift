//
//  myProfileTableViewController.swift
//  FitColony
//
//  Created by 李方然 on 16/3/31.
//  Copyright © 2016年 li. All rights reserved.
//

import UIKit
import AVOSCloud

class myProfileTableViewController: UITableViewController,refreshUserProfile {

    @IBOutlet weak var briefCell: UITableViewCell!
    @IBOutlet weak var areaCell: UITableViewCell!
    @IBOutlet weak var emailCell: UITableViewCell!
    @IBOutlet weak var accountCell: UITableViewCell!
    @IBOutlet weak var nameCell: UITableViewCell!
    @IBOutlet weak var avatarCell: UITableViewCell!
    
    var delegate:getProfileDelegate?
    
    let user=AVUser.currentUser()
    var myProfile:UserProfile=UserProfile()
    
    var avatar:UIImage = UIImage(named: "defaultAvartar")!
    var name:String?
    var email:String?
    var area:String?
    var brief:String?
    
    //delegate
    func refreshAvatar(avatar:UIImage) {
        self.avatarCell.imageView?.image = avatar
        self.avatar = avatar
    }
    func refreshName(name:String) {
        self.nameCell.detailTextLabel?.text = name
        self.name = name
    }
    
    func refreshEmail(email:String) {
        self.emailCell.detailTextLabel?.text = email
        self.email = email
    }
    
    func refreshArea(area:String) {
        self.areaCell.detailTextLabel?.text = area
        self.area = area
    }
    
    func refreshBrief(brief:String) {
        self.briefCell.detailTextLabel?.text = brief
        self.brief = brief
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "getAvatarSegue" {
            let avatarVC = segue.destinationViewController as! avatarViewController
            avatarVC.delegate = self
            avatarVC.avatarImage = avatar
            if myProfile.avartar != nil{
                
                avatarVC.previousId = myProfile.avartar?.objectId
            }
            setTabBarVisible(!tabBarIsVisible(), animated: true)
        }
        
        if segue.identifier == "getNameSegue" {
            let nameVC = segue.destinationViewController as! nameTableViewController
            nameVC.delegate = self
            nameVC.name = name
            nameVC.myProfile = self.myProfile
        }
        if segue.identifier == "getEmailSegue" {
            let emailVC = segue.destinationViewController as! emailTableViewController
            emailVC.delegate = self
            emailVC.email = email
            
        }

        if segue.identifier == "getAreaSegue" {
            let areaVC = segue.destinationViewController as! areaTableViewController
            areaVC.delegate = self
            areaVC.area = area
            areaVC.myProfile = self.myProfile
        }
        if segue.identifier == "getBriefSegue" {
            let briefVC = segue.destinationViewController as! briefTableViewController
            briefVC.delegate = self
            briefVC.brief = brief
            briefVC.myProfile = self.myProfile
        }

    }
    
    
    
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.getProfile()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="我的信息"
        
        let sele = UserProfile.query()
        sele.whereKey("user", equalTo: user)
        myProfile = sele.getFirstObject() as! UserProfile
        
        if myProfile.avartar != nil{
            myProfile.avartar?.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                if error == nil {
                    self.avatar = UIImage(data: data!)!
                    self.avatarCell.imageView?.image = self.avatar
                }
            })
        }
        self.nameCell.detailTextLabel!.text = myProfile.name
        self.accountCell.detailTextLabel!.text = user.username
        self.areaCell.detailTextLabel!.text = myProfile.area
        self.briefCell.detailTextLabel!.text = myProfile.brief
        self.emailCell.detailTextLabel!.text = user.email
        
        self.name = myProfile.name
        self.area = myProfile.area
        self.brief = myProfile.brief
        self.email = user.email
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section==0 && indexPath.row==0 {
            self.performSegueWithIdentifier("getAvatarSegue",sender:self)
        }
        if indexPath.section == 0 && indexPath.row == 1{
            self.performSegueWithIdentifier("getNameSegue",sender:self)
        }
        if indexPath.section == 0 && indexPath.row == 3{
            self.performSegueWithIdentifier("getEmailSegue",sender:self)
        }
        if indexPath.section == 1 && indexPath.row == 0{
            self.performSegueWithIdentifier("getAreaSegue",sender:self)
        }
        if indexPath.section == 1 && indexPath.row == 1{
            self.performSegueWithIdentifier("getBriefSegue",sender:self)
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
