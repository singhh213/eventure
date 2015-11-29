//
//  EventSelectedDetails.swift
//  ParseStarterProject-Swift
//
//  Created by Harpreet Singh on 9/15/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class EventSelectedDetails: UIViewController {
    
    var passedEvent:PFObject!
    var userID = PFUser.currentUser()!.objectId!
    var eventID: String?
    var attendees = [PFObject]()
    var count: Int!

    @IBOutlet var eventName: UILabel!
    @IBOutlet var eventHost: UILabel!
    @IBOutlet var eventDateTime: UILabel!
    @IBOutlet var eventLocation: UILabel!
    @IBOutlet var eventDetails: UILabel!
    @IBOutlet var eventAttendCount: UILabel!
    @IBOutlet var goingButton: UISegmentedControl!
    
    @IBOutlet var cancelButton: UIButton!
    
    @IBAction func goingToEvent(sender: AnyObject) {
        
        if(goingButton.selectedSegmentIndex == 0) {
            let attend = PFObject(className: "Attendees")
            
            attend["userID"] = userID
            attend["eventID"] = eventID!
            attend["eventName"] = passedEvent["name"]
            attend["eventDate"] = passedEvent["date"]
            attend.saveInBackground()
            
            passedEvent.incrementKey("attendCount")
            passedEvent.saveInBackground()
            
            count = Int(passedEvent["attendCount"] as! NSNumber)
            eventAttendCount.text = "\(count)"
            
        } else {
            
            passedEvent.incrementKey("attendCount", byAmount: -1)
            passedEvent.saveInBackground()
            
            count = Int(passedEvent["attendCount"] as! NSNumber)
            eventAttendCount.text = "\(count)"
            
            
            let query = PFQuery(className: "Attendees")
            query.whereKey("userID", equalTo: userID)
            query.whereKey("eventID", equalTo: eventID!)
            query.findObjectsInBackgroundWithBlock {
                
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if (error == nil) {
                    print("Successfully retrieved \(objects!.count) events.")
                    //if let objects = objects as? [PFObject] {
                        for object in objects! {
                            object.deleteInBackground()
                        }
                    //}
                    
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
            
        }
    }
    
    @available(iOS 8.0, *)
    @IBAction func cancelEvent(sender: AnyObject) {
        
        let confirmCancel = UIAlertController(title: "Cancel Event", message: "Are you sure you want to cancel and remove this event?", preferredStyle: UIAlertControllerStyle.Alert)
        
        confirmCancel.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) -> Void in
            print("cancel")
            self.passedEvent.deleteInBackground()
            
            let cancelSuccess = UIAlertController(title: "Event Cancelled", message: "The event has been canceled and deleted.", preferredStyle: UIAlertControllerStyle.Alert)
            
            cancelSuccess.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
                
            })))
            
            self.presentViewController(cancelSuccess, animated: true, completion: nil)
            
        }))
        
        confirmCancel.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction!) -> Void in
            print("don't cancel")
            
        }))
        
        presentViewController(confirmCancel, animated: true, completion: nil)
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        eventName.text = (passedEvent["name"] as! String)
        eventHost.text = "Host: " + (passedEvent["host"] as! String)
        eventDateTime.text = "When: " + (passedEvent["date"] as! String)
        eventLocation.text = "Location: " + (passedEvent["location"] as! String)
        eventDetails.text = "Details: " + (passedEvent["details"] as! String)
        count = Int(passedEvent["attendCount"] as! NSNumber)
        eventAttendCount.text = "\(count)"
        eventID = passedEvent.objectId!
        
        let attendCount = PFQuery(className:"Events")
        attendCount.whereKey("eventID", equalTo: passedEvent.objectId!)
        attendCount.countObjectsInBackgroundWithBlock { (count: Int32, error: NSError?) -> Void in

            if error == nil {
                print("\(count) people are attending")
            }
        }
        
        if ((passedEvent["userID"] as! String) != userID) {
            cancelButton.hidden = true
            
            
            let query = PFQuery(className: "Attendees")
            query.whereKey("userID", equalTo: userID)
            query.whereKey("eventID", equalTo: eventID!)
            
            query.findObjectsInBackgroundWithBlock {
                
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if (error == nil) {
                    print("Successfully retrieved \(objects!.count) events.")
                    if(objects!.count > 0) {
                        self.goingButton.selectedSegmentIndex = 0
                    }
                    
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
            
        } else {
            goingButton.hidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
