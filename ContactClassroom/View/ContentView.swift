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
        
        
        for building in getBuildings() {
            let location = CLLocationCoordinate2D(latitude: building.latitude, longitude: building.longitude)
            let marker : GMSMarker = GMSMarker()
            marker.icon = UIImage(named: "1pin")
            marker.position = location
            marker.appearAnimation = GMSMarkerAnimation.pop
            marker.map = mapView
        }
        
        do {
            if let styleURL = Bundle.main.url(forResource: "mapStyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find style.json")
            }
        } catch {
            print("One or more of the map styles failed to load. \(error)")
        }
        
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
    
    private func getBuildings() -> [Location] {
        let locationArray: [Location] = [
            // West village Commons
            Location(latitude:  39.3940218, longitude: -76.6184438),
            // Carroll hall
            Location(latitude:  39.3940218, longitude: -76.6184434),
            // Paca and Tubman house
            Location(latitude:  39.3944993, longitude: -76.6186892),
            // Marshall hall
            Location(latitude:  39.3946746, longitude: -76.6194628),
            // West village garage
            Location(latitude:  39.3947254, longitude: -76.6204467),
            // Enrollment services
            Location(latitude:  39.3949443, longitude: -76.6178101),
            // University village
            Location(latitude:  39.3933607, longitude: -76.6188616),
            // Johnny Unitas Stadium
            Location(latitude:  39.388137, longitude: -76.6172737),
            // SECU Arena
            Location(latitude:  39.3864039, longitude: -76.6178852),
            // Towson univ town center
            Location(latitude:  39.3865108, longitude: -76.6186189),
            // Union garage
            Location(latitude:  39.3932044, longitude: -76.6131649),
            // glen complex (all towers)
            Location(latitude:  39.3923757, longitude: -76.6106722),
            // University Union
            Location(latitude:  39.3936687, longitude: -76.6118096),
            // Burdick hall
            Location(latitude:  39.3944498, longitude: -76.6121875),
            // Towson Towson Garage
            Location(latitude:  39.3960833, longitude: -76.6109245),
            // Liberal arts building
            Location(latitude:  39.3948443, longitude: -76.6096412),
            // Freedom square
            Location(latitude:  39.3941533, longitude: -76.6089873),
            // Adacemic advising
            Location(latitude:  39.3941533, longitude: -76.6089873),
            // Hawkins hall
            Location(latitude:  39.3936619, longitude: -76.6096862),
            // Smith hall
            Location(latitude:  39.3936619, longitude: -76.6096862),
            // Linthicum hall
            Location(latitude:  39.3940178, longitude: -76.6092685),
            // Newell hall
            Location(latitude:  39.3938781, longitude: -76.6069652),
            // Albert S Cook Library
            Location(latitude:  39.3938781, longitude: -76.6069652),
            // Stevens Hall
            Location(latitude:  39.3929446, longitude: -76.6064361),
            // 7800 York Road
            Location(latitude:  39.3916323, longitude: -76.6074323),
            // 8000 York Road admin building
            Location(latitude:  39.3917449, longitude: -76.6083984),
            // Scarborough & Prettyman hall
            Location(latitude:  39.3942515, longitude: -76.6059451)
        ]
        return locationArray
    }
    
    private func getDummyLocations() -> [Location] {
        let locationArray : [Location] = [
        Location(latitude:  39.392516, longitude: -76.614828),
        Location(latitude:  39.392516, longitude: -76.615828),
        Location(latitude:  39.392516, longitude: -76.616828),
        Location(latitude:  39.392516, longitude: -76.617828),
        Location(latitude:  39.392516, longitude: -76.618828),
        Location(latitude:  39.392516, longitude: -76.619828),
        Location(latitude:  39.392516, longitude: -76.615928),
        Location(latitude:  39.392516, longitude: -76.616728),
        Location(latitude:  39.392516, longitude: -76.617628),
        Location(latitude:  39.392516, longitude: -76.618528),
        Location(latitude:  39.392516, longitude: -76.614828),
        Location(latitude:  39.392516, longitude: -76.615828),
        Location(latitude:  39.392516, longitude: -76.616828),
        Location(latitude:  39.392516, longitude: -76.617828),
        Location(latitude:  39.392516, longitude: -76.618828),
        Location(latitude:  39.392516, longitude: -76.619828),
        Location(latitude:  39.392516, longitude: -76.615928),
        Location(latitude:  39.392516, longitude: -76.616728),
        Location(latitude:  39.392516, longitude: -76.617628),
        Location(latitude:  39.392516, longitude: -76.618528),
        Location(latitude:  39.392516, longitude: -76.614828),
        Location(latitude:  39.392516, longitude: -76.615828),
        Location(latitude:  39.392516, longitude: -76.616828),
        Location(latitude:  39.392516, longitude: -76.617828),
        Location(latitude:  39.392516, longitude: -76.618828),
        Location(latitude:  39.392516, longitude: -76.619828),
        Location(latitude:  39.392516, longitude: -76.615928),
        Location(latitude:  39.392516, longitude: -76.616728),
        Location(latitude:  39.392516, longitude: -76.617628),
        Location(latitude:  39.392516, longitude: -76.618528),
        Location(latitude:  39.392516, longitude: -76.614828),
        Location(latitude:  39.392516, longitude: -76.615828),
        Location(latitude:  39.392516, longitude: -76.616828),
        Location(latitude:  39.392516, longitude: -76.617828),
        Location(latitude:  39.392516, longitude: -76.618828),
        Location(latitude:  39.392516, longitude: -76.619828),
        Location(latitude:  39.392516, longitude: -76.615928),
        Location(latitude:  39.392516, longitude: -76.616728),
        Location(latitude:  39.392516, longitude: -76.617628),
        Location(latitude:  39.392516, longitude: -76.618528),
        Location(latitude:  39.392516, longitude: -76.614828),
        Location(latitude:  39.392516, longitude: -76.615828),
        Location(latitude:  39.392516, longitude: -76.616828),
        Location(latitude:  39.392516, longitude: -76.617828),
        Location(latitude:  39.392516, longitude: -76.618828),
        Location(latitude:  39.392516, longitude: -76.619828),
        Location(latitude:  39.392516, longitude: -76.615928),
        Location(latitude:  39.392516, longitude: -76.616728),
        Location(latitude:  39.392516, longitude: -76.617628),
        Location(latitude:  39.392516, longitude: -76.618528),
        Location(latitude:  39.392516, longitude: -76.614828),
        Location(latitude:  39.392516, longitude: -76.615828),
        Location(latitude:  39.392516, longitude: -76.616828),
        Location(latitude:  39.392516, longitude: -76.617828),
        Location(latitude:  39.392516, longitude: -76.618828),
        Location(latitude:  39.392516, longitude: -76.619828),
        Location(latitude:  39.392516, longitude: -76.615928),
        Location(latitude:  39.392516, longitude: -76.616728),
        Location(latitude:  39.392516, longitude: -76.617628),
        Location(latitude:  39.392516, longitude: -76.618528),
        Location(latitude:  39.392516, longitude: -76.614828),
        Location(latitude:  39.392516, longitude: -76.615828),
        Location(latitude:  39.392516, longitude: -76.616828),
        Location(latitude:  39.392516, longitude: -76.617828),
        Location(latitude:  39.392516, longitude: -76.618828),
        Location(latitude:  39.392516, longitude: -76.619828),
        Location(latitude:  39.392516, longitude: -76.615928),
        Location(latitude:  39.392516, longitude: -76.616728),
        Location(latitude:  39.392516, longitude: -76.617628),
        Location(latitude:  39.392516, longitude: -76.618528),
        Location(latitude:  39.392516, longitude: -76.614828),
        Location(latitude:  39.392516, longitude: -76.615828),
        Location(latitude:  39.392516, longitude: -76.616828),
        Location(latitude:  39.392516, longitude: -76.617828),
        Location(latitude:  39.392516, longitude: -76.618828),
        Location(latitude:  39.392516, longitude: -76.619828),
        Location(latitude:  39.392516, longitude: -76.615928),
        Location(latitude:  39.392516, longitude: -76.616728),
        Location(latitude:  39.392516, longitude: -76.617628),
        Location(latitude:  39.392516, longitude: -76.618528),
        ]
        
        return locationArray
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.isClicked.toggle()
        return true
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
        ZStack (alignment: Alignment.top)  {
            GoogleMapControllerRepresentable(isClicked: $isClicked, numClicks: $numClicks, school: $school)
            .overlay(
                ZStack () {
                    VStack (alignment: .trailing) {
                        Spacer()
                        HStack (alignment: .bottom) {
                            Spacer()
                            Button(action: {
                                NSLog("button clicked")
                                self.cameraClicked.toggle()
                            }) {
                                Image("camera_enabled")
                                    .renderingMode(.original)
                            }
                        }
                    }
                }
            )
            BottomSheetModal(display: $isClicked, backgroundColor: .constant(Color.red), rectangleColor: .constant(Color.white)) {
                HStack {
                    Image("camera_enabled")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                
                    HStack {
                        Image("address")
                            .padding(.bottom, 10)
                        Text("Building name")
                        
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .edgesIgnoringSafeArea(.all)
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
