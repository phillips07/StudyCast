//
//  ClassSelectController.swift
//  StudyCastv2
//
//  Created by Dennis on 2016-11-04.
//  Copyright © 2016 Apollo. All rights reserved.
//

import UIKit
import Firebase

class ClassSelectController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    //the righteous axe used used to bring justice upon multi-threading issues
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
        fetchFaculties(semester: "2015/fall/")
        
        
        //vanquishing the slobbering beast of multi-threading issues
        while !(self.facultiesDone) {
            sleep(UInt32(0.1))
        }
        
        //more vanquishing
        fetchClasses()
        while !(self.classesDone) {
            sleep(UInt32(0.1))
        }


   
        
        //creating subviews
        view.addSubview(facultyTableView)
        view.addSubview(userClassesTableView)
        view.addSubview(userClassLabel)
        view.addSubview(doneButton)
        view.addSubview(classSearchBar)
        view.addSubview(viewLabel)
        
        //give functionality to each subview
        setupUserClassesTableView()
        setupFacultyTableView()
        setupUserClassLabel()
        setupDoneButton()
        setupClassSearchBar()
        setupViewLabel()
        
        

        
        self.facultyTableView.register(UserCell.self, forCellReuseIdentifier: "cell")
        self.userClassesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell2")
        
        
    }
    
    
    //to be implimented in a loop to run for each faculty in faculties array
    func fetchClasses() {
        
        self.hashTable = HashTable<String, [Class]>(capacity: 333)
        
        for fac in self.faculties! {
            
            let urlString = "http://www.sfu.ca/bin/wcm/course-outlines?2015/fall/\(fac.name!)"
            let url = URL(string: urlString)
            var loopDone = false
            
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                //check if an error is returned form the server
                if error != nil {
                    print(error!)
                    return
                }
                
                
                
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    
                    
                    
                    var classArr = [Class]()
                    
                    for dictionary in jsonData as! [[String:AnyObject]] {
                        
                        //had to use "clss" as "class" is obviously used as an identifier for other stuff
                        let clss = Class()
                        clss.number = dictionary["text"] as! String?
                        classArr.append(clss)
                        
                    }
                    
                    self.hashTable!["\(fac.name!)"] = classArr
                    

                    
                } catch let error {
                    print(error)
                }
                loopDone = true
            }.resume()
            while !loopDone {
                sleep(UInt32(0.1))
            }
        }
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
                
                for dictionary in jsonData as! [[String:AnyObject]] {
                    
                    //had to use "clss" as "class" is obviously used as an identifier for other stuff
                    let faculty = Faculty()
                    faculty.code = dictionary["text"] as! String?
                    faculty.name = dictionary["value"] as! String?
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
    
    
    
    lazy var facultyTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.cornerRadius = 6
        tv.dataSource = self
        let backButton = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(handleTap))
        self.navigationItem.leftBarButtonItem = backButton
        
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
    
    let classSearchBar: UISearchBar = {
        let cs = UISearchBar()
        cs.translatesAutoresizingMaskIntoConstraints = false
        var textFieldSearchBar = cs.value(forKey: "searchField") as? UITextField
        textFieldSearchBar?.textColor = UIColor.white
        cs.searchBarStyle = UISearchBarStyle.minimal
        return cs
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
        facultyTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 145).isActive = true
        
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
        doneButton.topAnchor.constraint(equalTo: userClassesTableView.bottomAnchor, constant: 30).isActive = true
        doneButton.widthAnchor.constraint(equalTo: userClassesTableView.widthAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupClassSearchBar(){
        classSearchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        classSearchBar.bottomAnchor.constraint(equalTo: facultyTableView.topAnchor, constant: -8).isActive = true
        classSearchBar.widthAnchor.constraint(equalTo: facultyTableView.widthAnchor, multiplier: 1.045).isActive = true
        classSearchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupViewLabel() {
        viewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewLabel.bottomAnchor.constraint(equalTo: classSearchBar.topAnchor, constant: -15).isActive = true
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

