//
//  ContentView.swift
//  ContactClassroom
//
//  Created by Jal Irani on 6/11/20.
//  Copyright © 2020 Jal Irani. All rights reserved.
//

import SwiftUI
import GoogleMaps
import GoogleMapsUtils

class GoogleMapController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    @Binding var isClicked: Bool
    @Binding var numClicks: Int
    @Binding var school: School
    var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    let defaultLocation = CLLocation(latitude: 39.327309, longitude: -76.616353)
    var zoomLevel: Float = 15.0
    private var heatmapLayer: GMUHeatmapTileLayer!
    
    init(isClicked: Binding<Bool>, numClicks: Binding<Int>, school: Binding<School>)  {
        _isClicked = isClicked
        _numClicks = numClicks
        _school = school
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
        }

        let camera = GMSCameraPosition.camera(withLatitude: school.location.latitude, longitude: school.location.longitude, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.setMinZoom(0, maxZoom: 25)
        mapView.isMyLocationEnabled = true
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.rotateGestures = true
        mapView.settings.tiltGestures = true
        mapView.isIndoorEnabled = false
        
        setUpHeatMap()
        
        mapView.delegate = self
        self.view = mapView
    }
    
    private func setUpHeatMap(){
        heatmapLayer = GMUHeatmapTileLayer()
        addHeatMap()
        heatmapLayer.map = mapView
    }
    
    private func addHeatMap(){
        var list = [GMUWeightedLatLng]()
        let locations = getDummyLocations()
        
        for location in locations {
            let lat = location.latitude
            let longi = location.longitude
            let coords = GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(lat, longi), intensity: 2.0)
            list.append(coords)
            print(list)
        }
        heatmapLayer.weightedData = list
    }
    
//    {"lat" : 39.392516, "lng" : -76.614828 } ,
//    {"lat" : 39.382516, "lng" : -75.624828 } ,
//    {"lat" : 39.372516, "lng" : -74.634828 } ,
//    {"lat" : 39.362516, "lng" : -73.644828 } ,
//    {"lat" : 39.352516, "lng" : -72.654828 }
    
    private func getDummyLocations() -> [Location] {
        let locationArray : [Location] = [
        Location(latitude:  39.392516, longitude: -76.614828),
        Location(latitude:  39.382516, longitude: -76.624828),
        Location(latitude:  39.372516, longitude: -76.634828),
        Location(latitude:  39.362516, longitude: -76.644828),
        Location(latitude:  39.352516, longitude: -76.654828),
        Location(latitude:  24.86170245, longitude: 67.00310938),
        Location(latitude:  24.83170980, longitude: 67.00210948),
        Location(latitude:  24.83073537, longitude: 67.02129903),
        Location(latitude:  24.83073230, longitude: 67.10113298),
        Location(latitude:  24.83079990, longitude: 67.02939980),
        Location(latitude:  24.85072329, longitude: 67.02129803),
        Location(latitude:  24.84089002, longitude: 67.02122203),
        Location(latitude:  24.84064338, longitude: 67.03120900),
        Location(latitude:  24.84058890, longitude: 67.04114039),
        Location(latitude:  24.85059990, longitude: 67.04139399),
        Location(latitude:  24.85034563, longitude: 67.04111009),
        Location(latitude:  24.85022093, longitude: 67.04117889),
        ]
        
        return locationArray
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      let location: CLLocation = locations.last!
      print("Location: \(location)")
    }

    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      switch status {
      case .restricted:
        let alert = UIAlertController(title: "Location Access is Restricted", message: "Please allow access in settings", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { action in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        print("Location access was restricted.")
      case .denied:
        print("User denied access to location.")
        // Display the map using the default location.
        mapView.isHidden = false
      case .notDetermined:
        print("Location status not determined.")
      case .authorizedAlways: fallthrough
      case .authorizedWhenInUse:
        print("Location status is OK.")
      @unknown default:
        print("Location is undetermined")
        }
    }
    
}

struct ContentView: View {
    
    @State var school: School
    @State var isClicked: Bool = false
    @State var numClicks: Int = 0
    @State private var showBottomSheet = false
    @State var cameraClicked: Bool = false
    
    var body: some View {
        VStack {
            GoogleMapControllerRepresentable(isClicked: $isClicked, numClicks: $numClicks, school: $school)
            //GoogleMapsView()
                //.edgesIgnoringSafeArea(.all)
        }
    }
}

struct GoogleMapControllerRepresentable: UIViewControllerRepresentable {
    
    @Binding var isClicked: Bool
    @Binding var numClicks: Int
    @Binding var school: School
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<GoogleMapControllerRepresentable>) -> GoogleMapController {
        return GoogleMapController(isClicked: $isClicked, numClicks: $numClicks, school: $school)
    }

    func updateUIViewController(_ uiViewController: GoogleMapController, context: UIViewControllerRepresentableContext<GoogleMapControllerRepresentable>) {
        print(isClicked)
        print(numClicks)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(school: School(id: 4, shortHand: "TU", name: "Towson University", location: CLLocationCoordinate2D(latitude: 39.3925162, longitude: -76.6148279)))
    }
}
