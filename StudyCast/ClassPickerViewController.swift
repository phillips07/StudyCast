//
//  ClassPickerViewController.swift
//  StudyCast
//
//  Created by Austin Phillips on 2016-11-04.
//  Copyright © 2016 Austin Phillips. All rights reserved.
//

import Foundation
import UIKit

class ClassPickerViewController: UITableViewController{
    
    /* ******* TABLE VIEW DATA *********
        - Need to call SFU API for this data in production(possibly relative to what users select in the search/drop down bar?)
        - Will need to Parse this data as it will come back in JSON
        - For now, dummy data as created below
     */
    
    let classDataSet = ["BUS 100", "BUS 320", "BUS 160", "ENSC 100W", "ENSC 105", "ENSC 252", "ENSC 254", "ENSC 380", "ENSC 251", "ENSC 351", "CRIM 101", "CRIM 270", "CRIM 300", "CRIM 320", "CRIM 400"]
    
    
    //normal stuff required for views if we want things to happen onLoad and such
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //stuff required for TableViews
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //place holder for now
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classDataSet.count //place holder for now
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "classCell")!
        
        cell.textLabel?.text = classDataSet[indexPath.row]
        
        return cell
    }
    
    
}

