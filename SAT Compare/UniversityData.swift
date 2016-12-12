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
    @NSManaged var bottomReadingPercentile:NSNumber?
    @NSManaged var bottomMathPercentile:NSNumber?
    @NSManaged var topReadingPercentile:NSNumber?
    @NSManaged var topMathPercentile:NSNumber?
    @NSManaged var studentData:Bool
    @NSManaged var order: Int16
    @NSManaged var savedStudentSAT:String
    @NSManaged var savedStudentPercentile:String
    @NSManaged var bottomACT:NSNumber?
    @NSManaged var topACT:NSNumber?

}
