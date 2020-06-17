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
        mapView.delegate = self
        self.view = mapView
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
