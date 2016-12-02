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
        
        let camera = GMSCameraPosition.camera(withLatitude: 49.278084, longitude: -122.919879, zoom: 16)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        setupNavBar()
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.layer.zPosition = 0
    }*/
    
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
}
