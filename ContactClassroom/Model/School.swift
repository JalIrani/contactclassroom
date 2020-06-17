//
//  School.swift
//  ContactClassroom
//
//  Created by Jal Irani on 6/15/20.
//  Copyright © 2020 Jal Irani. All rights reserved.
//

import Foundation
import CoreLocation

struct School: Identifiable {
    
    var id: Int
    let shortHand: String
    let name: String
    let location: CLLocationCoordinate2D
    
    init(id: Int, shortHand: String, name: String, location: CLLocationCoordinate2D) {
        self.id = id
        self.shortHand = shortHand
        self.name = name
        self.location = location
    }
}
