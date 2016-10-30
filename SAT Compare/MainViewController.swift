//
//  MainViewController.swift
// SAT Compare
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
    
    // necessary to save 中文 variable
    let appUserDefaults = UserDefaults.standard
    var 中文:Bool?
    
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
        
        setLanguage()
        setStudentSATTextField()
        
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
        // set nsappUserDefaults
        中文 = appUserDefaults.object(forKey: "language") as! Bool?
        // when the app is first loaded, we set the language to english
        if 中文 == nil {
            中文 = false
            appUserDefaults.set(false, forKey: "language")
        }
        
        switch 中文! {
        case false:
            // language buttons
            englishButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
            中文Button.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 15.0)
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
            setStudentSATTextField()
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
                let viewController = self.tabBarController?.viewControllers?[i]
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
            englishButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 17.0)
            中文Button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 15.0)
        ////
            studentSATQuestion.text = "  你的SAT分数："
            universitySearchQuestion.text = "  你对哪些大学感兴趣？"
            if let existingSelectedUniversity = selectedUniversity {
                universitySearchTextField.text = existingSelectedUniversity.chineseName
            }
            if let existingStudentSAT = studentSAT {
                studentSATTextField.text = String(existingStudentSAT)
            }
            setStudentSATTextField()
        ////
            self.submitButton.setTitle("发送", for: UIControlState.normal)
            self.submitButton.setTitle("发送", for: UIControlState.highlighted)
            self.cancelButton.setTitle("取消", for: UIControlState.normal)
            self.cancelButton.setTitle("取消", for: UIControlState.highlighted)
        ////
            for i in 0...Int((self.tabBarController?.viewControllers?.count)! - 1) {
                let viewController = self.tabBarController?.viewControllers?[i]
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
    ////
        // number keyboard
        studentSATTextField.keyboardType = UIKeyboardType.numberPad

        // keyboard has done button
        // first add a toolbar
        let doneToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolBar.barStyle = UIBarStyle.default
        // add an array of items (a cancel button which calls upon a method, a flexible space which puts the cancel and done buttons in the right places, and a done button which calls upon a method)
        doneToolBar.items = [UIBarButtonItem(title: cancelBarLanguage(), style: UIBarButtonItemStyle.done, target: self, action: #selector(cancelBarAction)) , UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: doneBarLanguage(), style: UIBarButtonItemStyle.done, target: self, action: #selector(doneBarAction))]
        
        // make it the same size as the phone and add it to the keyboard
        doneToolBar.sizeToFit()
        self.studentSATTextField.inputAccessoryView = doneToolBar
    ////
        // hide keyboard if you click outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MainViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
    ////
        // hide keyboard if you swipe; 
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboardSwipe))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
    ////
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
    
    func cancelBarAction() {
        self.studentSATTextField.text = ""
        self.studentSATTextField.resignFirstResponder()
    }
    
    func cancelBarLanguage() -> String {
        switch 中文! {
        case false:
            return "Cancel"
        case true:
            return "取消"
        }
    }
    
    func doneBarAction() {
        self.studentSATTextField.resignFirstResponder()
    }
    
    func doneBarLanguage() -> String {
        switch 中文! {
        case false:
            return "Done"
        case true:
            return "完成"
        }
    }
    
    // MARK
    // MARK ACTIONS AND SEGUES
    @IBAction func universitySearchTextField(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "segueToSearchController", sender: self)
    }
    
    @IBAction func submitButtonPressed(_ sender: AnyObject) {
    ////
        // create an alert to tell students if data is missing
        let incorrectAlertController = UIAlertController(title: alertControllerTitle(), message: alertControllerMessage(), preferredStyle: UIAlertControllerStyle.alert)
        incorrectAlertController.addAction(UIAlertAction(title: alertControllerAction(), style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
        })
        )
        
        // we first have to make the student SAT the number input in the text field
        let studentSAT = studentSATTextField.text

        // check if university has been selected
        guard selectedUniversity != nil else {
            self.present(incorrectAlertController, animated: true, completion: nil)
            return
        }

        // check if SAT score has been input
        guard studentSAT != nil && studentSAT != "" else {
            self.present(incorrectAlertController, animated: true, completion: nil)
            return
        }
        
        // check if it's an integer
        guard let existingStudentSATInt:Int = Int(studentSAT!) else {
            self.present(incorrectAlertController, animated: true, completion: nil)
            return
        }
        
        // check if SAT score between 400 and 1600
        guard (existingStudentSATInt <= 1600) && (existingStudentSATInt >= 400) else {
            self.present(incorrectAlertController, animated: true, completion: nil)
            return
        }
        
        // perform segue
        self.performSegue(withIdentifier: "segueToResultViewController", sender: self)
    ////
    }
    
    // we need to change alert controller text based on language
    func alertControllerTitle() -> String {
        switch 中文! {
        case false:
            return "Notice:"
        case true:
            return "通知："
        }
    }
    
    func alertControllerMessage() -> String {
        switch 中文! {
        case false:
            return "Please select a university or input an SAT score between 400 and 1600."
        case true:
            return "请选择一个大学或输入SAT分数（400到1600之间）。"
        }
    }
    
    func alertControllerAction() -> String {
        switch 中文! {
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
        appUserDefaults.set(false, forKey: "language")
        setLanguage()
        
        // add fade transition
        let languageTransition = CATransition()
        languageTransition.type = kCATransitionFade
        languageTransition.duration = 0.75
        languageTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        view.layer.add(languageTransition, forKey: nil)
        
        // post notification to reload the table view so that the language changes
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    @IBAction func 中文ButtonPressed(_ sender: AnyObject) {
        appUserDefaults.set(true, forKey: "language")
        setLanguage()
        
        let languageTransition = CATransition()
        languageTransition.type = kCATransitionFade
        languageTransition.duration = 0.75
        languageTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        view.layer.add(languageTransition, forKey: nil)
        
        // post notification to reload the table view so that the language changes
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // when we segue, the student SAT is the number that's in the student SAT text field
        if segue.identifier == "segueToResultViewController" || segue.identifier == "segueToSearchController" || segue.identifier == "segueToInfoViewController" {
            studentSAT = studentSATTextField.text
        }
    }

    
}
