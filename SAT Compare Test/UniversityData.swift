//
//  SATSearch.swift
//  SAT Compare
//
//  Created by Alexander Zou on 8/20/16.
//  Copyright © 2016 Alexander Zou. All rights reserved.
//

import UIKit

class UniversityData: NSObject {
    var UniversityName:String = ""
    var 中文名字 = ""
    var BottomReadingPercentile = 0
    var BottomMathPercentile = 0
    var TopReadingPercentile = 0
    var TopMathPercentile = 0
    
    // get these numbers for later equations in the result view
    
    // average
    var MedianPercentile:Int {
        get {
            return (TopMathPercentile + TopReadingPercentile + BottomMathPercentile + BottomReadingPercentile)/2
        }
    }
    
    var TwentyFivePercentile:Int {
        return BottomReadingPercentile + BottomMathPercentile
    }
    
    var SeventyFivePercentile:Int {
        return TopReadingPercentile + TopMathPercentile
    }
    
    // 25th percentile minus difference between 25th percentile and median
    var ZeroPercentile:Int {
        get {
            return 2*(BottomReadingPercentile + BottomMathPercentile) - (TopMathPercentile + TopReadingPercentile + BottomMathPercentile + BottomReadingPercentile)/2
        }
    }
    
    // 75th percentile plus difference between 75th percentile and median
    var HundredPercentile:Int {
        get {
            return 2*(TopReadingPercentile + TopMathPercentile) - (TopMathPercentile + TopReadingPercentile + BottomMathPercentile + BottomReadingPercentile)/2
        }
    }

}
