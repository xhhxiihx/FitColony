//
//  NotificationViewController.swift
//  FitColony
//
//  Created by 李方然 on 16/3/7.
//  Copyright © 2016年 li. All rights reserved.
//

import UIKit
import CVCalendar
import AVOSCloud

class NotificationViewController: UIViewController,refreshcalenderDelegate{
    
   

    
    @IBOutlet weak var notiTableView: UITableView!
    var addNoteVC:addNotificationTableViewController?
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var monthLabel: UILabel!
    
    var user=AVUser.currentUser()
    var sele=NPrecord.query()
    var notirecords=[NPrecord]()
    var dotMark=[String]()
    var circleMark=[String]()
    
    var shouldShowDaysOut = true
    var animationFinished = true
    var onedaydata=[NPrecord]()
    var selectedDay:DayView!
    
    var selectedDate:String=dayformat.stringFromDate(NSDate())

    func getSelectedDate(year:Int,month:Int,day:Int)->String{
        var date:NSDate?
        date = dayformat.dateFromString(String(year)+"-"+String(month)+"-"+String(day))
        if date == nil{
            date = dayformat.dateFromString("1970-1-1") //防止切换月份出错
        }
        return dayformat.stringFromDate(date!)
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
    
    func seleOneDayData(date:String)->[NPrecord]{
        var ondaydate=[NPrecord]()
        for i in notirecords{
            if dayformat.stringFromDate(i.notifiedAt) == date{
                ondaydate.append(i)
            }
        }
        return ondaydate
    }
    
    func refreshtable(){
        self.notiTableView.reloadData()
    }
    
    func refreshcalender(){
        
        dotMark.removeAll()
        circleMark.removeAll()
        
        sele.whereKey("to", equalTo: user)
        sele.orderByAscending("notifiedAt")
        notirecords = sele.findObjects() as! [NPrecord]
        
        for i in notirecords{
            dotMark.append(dayformat.stringFromDate(i.notifiedAt))
            if i.isImportant {
                circleMark.append(dayformat.stringFromDate(i.notifiedAt))
            }
        }
        calendarView.contentController.refreshPresentedMonth()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        sele.whereKey("to", equalTo: user)
        notirecords = sele.findObjects() as! [NPrecord]
        
        for i in notirecords{
            dotMark.append(dayformat.stringFromDate(i.notifiedAt))
            if i.isImportant {
                circleMark.append(dayformat.stringFromDate(i.notifiedAt))
            }
        }
       
        monthLabel.text = CVDate(date: NSDate()).globalDescription
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        addNoteVC = segue.destinationViewController as? addNotificationTableViewController
        
        if selectedDay != nil{
            let datestr=String(selectedDay.date.year)+"-"+String(selectedDay.date.month)+"-"+String(selectedDay.date.day)
            addNoteVC?.date=dayformat.dateFromString(datestr)!
        }
        addNoteVC?.delegate=self
        
    }
    
}

//tableview
extension NotificationViewController:UITableViewDataSource,UITableViewDelegate{
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "日程表"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        setTabBarVisible(!tabBarIsVisible(), animated: true)
        self.performSegueWithIdentifier("notiSegue",sender:self)
        addNoteVC?.plan = onedaydata[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        onedaydata = seleOneDayData(selectedDate)
        return onedaydata.count
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            
            onedaydata[indexPath.row].delete()
            
            refreshcalender()

            self.notiTableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.notiTableView.dequeueReusableCellWithIdentifier("notiTableCell", forIndexPath: indexPath)
        let rowdata = onedaydata[indexPath.row]
        cell.textLabel?.text = rowdata.event
        cell.detailTextLabel?.text = hourformat.stringFromDate(rowdata.notifiedAt)

        return cell
    }

}





extension NotificationViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    /// Required method to implement!
    func dotMarker(moveOffsetOnDayView dayView: DayView) -> CGFloat {
        return 11
    }
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    // MARK: Optional methods
    
