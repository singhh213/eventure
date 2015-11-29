//
//  TableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Harpreet Singh on 9/13/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class TableViewController: UITableViewController {
    
    
    @IBOutlet var openMenu: UIBarButtonItem!
    var eventsReturned = [AnyObject]();
    var eventToPass:PFObject!
    
    var refresher: UIRefreshControl!
    
    func refresh() {
        
        
        let query = PFQuery(className: "Events")
        

        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if (error == nil) {
                //println("Successfully retrieved \(objects!.count) event.")
                //if let objects = objects as? [PFObject] {
                    
                    self.eventsReturned.removeAll(keepCapacity: true)
                    for object in objects! {
                        self.eventsReturned.append(object);
                        
                    }
                    //self.eventsReturned = objects
                //}
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            
            
            self.tableView.reloadData()
            self.refresher.endRefreshing()
            
            
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        openMenu.target = self.revealViewController()
        
        openMenu.action = Selector("revealToggle:")
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(refresher)
        
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
        
        return eventsReturned.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell

        // Configure the cell..
        //println(eventsReturned[indexPath.row])
        
        cell.eventName.text = eventsReturned[indexPath.row]["name"] as? String
        
        cell.eventHost.text = eventsReturned[indexPath.row]["host"] as? String
        
        
        let time  = eventsReturned[indexPath.row]["date"] as! NSString

        
        cell.eventTime.text = time.substringFromIndex(time.length - 5)


        //cell.textLabel?.text = eventsReturned[indexPath.row]["name"] as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        eventToPass = eventsReturned[indexPath.row] as! PFObject
        
        performSegueWithIdentifier("eventSelected", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "eventSelected") {
            let viewController = segue.destinationViewController as! EventSelectedDetails
            viewController.passedEvent = eventToPass
            
        }
    }
}
