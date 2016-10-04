//
//  MainViewController.swift
//  SAT Compare Test
//
//  Created by Alexander Zou on 8/30/16.
//  Copyright © 2016 Alexander Zou. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {
    
    // MARK
    // MARK PROPERTIES
    @IBOutlet weak var universitySearchQuestion: UILabel!
    @IBOutlet weak var universitySearchBackground: UIView!
    @IBOutlet weak var universitySearchTextField: UITextField!

    @IBOutlet weak var SATBackground: UIView!
    @IBOutlet weak var studentSATQuestion: UILabel!
    @IBOutlet weak var studentSATTextField: UITextField!
    
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var 中文Button: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
        
    // MARK
    // MARK VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // make the corners rounded
        self.submitButton.layer.cornerRadius = 6
        self.cancelButton.layer.cornerRadius = 6
        self.universitySearchBackground.layer.cornerRadius = 6
        self.SATBackground.layer.cornerRadius = 6
        self.infoButton.layer.cornerRadius = 10
        
        setStudentSATTextField()
        setLanguage()
        
        // hide navigation bar
        self.navigationController!.setNavigationBarHidden(true, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK
    // MARK SET-UP
    
    func setLanguage() {
    ////
    ////
        switch 中文 {
        case false:
            // language buttons
            englishButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
            中文Button.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 12.0)
        ////
            // question text
            studentSATQuestion.text = "What is your SAT score?"
            universitySearchQuestion.text = "What university are you interested in?"
            // put the text for the university name (if it exists from the university search) and adjust the size
            if let existingSelectedUniversity = selectedUniversity {
                universitySearchTextField.text = existingSelectedUniversity.universityName
            }
            // put the text for the SAT score (if it has already been input)
            if let existingStudentSAT = studentSAT {
                studentSATTextField.text = String(existingStudentSAT)
            }
        ////
            // button title
            self.submitButton.setTitle("Submit", for: UIControlState.normal)
            self.submitButton.setTitle("Submit", for: UIControlState.highlighted)
            self.cancelButton.setTitle("Cancel", for: UIControlState.normal)
            self.cancelButton.setTitle("Cancel", for: UIControlState.highlighted)
        ////
            // tab bars
            // http://stackoverflow.com/questions/26683260/reload-tabbarcontroller-after-switching-language
            for i in 0...Int((self.tabBarController?.viewControllers?.count)! - 1) {
                var viewController = self.tabBarController?.viewControllers?[i]
                switch i {
                case 0:
                    viewController?.tabBarItem.title = "Main"
                default:
                    viewController?.tabBarItem.title = "Saved Universities"
                }
            }
        ////
    ////
    ////
        case true:
            englishButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 12.0)
            中文Button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        ////
            studentSATQuestion.text = "  你的SAT分数："
            universitySearchQuestion.text = "  你对哪些大学感兴趣？"
            if let existingSelectedUniversity = selectedUniversity {
                universitySearchTextField.text = existingSelectedUniversity.chineseName
            }
            if let existingStudentSAT = studentSAT {
                studentSATTextField.text = String(existingStudentSAT)
            }
        ////
            self.submitButton.setTitle("发送", for: UIControlState.normal)
            self.submitButton.setTitle("发送", for: UIControlState.highlighted)
            self.cancelButton.setTitle("取消", for: UIControlState.normal)
            self.cancelButton.setTitle("取消", for: UIControlState.highlighted)
        ////
            for i in 0...Int((self.tabBarController?.viewControllers?.count)! - 1) {
                var viewController = self.tabBarController?.viewControllers?[i]
                switch i {
                case 0:
                    viewController?.tabBarItem.title = "首页"
                default:
                    viewController?.tabBarItem.title = "选择大学"
                }
            }
        ////
        }
    ////
    ////
    }
    
    func setStudentSATTextField() {
        // make keyboard have done
        studentSATTextField.returnKeyType = UIReturnKeyType.done
        
        // hide keyboard if you click outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MainViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
        
        // hide keyboard if you swipe; 
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboardSwipe))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func hideKeyboardSwipe(swipe: Bool) {
        view.endEditing(swipe)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK
    // MARK ACTIONS AND SEGUES
    @IBAction func universitySearchTextField(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "segueToSearchController", sender: self)
    }
    
    @IBAction func submitButtonPressed(_ sender: AnyObject) {
    ////
    ////
    ////
    ////
        
        // create an alert to tell students if data is missing
        let incorrectAlertController = UIAlertController(title: alertControllerTitle(), message: alertControllerMessage(), preferredStyle: UIAlertControllerStyle.alert)
        incorrectAlertController.addAction(UIAlertAction(title: alertControllerAction(), style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
        })
        )
        // we first have to make the student SAT the number input in the text field
        let studentSAT = studentSATTextField.text

        // check if university has been selected
        if selectedUniversity != nil {
        ////
        ////
        ////
            // check if SAT score has been input
            if studentSAT != nil && studentSAT != "" {
            ////
            ////
                // check if it's an integer
                if let existingStudentSATInt:Int = Int(studentSAT!) {
                ////
                    // check if SAT score between 400 and 1600
                    
                    if (existingStudentSATInt <= 1600) && (existingStudentSATInt >= 400) {
                        // perform segue
                        self.performSegue(withIdentifier: "segueToResultViewController", sender: self)
                        
                    } else {
                        // error alert
                        self.present(incorrectAlertController, animated: true, completion: nil)
                    // SAT score betwen 400 and 1600 check
                    }
                    
                ////
                } else {
                    self.present(incorrectAlertController, animated: true, completion: nil)
                //// SAT score integer check
                }
            ////
            ////
            } else {
                self.present(incorrectAlertController, animated: true, completion: nil)
            ////
            //// SAT score input check
            }
        ////
        ////
        ////
        } else {
            self.present(incorrectAlertController, animated: true, completion: nil)
        ////
        ////
        ////  university check
        }
    ////
    ////
    ////
    ////
    } // end function
    
    // we need to change alert controller text based on language
    func alertControllerTitle() -> String {
        switch 中文 {
        case false:
            return "Notice:"
        case true:
            return "通知："
        }
    }
    
    func alertControllerMessage() -> String {
        switch 中文 {
        case false:
            return "Please select a university or input an SAT score between 400 and 1600."
        case true:
            return "TO BE DETERMINED"
        }
    }
    
    func alertControllerAction() -> String {
        switch 中文 {
        case false:
            return "Dismiss"
        case true:
            return "确定"
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        universitySearchTextField.text = ""
        selectedUniversity = nil
        studentSATTextField.text = ""
        studentSAT = nil
    }
    

    @IBAction func englishButtonPressed(_ sender: AnyObject) {
        中文 = false
        setLanguage()
        
        // add fade transition
        let languageTransition = CATransition()
        languageTransition.type = kCATransitionFade
        languageTransition.duration = 0.75
        languageTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        view.layer.add(languageTransition, forKey: nil)
        
    }
    
    @IBAction func 中文ButtonPressed(_ sender: AnyObject) {
        中文 = true
        setLanguage()
        
        let languageTransition = CATransition()
        languageTransition.type = kCATransitionFade
        languageTransition.duration = 0.75
        languageTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        view.layer.add(languageTransition, forKey: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // when we segue, the student SAT is the number that's in the student SAT text field
        if segue.identifier == "segueToResultViewController" || segue.identifier == "segueToSearchController" || segue.identifier == "segueToInfoViewController" {
            studentSAT = studentSATTextField.text
        }
    }

    
}
