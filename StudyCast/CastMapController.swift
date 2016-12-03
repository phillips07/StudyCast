//
//  CastMapController.swift
//  StudyCast
//
//  Created by Dennis Huebert on 2016-11-29.
//  Copyright © 2016 Austin Phillips. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class CastMapController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var map: MKMapView?
    let locationManager = CLLocationManager()
    var myLocation: CLLocation?
    var regionName: String?
    var currentCast: String?

    var castClass = ""
    
    let asbAnnotation = MKPointAnnotation()
    let aqAnnotation = MKPointAnnotation()
    let libraryAnnotation = MKPointAnnotation()
    let mbcAnnotation = MKPointAnnotation()
    let westMallAnnotation = MKPointAnnotation()
    let tasc1Annotation = MKPointAnnotation()
    let tasc2Annotation = MKPointAnnotation()
    let sciBuildsAnnotation = MKPointAnnotation()
    let blussonAnnotation = MKPointAnnotation()
    let southScienceAnnotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.castClass = ""
        
        self.map = MKMapView()
        self.map?.mapType = .standard
        self.map?.frame = view.frame
        self.map?.delegate = self
        view.addSubview(self.map!)
        self.map?.showsUserLocation = true
        
        let aqCoordinate = CLLocationCoordinate2DMake(49.278810, -122.916604)
        let mbcCoordinate = CLLocationCoordinate2DMake(49.278859, -122.919021)
        let wmCoordinate = CLLocationCoordinate2DMake(49.279799, -122.921348)
        let sciCoordinate = CLLocationCoordinate2DMake(49.277906, -122.916950)
        let southSciCoordinate = CLLocationCoordinate2DMake(49.277228, -122.917989)
        let asbCoordinate = CLLocationCoordinate2DMake(49.277443, -122.914305)
        let blussonCoordinate = CLLocationCoordinate2DMake(49.279465, -122.914055)
        let tasc1Coordinate = CLLocationCoordinate2DMake(49.276721, -122.914348)
        let tasc2Coordinate = CLLocationCoordinate2DMake(49.277057,  -122.916194)
        let libraryCoordinate = CLLocationCoordinate2DMake(49.279710, -122.919050)
 
        asbAnnotation.coordinate = asbCoordinate
        aqAnnotation.coordinate = aqCoordinate
        libraryAnnotation.coordinate = libraryCoordinate
        mbcAnnotation.coordinate = mbcCoordinate
        westMallAnnotation.coordinate = wmCoordinate
        tasc1Annotation.coordinate = tasc1Coordinate
        tasc2Annotation.coordinate = tasc2Coordinate
        sciBuildsAnnotation.coordinate = sciCoordinate
        blussonAnnotation.coordinate = blussonCoordinate
        southScienceAnnotation.coordinate = southSciCoordinate
        
        asbAnnotation.title = "Applied Science Building"
        aqAnnotation.title = "Academic Quadrangle"
        libraryAnnotation.title = "Bennett Library"
        mbcAnnotation.title = "Maggie Benston Centre"
        westMallAnnotation.title = "West Mall Centre"
        tasc1Annotation.title = "TASC 1"
        tasc2Annotation.title = "TASC 2"
        sciBuildsAnnotation.title = "Shrum Science Centre"
        blussonAnnotation.title = "Blusson Hall"
        southScienceAnnotation.title = "South Science Building"
        
        setAnnotationSubtitles(locationAnnotation: self.asbAnnotation, locationName: "Applied Science Building")
        setAnnotationSubtitles(locationAnnotation: self.aqAnnotation, locationName: "Academic Quadrangle")
        setAnnotationSubtitles(locationAnnotation: self.libraryAnnotation, locationName: "Bennett Library")
        setAnnotationSubtitles(locationAnnotation: self.mbcAnnotation, locationName: "Maggie Benston Centre")
        setAnnotationSubtitles(locationAnnotation: self.westMallAnnotation, locationName: "West Mall Centre")
        setAnnotationSubtitles(locationAnnotation: self.tasc1Annotation, locationName: "TASC 1")
        setAnnotationSubtitles(locationAnnotation: self.tasc2Annotation, locationName: "TASC 2")
        setAnnotationSubtitles(locationAnnotation: self.sciBuildsAnnotation, locationName: "Shrum Science Centre")
        setAnnotationSubtitles(locationAnnotation: self.blussonAnnotation, locationName: "Blusson Hall")
        setAnnotationSubtitles(locationAnnotation: self.southScienceAnnotation, locationName: "South Science Building")

        
        map?.addAnnotation(asbAnnotation)
        map?.addAnnotation(aqAnnotation)
        map?.addAnnotation(libraryAnnotation)
        map?.addAnnotation(mbcAnnotation)
        map?.addAnnotation(westMallAnnotation)
        map?.addAnnotation(tasc1Annotation)
        map?.addAnnotation(tasc2Annotation)
        map?.addAnnotation(sciBuildsAnnotation)
        map?.addAnnotation(blussonAnnotation)
        map?.addAnnotation(southScienceAnnotation)
        
        setupNavBar()
        checkCast()
    }
    
    func checkCast() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).child("cast").child("course").observe(.value, with: { (snapshot) in
            if snapshot.exists() == true {
                self.currentCast = snapshot.value as? String
            } else {
                self.handleNotCasting()
                return
            }
        })

    }
    
    func handleNotCasting(){
        let alertController = UIAlertController(title: "No Cast Found", message: "It doesn't look like you're casting any of your classes.\n\nThis could be because your cast was successful, and you have group invitation waiting for you on the home screen!\n\nOr...\n\nYou may not have begun casting.\n\nTo begin/resume casting, tap the icon in the top right corner.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {UIAlertAction in
            NSLog("OK Pressed")
        })
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        //self.myLocation = location
        self.myLocation = outLocation
        
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08))
        
        self.map?.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.castClass = ""
        setAnnotationSubtitles(locationAnnotation: self.asbAnnotation, locationName: "Applied Science Building")
        setAnnotationSubtitles(locationAnnotation: self.aqAnnotation, locationName: "Academic Quadrangle")
        setAnnotationSubtitles(locationAnnotation: self.libraryAnnotation, locationName: "Bennett Library")
        setAnnotationSubtitles(locationAnnotation: self.mbcAnnotation, locationName: "Maggie Benston Centre")
        setAnnotationSubtitles(locationAnnotation: self.westMallAnnotation, locationName: "West Mall Centre")
        setAnnotationSubtitles(locationAnnotation: self.tasc1Annotation, locationName: "TASC 1")
        setAnnotationSubtitles(locationAnnotation: self.tasc2Annotation, locationName: "TASC 2")
        setAnnotationSubtitles(locationAnnotation: self.sciBuildsAnnotation, locationName: "Shrum Science Centre")
        setAnnotationSubtitles(locationAnnotation: self.blussonAnnotation, locationName: "Blusson Hall")
        setAnnotationSubtitles(locationAnnotation: self.southScienceAnnotation, locationName: "South Science Building")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager Failed with errors: " + error.localizedDescription)
    }
    
    
    func setupNavBar() {
        let image = UIImage(named: "CastIcon")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleCastSettings))
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
        self.tabBarController?.tabBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 5, height: 40)
        
        let titleLabel = UILabel()
        titleLabel.text = "Cast"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLabel)
        
        titleLabel.centerXAnchor.constraint(equalTo: titleView.leftAnchor, constant: 5).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        titleLabel.textColor = UIColor.white
        
        self.navigationItem.titleView = titleView

    }
    
    func setRegionName() {
        if aq.doesContain(location: self.myLocation!) {
            self.regionName = aq.regionName
        } else if mbc.doesContain(location: self.myLocation!) {
            self.regionName = mbc.regionName
        } else if westMall.doesContain(location: self.myLocation!) {
            self.regionName = westMall.regionName
        } else if sciBuilds.doesContain(location: self.myLocation!) {
            self.regionName = sciBuilds.regionName
        } else if southScience.doesContain(location: self.myLocation!) {
            self.regionName = southScience.regionName
        } else if asb.doesContain(location: self.myLocation!) {
            self.regionName = asb.regionName
        } else if blusson.doesContain(location: self.myLocation!) {
            self.regionName = blusson.regionName
        } else if tasc2.doesContain(location: self.myLocation!) {
            self.regionName = tasc2.regionName
        } else if tasc1.doesContain(location: self.myLocation!) {
            self.regionName = tasc1.regionName
        } else if library.doesContain(location: self.myLocation!) {
            self.regionName = library.regionName
        } else {
            handleNotInSchool()
        }
    }
    
    func handleNotInSchool() {
        let alertController = UIAlertController(title: "Beuller? Beuller?", message: "We cant't locate you in any of the study Locations at SFU.\nTo cast for study partners you'll need to be in one of the following places:\nAQ, MBC, WMC, ASB, Shrum Science Centre, South Science Building, Blusson Hall, TASC 1, TASC 2, or the Library.\nHead to one of those locations, and try casting again!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {UIAlertAction in
        NSLog("OK Pressed")
        })
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func handleCastSettings() {
        let castMenuController = CastMenuController()
        setRegionName()
        if let nom = self.regionName {
            castMenuController.setLocation(location: nom)
            castMenuController.modalPresentationStyle = .overCurrentContext
            present(castMenuController, animated: false, completion: nil)
        }
    }
    

    func setAnnotationSubtitles(locationAnnotation: MKPointAnnotation, locationName: String) {
        var castersCount = 0
        self.castClass = ""
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).child("cast").child("course").observe(.value, with: { (snapshot) in
            castersCount = 0
            if snapshot.exists() == true {
                self.castClass = snapshot.value as! String
            } else {
                self.castClass = ""
            }
            if self.castClass != "" {
                FIRDatabase.database().reference().child(self.castClass).observe(.childAdded, with: { (snapshot) in
                    if let usersDictionary = snapshot.value as? [String: AnyObject] {
                        if usersDictionary["location"] as? String == locationName {
                            castersCount += 1
                        }
                    }
                    if castersCount == 1 {
                        locationAnnotation.subtitle = "Currently there is \(castersCount) person studying " + self.castClass + " here"
                    } else {
                        locationAnnotation.subtitle = "Currently there are \(castersCount) people studying " + self.castClass + " here"
                    }
                })
            }
        })
    }
    
    let aq = Region(name: "Academic Quadrangle", zz: CLLocation(latitude: 49.278473, longitude: -122.917770), zo: CLLocation(latitude: 49.279724, longitude: -122.917312), oz: CLLocation(latitude: 49.278151, longitude: -122.915756), oo: CLLocation(latitude: 49.279386, longitude: -122.915262))
    let library = Region(name: "Library", zz: CLLocation(latitude: 49.279567, longitude: -122.919615), zo: CLLocation(latitude: 49.279921, longitude: -122.919507), oz: CLLocation(latitude: 49.279325, longitude: -122.918045), oo: CLLocation(latitude: 49.279682, longitude: -122.917915))
    let mbc = Region(name: "Maggie Benston Centre", zz: CLLocation(latitude: 49.278386, longitude: -122.920303), zo: CLLocation(latitude: 49.279345, longitude: -122.919921), oz: CLLocation(latitude: 49.278109, longitude: -122.918617), oo: CLLocation(latitude: 49.279080, longitude: -122.918358))
    let westMall = Region(name: "West Mall Centre", zz: CLLocation(latitude: 49.279750, longitude: -122.922868), zo: CLLocation(latitude: 49.280408, longitude: -122.922640), oz: CLLocation(latitude: 49.279305, longitude: -122.920032), oo: CLLocation(latitude: 49.279975, longitude: -122.919810))
    let asb = Region(name: "Applied Science Building", zz: CLLocation(latitude: 49.277230, longitude: -122.915784), zo: CLLocation(latitude: 49.278173, longitude: -122.915457), oz: CLLocation(latitude: 49.276925, longitude: -122.913827), oo: CLLocation(latitude: 49.277888, longitude: -122.913513))
    let tasc1 = Region(name: "Technology and Science Complex 1", zz: CLLocation(latitude: 49.276707, longitude: -122.915210), zo: CLLocation(latitude: 49.276994, longitude: -122.915127), oz: CLLocation(latitude: 49.276468, longitude: -122.913272), oo: CLLocation(latitude: 49.276745, longitude: -122.913205))
    let tasc2 = Region(name: "Technology and Science Complex 2", zz: CLLocation(latitude: 49.276875, longitude: -122.917272), zo: CLLocation(latitude: 49.277374, longitude: -122.917073), oz: CLLocation(latitude: 49.276598, longitude: -122.915343), oo: CLLocation(latitude: 49.277092, longitude: -122.915160))
    let sciBuilds = Region(name: "Shrum Science Centre", zz: CLLocation(latitude: 49.277629, longitude: -122.918271), zo: CLLocation(latitude: 49.278443, longitude: -122.917971), oz: CLLocation(latitude: 49.277271, longitude: -122.915859), oo: CLLocation(latitude: 49.278052, longitude: -122.915609))
    let blusson = Region(name: "Blusson Hall", zz: CLLocation(latitude: 49.279349, longitude: -122.915243), zo: CLLocation(latitude: 49.279973, longitude: -122.914993), oz: CLLocation(latitude: 49.278910, longitude: -122.912473), oo: CLLocation(latitude: 49.279539, longitude: -122.912282))
    let southScience = Region(name: "South Science Building", zz: CLLocation(latitude: 49.277190, longitude: -122.918811), zo: CLLocation(latitude: 49.277526, longitude: -122.918745), oz: CLLocation(latitude: 49.276956, longitude: -122.917356), oo: CLLocation(latitude: 49.277314, longitude: -122.917206))
    
    let outLocation = CLLocation(latitude: 49.276874, longitude: -122.911443)
    let aqLocation = CLLocation(latitude: 49.278810, longitude: -122.916604)
    let mbcLocation = CLLocation(latitude: 49.278859, longitude: -122.919021)
    let wmLocation = CLLocation(latitude: 49.279799, longitude: -122.921348)
    let sciLocation = CLLocation(latitude: 49.277906, longitude: -122.916950)
    let southSciLocation = CLLocation(latitude: 49.277228, longitude: -122.917989)
    let asbLocation = CLLocation(latitude: 49.277443, longitude: -122.914305)
    let blussonLocation = CLLocation(latitude: 49.279465, longitude: -122.914055)
    let tasc1Location = CLLocation(latitude: 49.276721, longitude: -122.914348)
    let tasc2Location = CLLocation(latitude: 49.277057, longitude: -122.916194)
    let libraryLocation = CLLocation(latitude: 49.279710, longitude: -122.919050)
}

