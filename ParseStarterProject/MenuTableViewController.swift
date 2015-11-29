//
//  MenuTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Harpreet Singh on 9/17/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class MenuTableViewController: UITableViewController {

    var menuOptions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        menuOptions = ["Today's Events", "Attending Events", "Post Event", "My Events", "Log Out"]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        
        return menuOptions.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(menuOptions[indexPath.row], forIndexPath: indexPath) 

        cell.textLabel?.text = menuOptions[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.row == menuOptions.count - 1) {
            PFUser.logOutInBackground()
            performSegueWithIdentifier("loggedOut", sender: self)
        }

    }
}
