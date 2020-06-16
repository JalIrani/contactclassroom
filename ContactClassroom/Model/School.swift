//
//  School.swift
//  ContactClassroom
//
//  Created by Jal Irani on 6/15/20.
//  Copyright © 2020 Jal Irani. All rights reserved.
//

import Foundation

struct School: Identifiable {
    
    var id: Int
    let shortHand: String
    let name: String
    let latitude: Double
    let longitude: Double
    
    init(id: Int, shortHand: String, name: String, latitude: Double, longitude: Double) {
        self.id = id
        self.shortHand = shortHand
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}
