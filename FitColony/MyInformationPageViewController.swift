//
//  MyInformationPageViewController.swift
//  FitColony
//
//  Created by 李方然 on 16/3/11.
//  Copyright © 2016年 li. All rights reserved.
//
import UIKit
import AVOSCloud

class MyInformationPageViewController: UIPageViewController {
    
    @IBOutlet weak var skipbtn: UIButton!
    
    @IBOutlet weak var backbtn: UIButton!
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func skip(sender: AnyObject) {
        let presentingViewController: UIViewController! = self.presentingViewController
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc:UITabBarController=storyboard.instantiateViewControllerWithIdentifier("tabbarViewController") as! UITabBarController
        self.dismissViewControllerAnimated(false){
            presentingViewController.presentViewController(vc, animated: true,completion: nil)
        }
        
    }
    
    
    
      private(set) lazy var orderedViewControllers:[UIViewController]={
        return [self.newinputViewController("profile"),
            self.newinputViewController("sport"),
            self.newinputViewController("sleep")]
    }()
    
    private func newinputViewController(input: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewControllerWithIdentifier("input\(input)ViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sele=HDprofile.query()
        let user=AVUser.currentUser()
        sele.whereKey("user", equalTo: user)
        if sele.getFirstObject()==nil{
            self.skipbtn.hidden=false
            self.backbtn.hidden=true
        }else{
            self.backbtn.hidden=false
            self.skipbtn.hidden=true
        }
        
        dataSource = self
        
        stylePageControl()
        if let firstViewController = orderedViewControllers.first{
            setViewControllers([firstViewController], direction: .Forward, animated: true, completion: nil)
        }
        
       
    }
    private func stylePageControl() {
        let pageControl = UIPageControl.appearanceWhenContainedInInstancesOfClasses([self.dynamicType])
        
        pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
        pageControl.pageIndicatorTintColor = UIColor.grayColor()
        pageControl.backgroundColor = UIColor.whiteColor()
    }
    
}


extension MyInformationPageViewController: UIPageViewControllerDataSource{
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex=orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard orderedViewControllers.count != nextIndex else{
            return nil
        }
        guard orderedViewControllers.count > nextIndex else{
            return nil
        }
        return orderedViewControllers[nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            firstViewControllerIndex = orderedViewControllers.indexOf(firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
    
}
