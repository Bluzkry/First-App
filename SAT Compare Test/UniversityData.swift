//
//  SATSearch.swift
//  SAT Compare
//
//  Created by Alexander Zou on 8/20/16.
//  Copyright © 2016 Alexander Zou. All rights reserved.
//

import UIKit
import CoreData
@objc(UniversityData)

class UniversityData: NSManagedObject {
    @NSManaged var universityName:String
    @NSManaged var chineseName:String
    @NSManaged var bottomReadingPercentile:NSNumber
    @NSManaged var bottomMathPercentile:NSNumber
    @NSManaged var topReadingPercentile:NSNumber
    @NSManaged var topMathPercentile:NSNumber
    @NSManaged var studentData:Bool
    @NSManaged var savedDate:NSDate
    
//    // get these numbers for later equations in the result view
//    
//    // average
//    var MedianPercentile:Int {
//        get {
//            return (topMathPercentile.intValue + topReadingPercentile.intValue + bottomMathPercentile.intValue + bottomReadingPercentile.intValue)/2
//        }
//    }
//    
//    var TwentyFivePercentile:Int {
//        return bottomReadingPercentile.intValue + bottomMathPercentile.intValue
//    }
//    
//    var SeventyFivePercentile:Int {
//        return topReadingPercentile.intValue + topMathPercentile.intValue
//    }
//    
//    // 25th percentile minus difference between 25th percentile and median
//    var ZeroPercentile:Int {
//        get {
//            return 2*(bottomReadingPercentile.intValue + bottomMathPercentile.intValue) - (topMathPercentile.intValue + topReadingPercentile.intValue + bottomMathPercentile.intValue + bottomReadingPercentile.intValue)/2
//        }
//    }
//    
//    // 75th percentile plus difference between 75th percentile and median
//    var HundredPercentile:Int {
//        get {
//            return 2*(topReadingPercentile.intValue + topMathPercentile.intValue) - (topMathPercentile.intValue + topReadingPercentile.intValue + bottomMathPercentile.intValue + bottomReadingPercentile.intValue)/2
//        }
//    }

}
