//
//  SchoolView.swift
//  ContactClassroom
//
//  Created by Jal Irani on 6/16/20.
//  Copyright © 2020 Jal Irani. All rights reserved.
//

import SwiftUI
import CoreLocation

struct SchoolView: View {
    
    @State var schools = [
        School(id: 0, shortHand: "BSU", name: "Bowie State University", location: CLLocationCoordinate2D(latitude: 39.0192959, longitude: -76.7615916)),
        School(id: 1, shortHand: "CSU", name: "Coppin State University", location: CLLocationCoordinate2D(latitude: 39.3126052, longitude: -76.660186)),
        School(id: 2, shortHand: "FSU", name: "Frostburg State University", location: CLLocationCoordinate2D(latitude: 39.6501707, longitude: -76.660186)),
        School(id: 3, shortHand: "SU", name: "Salisbury University", location: CLLocationCoordinate2D(latitude: 38.3453561, longitude: -75.6083267)),
        School(id: 4, shortHand: "TU", name: "Towson University", location: CLLocationCoordinate2D(latitude: 39.3925162, longitude: -76.6148279)),
        School(id: 5, shortHand: "UB", name: "University of Baltimore", location: CLLocationCoordinate2D(latitude: 39.3061129, longitude: -76.6174919)),
        School(id: 6, shortHand: "UMDB", name: "University of Maryland, Baltimore", location: CLLocationCoordinate2D(latitude: 39.2892058, longitude: -76.6278944)),
        School(id: 7, shortHand: "UMBC", name: "University of Maryland, Baltimore County", location: CLLocationCoordinate2D(latitude: 39.0192959, longitude: -76.7615916)),
        School(id: 8, shortHand: "UMD", name: "University of Maryland, College Park", location: CLLocationCoordinate2D(latitude: 38.9869224, longitude: -76.944743)),
        School(id: 9, shortHand: "UMES", name: "University of Maryland Eastern Shore", location: CLLocationCoordinate2D(latitude: 38.210220, longitude: -75.6869889)),
        School(id: 10, shortHand: "UMGC", name: "University of Maryland Global Campus", location: CLLocationCoordinate2D(latitude: 38.9125724, longitude: -76.849762)),
        School(id: 11, shortHand: "SG", name: "The Universities at Shady Grove", location: CLLocationCoordinate2D(latitude: 39.0941979, longitude: -77.2027823)),
    ]
    
    var body: some View {
        NavigationView {
            List(schools, id: \.name) { school in
                NavigationLink(destination: ContentView(school: school)) {
                    HStack {
                        Text(school.name)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .listStyle(GroupedListStyle())
            .navigationBarTitle("")
        }
    }
}

struct SchoolView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolView()
    }
}
