//
//  MainViewController.swift
//  SAT Compare Test
//
//  Created by Alexander Zou on 8/30/16.
//  Copyright © 2016 Alexander Zou. All rights reserved.
//

import UIKit

var studentSAT:String?
var selectedUniversity:UniversityData?

class MainViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var universitySearchBackground: UIView!
    @IBOutlet weak var SATBackground: UIView!
    @IBOutlet weak var universitySearchTextField: UITextField!
    @IBOutlet weak var studentSATTextField: UITextField!
    @IBOutlet weak var studentSATSubmitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // make the corners rounded
        self.studentSATSubmitButton.layer.cornerRadius = 6
        self.cancelButton.layer.cornerRadius = 6
        self.universitySearchBackground.layer.cornerRadius = 6
        self.SATBackground.layer.cornerRadius = 6
        self.infoButton.layer.cornerRadius = 10
        
        setStudentSATTextField()
        
        // hide navigation bar
        self.navigationController!.setNavigationBarHidden(true, animated: true)
        
        // put the text for the university name (if it exists from the university search) and adjust the size
        if let existingSelectedUniversity = selectedUniversity {
            universitySearchTextField.text = existingSelectedUniversity.UniversityName
        }
        
        // put the text for the university SAT score (if it has already been input)
        if let existingStudentSAT = studentSAT {
            studentSATTextField.text = String(existingStudentSAT)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setStudentSATTextField() {
        studentSATTextField.delegate = self
        studentSATTextField.returnKeyType = UIReturnKeyType.done
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func universitySearchTextField(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "segueToSearchController", sender: self)
    }
    
    @IBAction func submitButtonPressed(_ sender: AnyObject) {
    ////
    ////
    ////
        
        // create an alert to tell students if data is missing
        let incorrectAlertController = UIAlertController(title: "Notice:", message: "Please select a university or input an SAT score between 400 and 1600.", preferredStyle: UIAlertControllerStyle.alert)
        incorrectAlertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        
        // we first have to make the student SAT the number input in the text field
        let studentSAT = studentSATTextField.text

        // check if university has been selected
        if selectedUniversity != nil {
        ////
        ////
            
            // check if SAT score has been input
            if let existingStudentSAT = studentSAT {
            ////
            
                let existingStudentSATInt:Int = Int(existingStudentSAT)!
                
                // check if SAT score between 400 and 1600
                if (existingStudentSATInt <= 1600) && (existingStudentSATInt >= 400) {
                    
                    // perform segue
                    self.performSegue(withIdentifier: "segueToResultViewController", sender: self)
                    
                } else {
                    // error alert
                    self.present(incorrectAlertController, animated: true, completion: nil)
                }
                // SAT score check
                
            ////
            } else {
                // error alert
                self.present(incorrectAlertController, animated: true, completion: nil)
                
            ////
            }// SAT score input check
        
        ////
        ////
        } else {
            // error alert
            self.present(incorrectAlertController, animated: true, completion: nil)
        
        ////
        ////
        } // university check
    
    ////
    ////
    ////
    } // end function
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        universitySearchTextField.text = ""
        selectedUniversity = nil
        studentSATTextField.text = ""
        studentSAT = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // when we segue, the student SAT is the number that's in the student SAT text field
        if segue.identifier == "segueToResultViewController" || segue.identifier == "segueToSearchController" || segue.identifier == "segueToInfoViewController" {
            studentSAT = studentSATTextField.text
        }
        
    }

    
}
