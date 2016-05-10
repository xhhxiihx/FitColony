//
//  MyBasicViewController.swift
//  FitColony
//
//  Created by 李方然 on 16/3/11.
//  Copyright © 2016年 li. All rights reserved.
//

import UIKit
import AVOSCloud
class inputprofileViewController: UIViewController {
    let user=AVUser.currentUser()
    
    @IBOutlet weak var sexSegment: UISegmentedControl!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var bustlineTextField: UITextField!
    @IBOutlet weak var waistlineTextField: UITextField!
    @IBOutlet weak var hipslineTextField: UITextField!
    
    @IBAction func save(sender: AnyObject) {
        let sele=HDprofile.query()
        
        
        sele.whereKey("user", equalTo: user)
        sele.getFirstObjectInBackgroundWithBlock ({ (object:AVObject!, error:NSError!) in
            if object==nil {
                
                let profile=HDprofile()
                profile.height=Double(self.heightTextField.text!)!
                profile.weight=Double(self.weightTextField.text!)!
                profile.age=Double(self.ageTextField.text!)!
                if self.sexSegment.selectedSegmentIndex == 0{
                    profile.sex="male"
                }else{
                    profile.sex="female"
                }
                profile.bustline=Double(self.bustlineTextField.text!)!
                profile.waistline=Double(self.waistlineTextField.text!)!
                profile.hipsline=Double(self.hipslineTextField.text!)!
                profile.bMI = (profile.weight)/(profile.height*profile.height)*10000
                let a=profile.bMI*1.2
                let b=0.23*profile.age
                let c=10.8*(1-Double(self.sexSegment.selectedSegmentIndex))
                profile.bodyfatrate = a + b - 5.4 - c
                profile.user=self.user
                profile.save()
                
            }else{
                let profile=object as! HDprofile
                
                profile.height=Double(self.heightTextField.text!)!
                profile.weight=Double(self.weightTextField.text!)!
                profile.age=Double(self.ageTextField.text!)!
                if self.sexSegment.selectedSegmentIndex == 0{
                    profile.sex="male"
                }else{
                    profile.sex="female"
                }
                profile.bustline=Double(self.bustlineTextField.text!)!
                profile.waistline=Double(self.waistlineTextField.text!)!
                profile.hipsline=Double(self.hipslineTextField.text!)!
                profile.bMI = (profile.weight)/(profile.height*profile.height)*10000
                let a=profile.bMI*1.2
                let b=0.23*profile.age
                let c=10.8*(1-Double(self.sexSegment.selectedSegmentIndex))
                profile.bodyfatrate = a + b - 5.4 - c
                profile.save()
            }
        })
        alert("保存成功")
    }
    func alert(text:String){
        let alertController = UIAlertController(title: "提示", message: text, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let sele=HDprofile.query()
        sele.whereKey("user", equalTo: user)
        var profile:HDprofile?
        profile=sele.getFirstObject() as? HDprofile
        if profile==nil {
            self.heightTextField.text=""
            self.weightTextField.text=""
            self.ageTextField.text=""
            self.sexSegment.selectedSegmentIndex=0
            self.bustlineTextField.text=""
            self.waistlineTextField.text=""
            self.hipslineTextField.text=""
            
        }else{
            self.heightTextField.text=String(profile!.height)
            self.weightTextField.text=String(profile!.weight)
            self.ageTextField.text=String(profile!.age)
            if profile!.sex == "female"{
                self.sexSegment.selectedSegmentIndex=1
            }else{
                self.sexSegment.selectedSegmentIndex=0
            }
            self.bustlineTextField.text=String(profile!.bustline)
            self.waistlineTextField.text=String(profile!.waistline)
            self.hipslineTextField.text=String(profile!.hipsline)
        }
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}
