//
//  SATSearchModel.swift
//  SAT Compare
//
//  Created by Alexander Zou on 8/20/16.
//  Copyright © 2016 Alexander Zou. All rights reserved.
//

import UIKit

class UniversityModel: NSObject {
    
    func getData () -> [UniversityData] {
    ////
    ////
    
        // array of UniversityData objects
        var UniversityDataObjects:[UniversityData] = [UniversityData]()
        
        // get JSON arry of dictionaries
        let jsonObjects:[NSDictionary] = self.getLocalJsonFile()
        
        // loop through each dictionary and assign values to our UniversityData objects
//        var index: Int
//        for i in index = 0; index < jsonObjects.count; index += 1
        for i in 0...(jsonObjects.count-1) {
        ////
            
            // current JSON dictionary
            let jsonDictionary:NSDictionary = jsonObjects[i]
            
            // create an UniversityData object
            let oneUniversity:UniversityData = UniversityData()
            
            // assign the value of each key value pair to the UniversityData object
            oneUniversity.UniversityName = jsonDictionary["name"] as! String
            oneUniversity.中文名字 = jsonDictionary["中文名字"] as! String
            oneUniversity.BottomReadingPercentile = jsonDictionary["25PercentReading"] as! Int
            oneUniversity.BottomMathPercentile = jsonDictionary["25PercentMath"] as! Int
            oneUniversity.TopReadingPercentile = jsonDictionary["75PercentReading"] as! Int
            oneUniversity.TopMathPercentile = jsonDictionary["75PercentMath"] as! Int
            
            // add the university to the university array
            UniversityDataObjects.append(oneUniversity)
            
        ////
        }
        
        // return list of university data objects
        return UniversityDataObjects
        
    ////
    ////
    }
    
    func getLocalJsonFile() -> [NSDictionary] {
    ////
    ////
        
        // get an NSURL object pointing to the json file in our app bundle
        let appBundlePath:String? = Bundle.main.path(forResource: "University Dataset", ofType: "json")
        if let actualBundlePath = appBundlePath {
        ////
            
            let urlPath:URL = URL(fileURLWithPath: actualBundlePath)
            let jsonData:Data? = try? Data(contentsOf: urlPath)
            if let actualJsonData = jsonData {
                // NSData exists, use the NSJSONSerialization classes to parse the data and create the dictionaries
                do {
                    let arrayOfDictionaries:[NSDictionary] = try JSONSerialization.jsonObject(with: actualJsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [NSDictionary]
                    return arrayOfDictionaries
                } catch {
                // there was an error parsing the json file
                }
            } else {
                // NSData doesn't exist
            }
        } else {
        // path to the json file in the app bundle doesn't exist
    
        ////
        } // return an empty array
        return [NSDictionary]()
        
    ////
    ////
    }
    
    /*func eraseState() {
        
        let userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setInteger(0, forKey: "numberCorrect")
        userDefaults.setInteger(0, forKey: "questionIndex")
        userDefaults.setBool(false, forKey: "resultViewAlpha")
        userDefaults.setObject("", forKey: "resultViewTitle")
        
        userDefaults.synchronize()
    }*/
    
    /*func saveState() {
        
        let userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        // save the current score, current question, and whether or not the result view is visible
        userDefaults.setInteger(self.numberCorrect, forKey: "numberCorrect")
        
        // finding current index
        let indexOfCurrentQuestion:Int? = self.questions.indexOf(self.currentQuestion!)
        if let actualIndex = indexOfCurrentQuestion {
            userDefaults.setInteger(actualIndex, forKey: "questionIndex")
        }
        
        // set true if result view is visible, else set false
        userDefaults.setBool(self.resultView.alpha == 1, forKey: "resultViewAlpha")
        
        // save the title of the result view
        userDefaults.setObject(self.resultTitleLabel.text, forKey: "resultViewTitle")
        
        // save the changes
        userDefaults.synchronize()
        
    }*/
    
    /*func loadState() {
        
        let userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        // load the saved question into the current question
        let currentQuestionIndex = userDefaults.integerForKey("questionIndex")
        
        // check that the saved index is not beyond the number of questions that we have
        if currentQuestionIndex < self.questions.count {
            self.currentQuestion = self.questions[currentQuestionIndex]
        }
        
        // load the score
        let score:Int = userDefaults.integerForKey("numberCorrect")
        self.numberCorrect = score
        
        // load the result view visibility
        let isResultViewVisible:Bool = userDefaults.boolForKey("resultViewAlpha")
        if isResultViewVisible == true {
            
            // we should display the result view
            self.feedbackLabel.text = self.currentQuestion?.feedback
            
            // retrieve the title text
            let title:String? = userDefaults.objectForKey("resultViewTitle") as! String?
            
            if let actualTitle = title {
                self.resultTitleLabel.text = actualTitle
                
                if actualTitle == "Correct" {
                    // change background color of result view and button
                    self.resultView.backgroundColor = UIColor(red: 43/255, green: 85/255, blue: 51/255, alpha: 0.8)
                    self.nextButton.backgroundColor = UIColor(red: 3/255, green: 85/255, blue: 27/255, alpha: 1)
                } else if actualTitle == "Incorrect" {
                    // change background color of result view and button
                    self.resultView.backgroundColor = UIColor(red: 85/255, green: 19/255, blue: 12/255, alpha: 0.8)
                    self.nextButton.backgroundColor = UIColor(red: 58/255, green: 0/255, blue: 16/255, alpha: 1)
                }
            }
            
            self.dimView.alpha = 1
            self.resultView.alpha = 1
        }
        
    }*/

    
}
