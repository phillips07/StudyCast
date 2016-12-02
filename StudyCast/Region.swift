//
//  Region.swift
//  StudyCast
//
//  Created by Austin Phillips on 2016-12-02.
//  Copyright © 2016 Austin Phillips. All rights reserved.
//

import UIKit
import CoreLocation

class Region: NSObject {
    var corner00: CLLocation?
    var corner01: CLLocation?
    var corner10: CLLocation?
    var corner11: CLLocation?
    
    init(zz: CLLocation, zo: CLLocation, oz: CLLocation, oo: CLLocation) {
        corner00 = zz
        corner01 = zo
        corner10 = oz
        corner11 = oo
    }
    
    func doesContain(location: CLLocation) -> Bool {
        var inLat = false
        var inLong = false
        
        if location.coordinate.latitude < (corner01?.coordinate.latitude)! && location.coordinate.latitude > (corner00?.coordinate.latitude)! {
            inLat = true
        }
        if location.coordinate.longitude > (corner00?.coordinate.longitude)! && location.coordinate.longitude < (corner11?.coordinate.longitude)! {
            inLong = true
        }
        
        if inLat && inLong {
            return true
        }
        
        return false
        
    }
}
