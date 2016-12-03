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
        var x0 = location.coordinate.longitude
        var y0 = location.coordinate.latitude
        var x1 = (self.corner00?.coordinate.longitude)!
        var y1 = (self.corner00?.coordinate.latitude)!
        var x2 = (self.corner10?.coordinate.longitude)!
        var y2 = (self.corner10?.coordinate.latitude)!
        var x3 = (self.corner01?.coordinate.longitude)!
        var y3 = (self.corner01?.coordinate.latitude)!
        var x4 = (self.corner11?.coordinate.longitude)!
        var y4 = (self.corner11?.coordinate.latitude)!
        
        x0 = x0 - x1
        x2 = x2 - x1
        x3 = x3 - x1
        x4 = x4 - x1
        x1 = 0
        
        y0 = y0 - y2
        y1 = y1 - y2
        y3 = y3 - y2
        y4 = y4 - y2
        y2 = 0
        
        let slope1 = (y2-y1)/(x2-x1)
        let slope2 = (y3-y1)/(x3-x1)
        let slope3 = (y4-y3)/(x4-x3)
        let slope4 = (y4-y2)/(x4-x2)
        
        let c1 = y3 - slope3 * x3
        let c2 = -1 * slope4 * x2
        
        if (x0 > x1 && x0 < x4) && (y0 > y2 && y0 < y3) {
            if x0 < x3 {
                //calc1
                let A = x0 * slope1 + y1
                let B = x0 * slope2 + y1
                
                if y0 > A && y0 < B {
                    return true
                }
            } else if x0 >= x3 && x0 < x2 {
                //calc2
                let A = x0 * slope1 + y1
                let B = x0 * slope3 + c1
                
                if y0 > A && y0 < B {
                    return true
                }
            } else {
                //calc3
                let B = x0 * slope3 + c1
                let A = x0 * slope4 + c2
                
                if y0 > A && y0 < B {
                    return true
                }
            }
        }
        return false
    }
}
