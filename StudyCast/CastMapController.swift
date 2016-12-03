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
    let c00 = CLLocation(latitude: 49.278773, longitude: -122.904642)
    let c01 = CLLocation(latitude: 49.279267, longitude: -122.904727)
    let c10 = CLLocation(latitude: 49.278691, longitude: -122.903508)
    let c11 = CLLocation(latitude: 49.279231, longitude: -122.903533)
    var region: Region?
    var myLocation: CLLocation?
    var castClass = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
        self.region = Region(zz: c00, zo: c01, oz: c10, oo: c11)
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.map = MKMapView()
        
        self.map?.mapType = .standard
        self.map?.frame = view.frame
        self.map?.delegate = self
        view.addSubview(self.map!)
        
        self.map?.showsUserLocation = true
        
        let location = CLLocationCoordinate2DMake(49.277446, -122.914248)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Applied Science Building"
        
        fetchCurrentCastClass()
        setAnnotationSubtitles()
        
        //FOR TESTING
        let span = MKCoordinateSpanMake(0.002, 0.002)
        let region = MKCoordinateRegion(center: location, span: span)
        map?.setRegion(region, animated: true)
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        map?.addAnnotation(annotation)
        fetchCurrentCastClass()
        
        setupNavBar()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        self.myLocation = location
        
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08))
        
        self.map?.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
        
        if (self.region?.doesContain(location: self.myLocation!))! {
            print("you're in there big guy")
        }
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
        //self.tabBarController?.tabBar.layer.zPosition = -1
        let castMenuController = CastMenuController()
        castMenuController.modalPresentationStyle = .overCurrentContext
        present(castMenuController, animated: false, completion: nil)
    }
    
    func fetchCurrentCastClass() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).child("cast").child("course").observe(.value, with: { (snapshot) in
            if snapshot.exists() == true {
                self.castClass = snapshot.value as! String
            } else {
                self.castClass = ""
            }
        })
    }
    
    func setAnnotationSubtitles() {
        if castClass != "" {
            /*guard let uid = FIRAuth.auth()?.currentUser?.uid else {
                return
            }*/
            FIRDatabase.database().reference().child(castClass).observe(.childAdded, with: { (snapshot) in
                print(snapshot)
            
            })
        }
    }
}

