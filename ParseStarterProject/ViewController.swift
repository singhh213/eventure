/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController, UITableViewDelegate {
    
    var signupActive = true

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    @available(iOS 8.0, *)
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            //self.dismissViewControllerAnimated(true, completion: nil)
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func signup(sender: AnyObject) {
        
        if username.text == "" || password.text == "" {
            if #available(iOS 8.0, *) {
                displayAlert("Error in form", message: "Please enter a username and password")
            } else {
                // Fallback on earlier versions
            }
        } else {
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            
            var errorMessage = "Please try agin later"
            
            if signupActive == true {
            
                let user = PFUser()
                user.username = username.text
                user.password = password.text
                
                
                user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if error == nil {
                        //signup successful
                        
                        self.performSegueWithIdentifier("login", sender: self)
                        
                    } else {
                        if let errorString = error!.userInfo["error"] as? String {
                            errorMessage = errorString
                        }
                        if #available(iOS 8.0, *) {
                            self.displayAlert("Failed signup", message: errorMessage)
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                })
                
            } else {
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()

                    if user != nil {
                        //logged in
                        self.performSegueWithIdentifier("login", sender: self)
                        
                    } else {
                        if let errorString = error!.userInfo["error"] as? String {
                            errorMessage = errorString
                        }
                        if #available(iOS 8.0, *) {
                            self.displayAlert("Failed Login", message: errorMessage)
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                })
            }
        }
    }
    
    @IBAction func login(sender: AnyObject) {
        
        if signupActive == true {
            signupButton.setTitle("Login", forState: UIControlState.Normal)
            loginButton.setTitle("Sign Up", forState: UIControlState.Normal)
            signupActive = false
        } else {
            signupButton.setTitle("Sign Up", forState: UIControlState.Normal)
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            signupActive = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "uwfountain.jpg")!).colorWithAlphaComponent(0.8)
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser()?.objectId != nil {
            self.performSegueWithIdentifier("login", sender: self)
        }
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
