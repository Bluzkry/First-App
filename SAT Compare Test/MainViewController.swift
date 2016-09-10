//
//  MainViewController.swift
//  SAT Compare Test
//
//  Created by Alexander Zou on 8/30/16.
//  Copyright © 2016 Alexander Zou. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var universitySearchTextField: UITextField!
    @IBOutlet weak var studentSATTextField: UITextField!
    @IBOutlet weak var studentSATSubmitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // this is needed to transfer the university data to the next view
    var mainViewControllerSelectedUniversity:UniversityData?
    var mainViewControllerStudentSAT:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // make the button corners rounded
        self.studentSATSubmitButton.layer.cornerRadius = 4
        self.cancelButton.layer.cornerRadius = 4
        
        // hide navigation bar
        self.navigationController!.setNavigationBarHidden(true, animated: true)
        
        // put the text for the university name (if it exists from the university search) and adjust the size
        if let existingMainViewControllerSelectedUniversity = mainViewControllerSelectedUniversity {
            universitySearchTextField.text = existingMainViewControllerSelectedUniversity.UniversityName
        }
        
        // put the text for the university SAT score (if it has already been input)
        if let existingMainViewControllerStudentSAT = mainViewControllerStudentSAT {
            studentSATTextField.text = existingMainViewControllerStudentSAT
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segueToResultView") {
            let resultVC:UINavigationController = segue.destinationViewController as! UINavigationController;
            resultVC.studentSAT = studentSATTextField.text
        }
    }*/
    
    @IBAction func universitySearchTextField(sender: AnyObject) {
        self.performSegueWithIdentifier("segueToSearchController", sender: self)
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
    ////
    ////
    ////
        
        // create an alert to tell students if data is missing
        let incorrectAlertController = UIAlertController(title: "Notice:", message: "Please select a university or input an SAT score between 400 and 1600.", preferredStyle: UIAlertControllerStyle.Alert)
        incorrectAlertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        
        // we first have to make the student SAT the number input in the text field
        mainViewControllerStudentSAT = studentSATTextField.text

        // check if university has been selected
        if mainViewControllerSelectedUniversity != nil {
        ////
        ////
            
            // check if SAT score has been input
            if let existingMainViewControllerStudentSAT = mainViewControllerStudentSAT {
            ////
            
                let existingMainViewControllerStudentSATInt:Int? = Int(existingMainViewControllerStudentSAT)
                
                // check if SAT score between 400 and 1600
                if (existingMainViewControllerStudentSATInt <= 1600) && (existingMainViewControllerStudentSATInt >= 400) {
                    
                    // perform segue
                    self.performSegueWithIdentifier("segueToResultViewController", sender: self)
                    
                } else {
                    // error alert
                    self.presentViewController(incorrectAlertController, animated: true, completion: nil)
                }
                // SAT score check
                
            ////
            } else {
                // error alert
                self.presentViewController(incorrectAlertController, animated: true, completion: nil)
                
            ////
            }// SAT score input check
        
        ////
        ////
        } else {
            // error alert
            self.presentViewController(incorrectAlertController, animated: true, completion: nil)
        
        ////
        ////
        } // university check
    
    ////
    ////
    ////
    } // end function
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        universitySearchTextField.text = ""
        studentSATTextField.text = ""
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueToResultViewController" {
            
            // get the new view controller using segue.destinationViewController.
            let destinationResultViewController = segue.destinationViewController as! UINavigationController
            let targetResultViewController = destinationResultViewController.topViewController as! ResultViewController
            
            // pass the selected studentSAT and university objects to the new view controller.
            let existingMainViewControllerStudentSATInt:Int? = Int(mainViewControllerStudentSAT!)
            targetResultViewController.studentSAT = existingMainViewControllerStudentSATInt
            targetResultViewController.selectedUniversity = mainViewControllerSelectedUniversity
        }
        
        if segue.identifier == "segueToSearchController" {
            
            // get the new view controller using segue.destinationViewController.
            let destinationSearchController = segue.destinationViewController as! UINavigationController
            let targetSearchController = destinationSearchController.topViewController as! UniversitySearchController
            
            // pass the selected studentSAT objects to the new view controller (if it exists)
            targetSearchController.searchControllerStudentSAT = studentSATTextField.text
        }
        
    }
    
}
