//
//  ClassSelectController.swift
//  StudyCastv2
//
//  Created by Dennis on 2016-11-04.
//  Copyright © 2016 Apollo. All rights reserved.
//

import UIKit
import Firebase

class ClassSelectController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var currentFaculty: String = "ensc"
    
    //the righteous weapons used used to exact justice upon multi-threading issues
    var facultiesDone: Bool = false
    var classesDone: Bool = false
    
    //data for tables
    var numCells = 0
    
    //Updated with user input, selecting classes
    //populates the bottom tableView. Contains all the classes that have been selected from the top table view.
    var pickedClassesDataSet: [String] = []
    
    
    //these arrays are updated by parsing JSON data from SFU API
    //"faculties' contains all of faculties with classes at SFU for a given semester
    var faculties: [Faculty]?
    //"facultyDataSet" populates the top tableView on the screen. It contains all the classes for a given faculty
    var facultyDataSet: [Class]?
    //hash table to store all the classes
    var hashTable: HashTable<String, [Class]>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        
     
        //called to fetch JSON data from SFU API
        fetchFaculties(semester: "2016/fall/")
        
        
        //vanquishing the slobbering beast of multi-threading issues
        while !(self.facultiesDone) {
            sleep(UInt32(0.1))
        }
        
        
        fetchClasses()
        //more vanquishing
        while !(self.classesDone) {
            sleep(UInt32(0.1))
        }
        
        //getting the correct value in currentFaculty
        setCurrentFaculty(row: 0)
        //called to populate the upper tableView
        loadClassesToTable(key: currentFaculty.lowercased())


        //creating subviews
        view.addSubview(facultyTableView)
        view.addSubview(userClassesTableView)
        view.addSubview(userClassLabel)
        view.addSubview(doneButton)
        view.addSubview(facultyPicker)
        view.addSubview(viewLabel)
        
        //give qualities to each subview
        setupUserClassesTableView()
        setupFacultyTableView()
        setupUserClassLabel()
        setupDoneButton()
        setupViewLabel()
        setupPickerView()
        
        
        self.facultyTableView.register(UserCell.self, forCellReuseIdentifier: "cell")
        self.userClassesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell2")
        
    }
    
    func setCurrentFaculty(row: Int) {
        self.currentFaculty = (self.faculties?[row].code)!
    }
    
    func loadClassesToTable(key: String) {
        let newSet = self.hashTable![key]
        self.facultyDataSet = newSet
        self.facultyTableView.reloadData()
    }
    
    func initClassesForUser () {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).child("courses").observe(.value, with: { (snapshot) in
            if let courses = snapshot.value as? [String] {
                self.pickedClassesDataSet = courses
                self.numCells = self.pickedClassesDataSet.count
                DispatchQueue.main.async {
                   self.userClassesTableView.reloadData() 
                }
                
            }
        })
    }
    
    
    //to be implimented in a loop to run for each faculty in faculties array
    func fetchClasses() {
        
        //prepares my hashTable for storing the data gathered from the API
        //its keys are faculty names, values are an array of classes within that faculty
        self.hashTable = HashTable<String, [Class]>(capacity: 333)
        
        //loop through every faculty, make API calls for each one by updating the URL to use the facutlty's respective name
        for fac in self.faculties! {
            
            //2 minutes for hacking #yoloswag #figureItOutInAnotherLife
            if (fac.name! == "expl") || (fac.name! == "fnlg") || (fac.name! == "lang") {
                continue
            }
            
            //set current URL
            let urlString = "http://www.sfu.ca/bin/wcm/course-outlines?2015/fall/\(fac.name!)"
            let url = URL(string: urlString)
            var loopDone = false
            
            //get JSON from API
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                //check if an error is returned form the server
                if error != nil {
                    print(error!)
                    return
                }
                
                //parse JSON
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    
                    //create an array to hold the classes to be added to the hashTable
                    var classArr = [Class]()
                    
                    //********** THIS LINE RANDOMLY CAUSES ERRORS ******************
                    //sometimes gets completey or nearly through jsonData, other times breaks almost immediately
                    for dict in jsonData as! [[String:AnyObject]]{
                        
                        //add each class inthe JSON data to the array
                        let new = Class()
                        new.number = dict["text"] as! String?
                        classArr.append(new)
                    }
                    //add the array to the hashTable
                    self.hashTable!["\(fac.name!)"] = classArr
                    
                } catch let error {
                    print(error)
                }
                //set to true when thread parsing the JSON data is done
                loopDone = true
            }.resume()
            
            //makes main thread wait until parsing is complete to go to the next itertion of the loop
            while !loopDone {
                sleep(UInt32(0.1))
            }
        }
        //Set to true when the hashTable is finished populating and other functions that rely on it can continue
        self.classesDone = true
    }
    
    func fetchFaculties(semester: String) {
        let url = URL(string: "http://www.sfu.ca/bin/wcm/course-outlines?\(semester)")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            //check if an error is returned form the server
            if error != nil {
                print(error!)
                return
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                self.faculties = [Faculty]()
                
                for dict in jsonData as! [[String:AnyObject]] {
                    
                    let faculty = Faculty()
                    faculty.code = dict["text"] as! String?
                    faculty.name = dict["value"] as! String?
                    self.faculties?.append(faculty)
                    
                }
                
                self.facultiesDone = true
                
            } catch let error {
                print(error)
            }
            
            
            }.resume()
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == facultyTableView {
            return facultyDataSet?.count ?? 0
        } else if tableView == userClassesTableView {
            return pickedClassesDataSet.count
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == facultyTableView {
            let cell:UITableViewCell = self.facultyTableView.dequeueReusableCell(withIdentifier: "cell")! as     UITableViewCell
            //facultyDataSet contains "Class" objects with "number" and "name" attributes, so setting the title of the cell to => "(facultyDataSet?[indexPath.row].number)!" is putting the course number from our JSON, into our cell
            cell.textLabel?.text = String(describing: (self.facultyDataSet?[indexPath.row].number)!)
            return cell
        } else if ((tableView == userClassesTableView) && (indexPath.row < numCells)) {
            let cell2:UITableViewCell = self.userClassesTableView.dequeueReusableCell(withIdentifier: "cell2")! as UITableViewCell
            cell2.textLabel?.text = String(self.pickedClassesDataSet[indexPath.row])
            return cell2
        } else {
            let cell = UITableViewCell (style: .subtitle, reuseIdentifier: "default")
            
            return cell
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (self.faculties?.count)!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let tl = (self.faculties?[row].code)!
        return tl
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let key = (self.faculties?[row].code)!.lowercased()
        loadClassesToTable(key: key)
        setCurrentFaculty(row: row)
    }
    
    
    lazy var facultyTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.cornerRadius = 6
        tv.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tv.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        
        return tv
    }()
    
    lazy var userClassesTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.cornerRadius = 6
        tv.dataSource = self
        
        let tapGestureBottom = UITapGestureRecognizer(target: self, action: #selector(handleTapBottom))
        tv.addGestureRecognizer(tapGestureBottom)
        tapGestureBottom.delegate = self
        
        return tv
    }()
    
    let userClassLabel: UILabel = {
        let ul = UILabel()
        ul.translatesAutoresizingMaskIntoConstraints = false
        ul.text = "My Classes:"
        ul.textColor = UIColor.white
        ul.font = UIFont.boldSystemFont(ofSize: 16)
        return ul
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Done", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        return button
    }()
    
    lazy var facultyPicker: UIPickerView = {
        let pv = UIPickerView()
        pv.backgroundColor = UIColor.white
        pv.layer.cornerRadius = 6
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.dataSource = self
        pv.delegate = self
        return pv
    }()
    
    let viewLabel: UILabel = {
        let ul = UILabel()
        ul.translatesAutoresizingMaskIntoConstraints = false
        ul.text = "Select your Classes"
        ul.textColor = UIColor.white
        ul.font = UIFont.boldSystemFont(ofSize: 18)
        return ul
    }()

    func setupFacultyTableView() {
        facultyTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facultyTableView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -35).isActive = true
        facultyTableView.heightAnchor.constraint(equalToConstant: 185).isActive = true
        facultyTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 165).isActive = true
    }
    
    func setupUserClassesTableView() {
        userClassesTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userClassesTableView.widthAnchor.constraint(equalTo: facultyTableView.widthAnchor).isActive = true
        userClassesTableView.heightAnchor.constraint(equalTo: facultyTableView.heightAnchor).isActive = true
        userClassesTableView.topAnchor.constraint(equalTo: facultyTableView.bottomAnchor, constant: 40).isActive = true
    }
    
    func setupUserClassLabel() {
        userClassLabel.leftAnchor.constraint(equalTo: userClassesTableView.leftAnchor).isActive = true
        userClassLabel.bottomAnchor.constraint(equalTo: userClassesTableView.topAnchor, constant: -5).isActive = true
    }
    
    func setupDoneButton(){
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        doneButton.widthAnchor.constraint(equalTo: userClassesTableView.widthAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    
    func setupPickerView(){
        facultyPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facultyPicker.bottomAnchor.constraint(equalTo: facultyTableView.topAnchor, constant: -25).isActive = true
        facultyPicker.widthAnchor.constraint(equalTo: facultyTableView.widthAnchor).isActive = true
        facultyPicker.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func setupViewLabel() {
        viewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewLabel.bottomAnchor.constraint(equalTo: facultyPicker.topAnchor, constant: -15).isActive = true
    }
}

class UserCell: UITableViewCell {
    
    let CS = ClassSelectController()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CS.handleTap(recognizer:)))
        addGestureRecognizer(tapGesture)
        
        let tapGestureBottom = UITapGestureRecognizer(target: self, action: #selector(CS.handleTapBottom(recognizer:)))
        addGestureRecognizer(tapGestureBottom)
    }
}

extension Array  {
    var indexedDictionary: [String : AnyObject] {
        var result: [String : AnyObject] = [:]
        enumerated().forEach({ result["\($0.offset)"] = "\($0.element)" as AnyObject? })
        return result
    }
}

class Class: NSObject {
    
    var number: String?
    var name: String?
    
    
}

class Faculty: NSObject {
    
    var code: String?
    var name: String?
    
}

