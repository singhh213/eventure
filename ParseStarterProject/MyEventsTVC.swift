//
//  MyEventsTVC.swift
//  ParseStarterProject-Swift
//
//  Created by Harpreet Singh on 9/17/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class MyEventsTVC: UITableViewController {

    @IBOutlet var openMenu: UIBarButtonItem!
    
    var myEvents = [AnyObject]();
    
    var eventToPass:PFObject!
    
    
    func refresh() {
        
        let userID = PFUser.currentUser()?.objectId
        
        let myEventsQuery = PFQuery(className: "Events").whereKey("userID", equalTo: userID!)
        
        myEventsQuery.findObjectsInBackgroundWithBlock {
            
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if (error == nil) {
                //println("Successfully retrieved \(objects!.count) events.")
                //if let objects = objects as? [PFObject] {
                    
                    self.myEvents.removeAll(keepCapacity: true)
                    
                    self.myEvents = objects!
                //}
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            
            
            self.tableView.reloadData()
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()

        openMenu.target = self.revealViewController()
        
        openMenu.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        refresh()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return myEvents.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell

        cell.myEventName.text = myEvents[indexPath.row]["name"] as? String
        
        let count = Int(myEvents[indexPath.row]["attendCount"] as! NSNumber)
        
        cell.myEventAttendCount.text = "\(count)"
        
        let date = myEvents[indexPath.row]["date"] as! NSString
        
        
        cell.myEventDate.text = date.substringToIndex(10)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        eventToPass = myEvents[indexPath.row] as! PFObject
        
        print(eventToPass)
        
        performSegueWithIdentifier("eventDetails", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "eventDetails") {
            let viewController = segue.destinationViewController as! EventSelectedDetails
            viewController.passedEvent = eventToPass
            
        }
    }



}
