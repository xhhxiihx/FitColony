//
//  avatarViewController.swift
//  FitColony
//
//  Created by 李方然 on 16/3/31.
//  Copyright © 2016年 li. All rights reserved.
//

import UIKit
import AVOSCloud


class avatarViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    var avatarFile:AVFile = AVFile()
    var userProfile:UserProfile = UserProfile()
    let user=AVUser.currentUser()
    var previousId:String?
    
    @IBOutlet weak var imageDisplay: UIImageView!
    
    var delegate:refreshUserProfile?
    
    var avatarImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sele=UserProfile.query()
        sele.whereKey("user", equalTo: user)
        userProfile = (sele.getFirstObject() as? UserProfile)!
        
        self.imageDisplay.image = avatarImage!
        self.navigationItem.title = "头像"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "···", style: .Plain, target: self, action: #selector(avatarViewController.chooseAvatar))
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func chooseAvatar(){
            
            let chooseAvatar=UIAlertController(title:nil, message:nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
            
        
            let cameraAction = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default){
                (UIAlertAction) -> Void in
                let picker = UIImagePickerController()
                
                picker.delegate = self
                picker.sourceType = .Camera
                
                self.presentViewController(picker, animated: true, completion: nil)
                
            }
            let photolibraryAction = UIAlertAction(title: "从手机相册选择", style: UIAlertActionStyle.Default){
                (UIAlertAction) -> Void in
                
                let picker = UIImagePickerController()
                
                picker.delegate = self
                picker.sourceType = .PhotoLibrary
                
                self.presentViewController(picker, animated: true, completion: nil)

                
            }
            
            
            chooseAvatar.addAction(cancelAction)
            chooseAvatar.addAction(cameraAction)
            chooseAvatar.addAction(photolibraryAction)
            
            self.presentViewController(chooseAvatar, animated: true, completion: nil)
            
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        avatarImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        avatarImage = SquareImage(avatarImage!)
        
        imageDisplay.image = avatarImage
        
        let avatardata = UIImagePNGRepresentation(avatarImage!)
        avatarFile = AVFile(data: avatardata)
        avatarFile.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError!) -> Void in
            if succeeded {
                self.userProfile.avartar = self.avatarFile
                self.userProfile.saveInBackground()
            }
        })
        if previousId != nil {
           
            AVFile.getFileWithObjectId(previousId, withBlock: { (file:AVFile!, error:NSError!) -> Void in
                
                file.deleteInBackgroundWithBlock({ (succeeded:Bool, error:NSError!) -> Void in
                    if succeeded {
                        
                    }else{
                        print(error)
                    }
                })
            })
            
        }
        
        
        self.delegate?.refreshAvatar(avatarImage!)
        
        
        dismissViewControllerAnimated(true, completion: nil)
        setTabBarVisible(!tabBarIsVisible(), animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        setTabBarVisible(!tabBarIsVisible(), animated: true)
    }
    
    func SquareImage(image: UIImage) -> UIImage {
        let originalWidth  = image.size.width
        let originalHeight = image.size.height
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        var edge: CGFloat = 0.0
        
        if (originalWidth > originalHeight) {
            // landscape
            edge = originalHeight
            x = (originalWidth - edge) / 2.0
            y = 0.0
            
        } else if (originalHeight > originalWidth) {
            // portrait
            edge = originalWidth
            x = 0.0
            y = (originalHeight - originalWidth) / 2.0
        } else {
            // square
            edge = originalWidth
        }
        
        let cropSquare = CGRectMake(x, y, edge, edge)
        let imageRef = CGImageCreateWithImageInRect(image.CGImage, cropSquare);
        
        return UIImage(CGImage: imageRef!, scale: UIScreen.mainScreen().scale, orientation: image.imageOrientation)
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
