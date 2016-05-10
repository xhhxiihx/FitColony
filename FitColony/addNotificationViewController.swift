//
//  addNotificationViewController.swift
//  FitColony
//
//  Created by 李方然 on 16/3/29.
//  Copyright © 2016年 li. All rights reserved.
//

import UIKit
import AVOSCloud

class addNotificationTableViewController: UITableViewController {
    
    @IBOutlet weak var isNotifiedSwitch: UISwitch!
    @IBOutlet weak var isImportantSwitch: UISwitch!
    
    @IBOutlet weak var notifiedNote: UITextField!
    @IBOutlet weak var timeCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var chooseAct: UITableViewCell!
    
    var delegate:refreshcalenderDelegate?
    var fromuser:AVUser = AVUser.currentUser()
    var touser:AVUser = AVUser.currentUser()
    
    var plan:NPrecord?
    
    var date:NSDate=NSDate()
    
    var activity:String="睡觉"
    var notifiedAt:NSDate = NSDate()
    var isImportant:Bool = false
    var isNotified:Bool = false
    var notifiedcomment:String = ""
    
    var datePickerHidden = true
    var notifiednoteHidden = true
    var deleteButtonHidden = true
    
    @IBAction func dateisPicked(sender: AnyObject) {
        timeCell.detailTextLabel?.text = hourformat.stringFromDate(datePicker.date)
        
    }
    
    @IBAction func isNotified(sender: AnyObject) {
        
        if isNotifiedSwitch.on == true {
            
            notifiedNote.becomeFirstResponder()
        }else{
            notifiedNote.resignFirstResponder()
        }
        toggleNotifiednote()
        
    }
    
    
    //save button
    func saverecord(){
        
        isNotified = isNotifiedSwitch.on
        isImportant = isImportantSwitch.on
        if isNotified {
            if notifiedNote.text == ""{
                notifiedcomment = notifiedNote.placeholder!
            }else{
                notifiedcomment = notifiedNote.text!
            }
        }
        notifiedAt = dateformat.dateFromString(dayformat.stringFromDate(date)+" "+(timeCell.detailTextLabel?.text)!)!
        if plan == nil {
            plan = NPrecord()
        }
        plan!.event = activity
        plan!.isNotified = isNotified
        plan!.isImportant = isImportant
        plan!.notifiedcomment = notifiedcomment
        plan!.from = fromuser
        plan!.to = touser
        plan!.notifiedAt = notifiedAt
        plan!.save()
        delegate!.refreshcalender()
        delegate!.refreshtable()
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        if plan != nil{
            
            isImportant=(plan?.isImportant)!
            isNotified=(plan?.isNotified)!
            activity=(plan?.event)!
            notifiedcomment=(plan?.notifiedcomment)!
            notifiedAt=(plan?.notifiedAt)!
            notifiedNote.placeholder = "\(self.activity)的时间到了,快放下手中的事,去\(self.activity)吧！"
            deleteButtonHidden=false
            chooseAct.detailTextLabel?.text = activity
            timeCell.detailTextLabel?.text = hourformat.stringFromDate(notifiedAt)
            isNotifiedSwitch.on = isNotified
            isImportantSwitch.on = isImportant
        }
        datePicker.hidden = true
        notifiedNote.text = notifiedcomment
        notifiednoteHidden = !isNotified
        self.navigationItem.title=weekdayformat.stringFromDate(date)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "save", style: .Plain, target: self, action: #selector(addNotificationTableViewController.saverecord))
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Call the function from tap gesture recognizer added to your view (or button)
    
    //select
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0) && (indexPath.section == 0){
            chooseact()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
        }
        if indexPath.section == 0 && indexPath.row == 1 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            toggleDatepicker()
        }
        
        if indexPath.section == 2 && indexPath.row == 0 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            plan?.delete()
            delegate?.refreshcalender()
            delegate?.refreshtable()

            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    func toggleDatepicker() {
        
        datePickerHidden = !datePickerHidden
        datePicker.hidden = !datePicker.hidden
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    func toggleNotifiednote() {
        
        notifiednoteHidden = !notifiednoteHidden
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if deleteButtonHidden && indexPath.section == 2 && indexPath.row == 0{
            return 0
        }else if notifiednoteHidden && indexPath.section == 0 && indexPath.row == 4{
            return 0
        }else if datePickerHidden && indexPath.section == 1 && indexPath.row == 0 {
            return 0
        }
        else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    func didselectact(act:String){
        self.activity = act
        self.chooseAct.detailTextLabel?.text = self.activity
        self.notifiedNote.placeholder = "\(self.activity)的时间到了,快放下手中的事,去\(self.activity)吧！"
    }
    // choose activity
    func chooseact(){
        
        let chooseact=UIAlertController(title:"请选择项目", message:"", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        
        let sleepAction = UIAlertAction(title: "睡觉", style: .Default) { (UIAlertAction) -> Void in
            self.didselectact("睡觉")
            
        }
        
        let walkAction = UIAlertAction(title: "步行", style: UIAlertActionStyle.Default){
            (UIAlertAction) -> Void in
            self.didselectact("步行")
            
        }
        
        let jogAction = UIAlertAction(title: "慢跑", style: UIAlertActionStyle.Default){
            (UIAlertAction) -> Void in
            self.didselectact("慢跑")
        }
        
        let swimAction = UIAlertAction(title: "游泳", style: UIAlertActionStyle.Default){
            (UIAlertAction) -> Void in
            self.didselectact("游泳")
            
        }
        let fitAction = UIAlertAction(title: "健身", style: UIAlertActionStyle.Default){
            (UIAlertAction) -> Void in
            self.didselectact("健身")
            
        }
        
        
        chooseact.addAction(cancelAction)
        chooseact.addAction(sleepAction)
        chooseact.addAction(walkAction)
        chooseact.addAction(jogAction)
        chooseact.addAction(swimAction)
        chooseact.addAction(fitAction)
        
        self.presentViewController(chooseact, animated: true, completion: nil)
        
    }
    
    
    
    
    //show tabBar
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        setTabBarVisible(!tabBarIsVisible(), animated: true)
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
