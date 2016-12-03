//
//  CastMapController.swift
//  StudyCast
//
//  Created by Dennis Huebert on 2016-11-29.
//  Copyright © 2016 Austin Phillips. All rights reserved.
//

import UIKit
//import GoogleMaps
import MapKit
import CoreLocation
import Firebase

class CastMapController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    //google maps stuff commented for work with mapKit
//    var locationManager = CLLocationManager()
//    var firstLocationUpdate: Bool?
//    var didFindMyLocation = false
//    var mapView: GMSMapView?
//    var myLocation: CLLocation?
    
    var map: MKMapView?
    let locationManager = CLLocationManager()
    let c00 = CLLocation(latitude: 49.278466, longitude: -122.917649)
    let c01 = CLLocation(latitude: 49.279685, longitude: -122.917251)
    let c10 = CLLocation(latitude: 49.278167, longitude: -122.915804)
    let c11 = CLLocation(latitude: 49.279386, longitude: -122.915346)
    var region: Region?
    var myLocation: CLLocation?
    var castClass = ""
    
    let location = CLLocationCoordinate2DMake(49.277446, -122.914248)
    let annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
        self.region = Region(zz: c00, zo: c01, oz: c10, oo: c11)
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.castClass = ""
        
        myLocation = CLLocation(latitude: 49.279339, longitude: -122.915539)
        
        /*if (region?.doesContain(location: myLocation!))! {
            print("You're in")
        } else {
            print("Not in")
        }*/
        
        
        self.map = MKMapView()
        
        self.map?.mapType = .standard
        self.map?.frame = view.frame
        self.map?.delegate = self
        view.addSubview(self.map!)
        
        self.map?.showsUserLocation = true
        
        self.annotation.coordinate = location
        self.annotation.title = "Applied Science Building"
        
        setAnnotationSubtitles()
        
        //FOR TESTING
        let span = MKCoordinateSpanMake(0.002, 0.002)
        let region = MKCoordinateRegion(center: location, span: span)
        map?.setRegion(region, animated: true)
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        map?.addAnnotation(annotation)
        
        setupNavBar()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        //self.myLocation = location
        
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08))
        
        self.map?.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
        
//        if (self.region?.doesContain(location: self.myLocation!))! {
//            print("you're in there big guy")
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.castClass = ""
        setAnnotationSubtitles()
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
    
    func handleCastSettings() {
        let castMenuController = CastMenuController()
        castMenuController.modalPresentationStyle = .overCurrentContext
        present(castMenuController, animated: false, completion: nil)
    }
    
    func setAnnotationSubtitles() {
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
                        if usersDictionary["location"] != nil {
                            castersCount += 1
                        }
                    }
                    if castersCount == 1 {
                        self.annotation.subtitle = "Currently there is \(castersCount) person studying " + self.castClass + " here"
                    } else {
                        self.annotation.subtitle = "Currently there are \(castersCount) people studying " + self.castClass + " here"
                    }
                })
            }
        })
    }
}

