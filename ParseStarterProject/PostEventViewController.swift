//
//  PostEventViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Harpreet Singh on 9/14/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class PostEventViewController: UIViewController {
    
    @available(iOS 8.0, *)
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }


    var activityIndicator = UIActivityIndicatorView()
    var strDate = ""
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var eventName: UITextField!
    @IBOutlet var eventHost: UITextField!
    @IBOutlet var eventLocation: UITextField!
    @IBOutlet var eventDetails: UITextField!
    
    @IBOutlet var openMenu: UIBarButtonItem!
    
    @IBAction func postEvent(sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let event = PFObject(className: "Events")
        
        let name = eventName.text
        let host = eventHost.text
        let location = eventLocation.text
        let details = eventDetails.text
        let count = 0
        
        if(strDate.isEmpty) {
            strDate = convertDate(NSDate())
        }

        
        event["name"] = name!
        event["host"] = host!
        event["location"] = location!
        event["details"] = details!
        event["date"] = strDate
        event["userID"] = PFUser.currentUser()!.objectId!
        event["attendCount"] = count
        
        event.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            if (success) {
                print("success")
                if #available(iOS 8.0, *) {
                    self.displayAlert("Event Posted!", message: "Your event has been posted successfully.")
                } else {
                    // Fallback on earlier versions
                }
                self.eventName.text = ""
                self.eventHost.text = ""
                self.eventLocation.text = ""
                self.eventDetails.text = ""
                                
            } else {
                print(error)
                if #available(iOS 8.0, *) {
                    self.displayAlert("Could not post event", message: "Please try again later.")
                } else {
                    // Fallback on earlier versions
                }

            }
        }
    }
    
    func convertDate(dateTime: NSDate) -> String {
        let dateFormatter = NSDateFormatter()

        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        strDate = dateFormatter.stringFromDate(dateTime)
        return strDate
    }
    
    @IBAction func datePickerAction(sender: AnyObject) {
        strDate = convertDate(datePicker.date)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        openMenu.target = self.revealViewController()
        
        openMenu.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())


        // Do any additional setup after loading the view.
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
