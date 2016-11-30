//
//  CastMapController.swift
//  StudyCast
//
//  Created by Dennis Huebert on 2016-11-29.
//  Copyright © 2016 Austin Phillips. All rights reserved.
//

import UIKit
import GoogleMaps

class CastMapController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
        self.navigationController?.title = "Cast"
        
        let camera = GMSCameraPosition.camera(withLatitude: 49.278084, longitude: -122.919879, zoom: 16)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
    }
}
