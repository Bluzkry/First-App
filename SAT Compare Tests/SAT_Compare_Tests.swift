//
//  SAT_Compare_TestTests.swift
//  SAT Compare TestTests
//
//  Created by Alexander Zou on 8/21/16.
//  Copyright © 2016 Alexander Zou. All rights reserved.
//

import XCTest
@testable import SAT_Compare

class SAT_Compare_Tests: XCTestCase {
    
    var tabBarVC: UITabBarController!
    var navToMainVC: NavigationToMainViewController!
    var navToDataVC: NavigationToDataTableViewController!
    var mainVC: MainViewController!
    var testType: String!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // given
        setUpVCs()
    }
    
    func setUpVCs() {
        // using VCs is a bit more complicated than just initializing
        
        // first you have to initialize a storyboard as so
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        // then you initialize every single view controller that you're going to use, with their identifiers, through the storyboard
        tabBarVC = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as! UITabBarController
        navToMainVC = storyboard.instantiateViewController(withIdentifier: "NavigationToMainViewController") as! NavigationToMainViewController
        navToDataVC = storyboard.instantiateViewController(withIdentifier: "NavigationToDataTableViewController") as! NavigationToDataTableViewController
        mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
        // programmatically set the navigation view controllers as the tab bars
        tabBarVC.setViewControllers([navToMainVC, navToDataVC], animated: false)
        // programatically set the desired view controller as the top of the stack of the navigation controller
        mainVC = navToMainVC.topViewController as! MainViewController
        // create a window and make the root view controller the desired view controller
        UIApplication.shared.keyWindow!.rootViewController = mainVC
        
        // the view must be instantiated in order to call all the methods in its class
        let _ = mainVC.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        selectedUniversity = nil
        studentSAT = nil
    }
    
    func testSwitchACT() {
        // ACT
        // when
        mainVC.ACTButton.sendActions(for: .touchUpInside)
        testType = mainVC.appUserDefaults.object(forKey: "test") as! String
        // then
        XCTAssertEqual(testType, "ACT", "it sees whether we've switched to the ACT")

        // SAT
        // when
        mainVC.SATButton.sendActions(for: .touchUpInside)
        testType = mainVC.appUserDefaults.object(forKey: "test") as! String
        // then
        XCTAssertEqual(testType, "SAT", "it sees whether we've switched to the SAT")
    }

    func testButtonAttributesACT() {
        let bigUIFont = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        let smallUIFont = UIFont(name: "Helvetica Neue", size: 18.0)
        
        // ACT
        mainVC.ACTButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(mainVC.SATButton.titleLabel?.font, smallUIFont)
        XCTAssertEqual(mainVC.ACTButton.titleLabel?.font, bigUIFont)
        
        // SAT
        mainVC.SATButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(mainVC.SATButton.titleLabel?.font, bigUIFont)
        XCTAssertEqual(mainVC.ACTButton.titleLabel?.font, smallUIFont)
    }
    
    func testLabelsACT() {
        // ACT
        mainVC.ACTButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(mainVC.studentSATQuestion.text, "What is your ACT score?")
        XCTAssertEqual(mainVC.appTitle.text, "ACT Compare")
        
        // SAT
        mainVC.SATButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(mainVC.studentSATQuestion.text, "What is your SAT score?")
        XCTAssertEqual(mainVC.appTitle.text, "SAT Compare")
    }
    
    
//    func testAlertMessageACT() {
//        // given
//        studentSAT = "-1"
//        selectedUniversity = nil
//        
//        // when
//        
//        
//        // then
////        XCTAssertEqual(<#T##expression1: [T : U]##[T : U]#>, <#T##expression2: [T : U]##[T : U]#>)
//    }
    
    //    func testPerformanceExample() {
    //        // This is an example of a performance test case.
    //        self.measure {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
}
