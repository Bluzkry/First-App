//
//  UniversitySearchController.swift
//  SAT Compare Test
//
//  Created by Alexander Zou on 8/21/16.
//  Copyright © 2016 Alexander Zou. All rights reserved.
//

import UIKit

class UniversitySearchController: UITableViewController, UISearchResultsUpdating {
    
    // MARK
    // MARK VARIABLES

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var model:UniversityModel = UniversityModel()
    var totalData:[UniversityData] = [UniversityData]()
    
    // we need this for any SAT score data passed by the main view controller
    var searchControllerStudentSAT: String?
    
    // this indicates the search result
    var filteredUniversities = [UniversityData]()

    // we need to set up these foundations for the search
    var searchcontroller: UISearchController!
    var searchResultsController = UITableViewController()
    
    // MARK
    // MARK VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get data from the data model
        self.totalData = self.model.getData()
        
        // set up the search controller
        self.searchcontroller = UISearchController(searchResultsController: self.searchResultsController)
        self.tableView.tableHeaderView = self.searchcontroller.searchBar
        self.searchcontroller.searchResultsUpdater = self
        self.searchResultsController.tableView.dataSource = self
        self.searchResultsController.tableView.delegate = self
        self.searchcontroller.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        // change cancel button depending on language
        switch 中文 {
        case false:
            cancelButton.title = "Cancel"
        case true:
            cancelButton.title = "取消"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    // MARK TABLE SET-UP
    // number of sections is 1
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // this gives the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchcontroller.isActive && searchcontroller.searchBar.text != "" {
            // if we search, the rows is the number of rows in our filtered universities
            return self.filteredUniversities.count
        } else {
            // otherwise it's the total number of universities
            return self.totalData.count
        }
    }
    
    // what's in the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let data:UniversityData
        
        if searchcontroller.isActive && searchcontroller.searchBar.text != "" {
            // if we search, what's in the table is the filtered universities
            data = filteredUniversities[(indexPath as NSIndexPath).row]
        } else {
            // otherwise it's all the universities
            data = totalData[(indexPath as NSIndexPath).row]
        }
        
        // change what's in the cell by language
        switch 中文 {
        case false:
            cell.textLabel!.text = data.universityName
        case true:
            cell.textLabel!.text = data.chineseName
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // user selected a row, the selectedUniversity variable has to be changed to this
        if searchcontroller.isActive && searchcontroller.searchBar.text != "" {
            selectedUniversity = filteredUniversities[(indexPath as NSIndexPath).row]
        } else {
            selectedUniversity = totalData[(indexPath as NSIndexPath).row]
        }
        
        // trigger the segue to go to the next view
        self.performSegue(withIdentifier: "segueToMainViewController", sender: self)
    }
    
    // MARK
    // MARK SEARCH
    func updateSearchResults(for searchController: UISearchController) {
    ////
        // filter through the universities
        switch 中文 {
        case false:
            self.filteredUniversities = self.totalData.filter({ (data:UniversityData) -> Bool in
                return data.universityName.lowercased().contains(self.searchcontroller.searchBar.text!.lowercased())
            })
        case true:
            self.filteredUniversities = self.totalData.filter({ (data:UniversityData) -> Bool in
                return data.chineseName.contains(self.searchcontroller.searchBar.text!)
            })
        }
        
        // update the results table view
        self.searchResultsController.tableView.reloadData()
    ////
    }
    
    // MARK
    // PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCancel" {
            selectedUniversity = nil
        }
    }

}
