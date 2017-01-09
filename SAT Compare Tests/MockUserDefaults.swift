//
//  MockUserDefaults.swift
//  SAT Compare
//
//  Created by Alexander Zou on 1/9/17.
//  Copyright © 2017 Alexander Zou. All rights reserved.
//

import Foundation
@testable import SAT_Compare

// when creating a mock, this conforms to the UserDefaults, which we set as our "protocol"
// i don't think it's very useful to create a real protocol that would just copy the functionality of UserDefaults, when you can just make it conform to the real thing
class MockUserDefaults: UserDefaults {
    
    override func object(forKey defaultName: String) -> Any? {
        if defaultName == "test" {
            return true
        } else {
            return false
        }
    }
}
