//
//  SATSearchModel.swift
//  SAT Compare
//
//  Created by Alexander Zou on 8/20/16.
//  Copyright © 2016 Alexander Zou. All rights reserved.
//

import UIKit
import CoreData

class UniversityModel: NSObject {
    
    func getData () -> [UniversityData] {
    ////
    ////
        
        // array of UniversityData objects
        var universityDataObjects:[UniversityData] = [UniversityData]()
        
        // get JSON arry of dictionaries
        let jsonObjects:[NSDictionary] = self.getLocalJsonFile()
        
        // to persist data, we need to save as core data
        // we get a reference to the app delegate and use that to retrieve the AppDelegate's NSManagedObjectContext, which is like a memory "scratchpad" we need for CoreData
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // create a new data entity
        let studentUniversityDataEntity = NSEntityDescription.entity(forEntityName: "UniversityData", in: managedContext)
        
        // loop through each dictionary and assign values to our UniversityData objects
        for i in 0...(jsonObjects.count-1) {
        ////
            
            // current JSON dictionary
            let jsonDictionary:NSDictionary = jsonObjects[i]
            
            // create a new managed object (oneUniversity) and insert into the managed object context; this also creates a new UniversityData object
            let oneUniversity = UniversityData(entity: studentUniversityDataEntity!, insertInto: managedContext)
            
            // assign the value of each key value pair to the UniversityData object
            oneUniversity.universityName = jsonDictionary["name"] as! String
            oneUniversity.chineseName = jsonDictionary["中文名字"] as! String
            oneUniversity.bottomReadingPercentile = jsonDictionary["25PercentReading"] as? NSNumber
            oneUniversity.bottomMathPercentile = jsonDictionary["25PercentMath"] as? NSNumber
            oneUniversity.topReadingPercentile = jsonDictionary["75PercentReading"] as? NSNumber
            oneUniversity.topMathPercentile = jsonDictionary["75PercentMath"] as? NSNumber
            // note that if there is no ACT data, oneUniversity.bottomACT = nil
            oneUniversity.bottomACT = jsonDictionary["25PercentACT"] as? NSNumber
            oneUniversity.topACT = jsonDictionary["75PercentACT"] as? NSNumber
            oneUniversity.studentData = false
            universityDataObjects.append(oneUniversity)
        ////
        }
        
        // return list of university data objects
        return universityDataObjects
        
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

}
