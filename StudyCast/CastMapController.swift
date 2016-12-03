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

class CastMapController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var map: MKMapView?
    let locationManager = CLLocationManager()
    var myLocation: CLLocation?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
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
        
        setupNavBar()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        self.myLocation = location
        
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08))
        
        self.map?.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
        
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

