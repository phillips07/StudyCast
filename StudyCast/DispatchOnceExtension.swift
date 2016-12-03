//
//  DispatchOnceExtension.swift
//  StudyCast
//
//  Created by Austin Phillips on 2016-12-03.
//  Copyright © 2016 Austin Phillips. All rights reserved.
//

import Foundation

public extension DispatchQueue {
    static var onceTracker = [String]()
    
    public class func once(file: String = #file, function: String = #function, line: Int = #line, block:(Void)->Void) {
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block:(Void)->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        
        if onceTracker.contains(token) {
            return
        }
        
        onceTracker.append(token)
        block()
    }
}