    func shouldShowWeekdaysOut() -> Bool {
        return shouldShowDaysOut
    }
    
    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    
    //mark:DID SELECT DAY
    
    
    func didSelectDayView(dayView: CVCalendarDayView, animationDidFinish: Bool) {
        print("\(dayView.date.commonDescription) is selected!")
        selectedDay = dayView
        let loopdate = selectedDay.date
        let str=getSelectedDate(loopdate.year, month: loopdate.month, day: loopdate.day)
        selectedDate = str
        notiTableView.reloadData()
    }
    
    
    
    
    
    
    func presentedDateUpdated(date: CVDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .Center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransformMakeTranslation(0, offset)
            updatedMonthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
            
            UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransformMakeTranslation(0, -offset)
                self.monthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransformIdentity
                
                }) { _ in
                    
                    self.animationFinished = true
                    self.monthLabel.frame = updatedMonthLabel.frame
                    self.monthLabel.text = updatedMonthLabel.text
                    self.monthLabel.transform = CGAffineTransformIdentity
                    self.monthLabel.alpha = 1
                    updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        
        let loopdate = dayView.date
        if dotMark.contains(getSelectedDate(loopdate.year, month: loopdate.month, day: loopdate.day)){
            return true
        }
     
        return false
        
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        
        var dotcount:Int = 0
        let loopdate = dayView.date
        let colorforone = UIColor.greenColor()
        let colorfortwo = UIColor.orangeColor()
        let colorforthree = UIColor.redColor()
        
        let str = getSelectedDate(loopdate.year, month: loopdate.month, day: loopdate.day)
        
        for i in dotMark{
            
            if str == i {
                dotcount += 1
            }
        }
        
        switch dotcount{
            case 1: return [colorforone] // return 1 dot
            case 2: return [colorfortwo,colorfortwo]
            default: return [colorforthree,colorforthree,colorforthree]
        }
        
        
        
       
        
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return false
    }
    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 13
    }
    
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .Short
    }
    
    func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
        return { UIBezierPath(rect: CGRectMake(0, 0, $0.width, $0.height)) }
    }
    
    func shouldShowCustomSingleSelection() -> Bool {
        return false
    }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.Circle)
        circleView.fillColor = .colorFromCode(0xCCCCCC)
        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
    
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        let π = M_PI
        
        let ringSpacing: CGFloat = 3.2
        let ringInsetWidth: CGFloat = 4.0
        let ringVerticalOffset: CGFloat = 0.0
        var ringLayer: CAShapeLayer!
        let ringLineWidth: CGFloat = 3.5
        let ringLineColour: UIColor = .blueColor()
        
        let newView = UIView(frame: dayView.bounds)
        
        let diameter: CGFloat = (newView.bounds.width) - ringSpacing
        let radius: CGFloat = diameter / 2.0
        
        let rect = CGRectMake(newView.frame.midX-radius, newView.frame.midY-radius-ringVerticalOffset, diameter, diameter)
        
        ringLayer = CAShapeLayer()
        newView.layer.addSublayer(ringLayer)
        
        ringLayer.fillColor = nil
        ringLayer.lineWidth = ringLineWidth
        ringLayer.strokeColor = ringLineColour.CGColor
        
        let ringLineWidthInset: CGFloat = CGFloat(ringLineWidth/2.0) + ringInsetWidth
        let ringRect: CGRect = CGRectInset(rect, ringLineWidthInset, ringLineWidthInset)
        let centrePoint: CGPoint = CGPointMake(ringRect.midX, ringRect.midY)
        let startAngle: CGFloat = CGFloat(-π/2.0)
        let endAngle: CGFloat = CGFloat(π * 2.0) + startAngle
        let ringPath: UIBezierPath = UIBezierPath(arcCenter: centrePoint, radius: ringRect.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        ringLayer.path = ringPath.CGPath
        ringLayer.frame = newView.layer.bounds
        
        return newView
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        guard dayView.date != nil else {
            return false
        }
        let loopdate=dayView.date
        
        if circleMark.contains(getSelectedDate(loopdate.year, month: loopdate.month, day: loopdate.day)){
            return true
        }

        return false
    }
    
    
}


// CVCalendarViewAppearanceDelegate

extension NotificationViewController: CVCalendarViewAppearanceDelegate {
    
    
    func dayLabelWeekdayTextSize() -> CGFloat {
        return 0
    }
    
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 0.0
    }
    func spaceBetweenWeekViews() -> CGFloat {
        return -1
    }
}

// Convenience API Demo

extension NotificationViewController {
    func toggleMonthViewWithMonthOffset(offset: Int) {
       
        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(NSDate()) // from today
        
        components.month += offset
        
        let resultDate = calendar.dateFromComponents(components)!
        
        self.calendarView.toggleViewWithDate(resultDate)
    }
    
    func didShowNextMonthView(date: NSDate)
    {
        //        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(date) // from today
        
        print("Showing Month: \(components.month)")
    }
    
    
    func didShowPreviousMonthView(date: NSDate)
    {
        //        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(date) // from today
        
        print("Showing Month: \(components.month)")
    }
    
}

//Action
extension NotificationViewController{
    
    @IBAction func addAct(sender: AnyObject) {
        
        setTabBarVisible(!tabBarIsVisible(), animated: true)
        
    }
    
//    @IBAction func addCircleAndDot(sender: AnyObject) {
//        calendarView.contentController.refreshPresentedMonth()
//        
//    }
//    
//    @IBAction func removeCircleAndDot(sender: AnyObject) {
//        if let dayView = selectedDay {
//            calendarView.contentController.removeCircleLabel(dayView)
//            calendarView.contentController.removeDotViews(dayView)
//        }
//    }
    
}





