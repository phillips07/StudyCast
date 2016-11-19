//
//  GroupController+handlers.swift
//  StudyCast
//
//  Created by Dennis Huebert on 2016-11-18.
//  Copyright © 2016 Apollo. All rights reserved.
//

import Foundation
import Firebase

extension GroupsController {

    func handleAddGroup() {
        let addGroupController = AddGroupController()
        present(addGroupController, animated: true, completion: nil)
    }
}
