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
    @Binding var building: Building
    var buildingList = [Building(name: "West Village Commons", image: "9pin", risk: "9", location: Location(latitude:  39.3940218, longitude: -76.6184438)),
    Building(name: "Carroll Hall", image: "2pin", risk: "2", location: Location(latitude:  39.3940218, longitude: -76.6184434))]
    var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    let defaultLocation = CLLocation(latitude: 39.327309, longitude: -76.616353)
    var zoomLevel: Float = 15.0
    private var heatmapLayer: GMUHeatmapTileLayer!
    
    init(isClicked: Binding<Bool>, numClicks: Binding<Int>, school: Binding<School>, building: Binding<Building>)  {
        _isClicked = isClicked
        _numClicks = numClicks
        _school = school
        _building = building
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        buildingList = getBuildings()
        
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
        
        for indivBuilding in buildingList {
            let location = CLLocationCoordinate2D(latitude: indivBuilding.location.latitude, longitude: indivBuilding.location.longitude)
            let marker : GMSMarker = GMSMarker()
            marker.icon = UIImage(named: indivBuilding.image)
            marker.position = location
            marker.title = indivBuilding.name
            marker.appearAnimation = GMSMarkerAnimation.pop
            marker.map = mapView
            marker.userData = indivBuilding
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
        }
        heatmapLayer.weightedData = list
    }
    
    private func getBuildings() -> [Building] {
        let locationArray: [Building] = [
            Building(name: "West Village Commons", image: "8pin", risk: "9", location: Location(latitude:  39.3940218, longitude: -76.6184438)),
            Building(name: "Carroll Hall", image: "5pin", risk: "2", location: Location(latitude:  39.3940218, longitude: -76.6184434)),
            Building(name: "7800 York Road", image: "5pin", risk: "3", location: Location(latitude:  39.3916323, longitude: -76.6074323)),
            Building(name: "8000 York Road", image: "4pin", risk: "3", location: Location(latitude:  39.3917449, longitude: -76.6083984)),
            Building(name: "Scarborough & Prettyman hall", image: "6pin", risk: "3", location: Location(latitude:  39.3942515, longitude: -76.6059451)),
            Building(name: "Stephens Hall", image: "6pin", risk: "3", location:  Location(latitude:  39.3929446, longitude: -76.6064361)),
            Building(name: "Albert S Cook Library", image: "7pin", risk: "3", location:  Location(latitude:  39.3938781, longitude: -76.6069652)),
            Building(name: "Newell hall", image: "4pin", risk: "3", location:  Location(latitude:  39.3938781, longitude: -76.6069652)),
            Building(name: "Linthicum hall", image: "2pin", risk: "3", location:  Location(latitude:  39.3940178, longitude: -76.6092685)),
            Building(name: "Smith hall", image: "4pin", risk: "3", location:  Location(latitude:  39.3936619, longitude: -76.6096862)),
            Building(name: "Hawkins Hall", image: "2pin", risk: "3", location:  Location(latitude:  39.3936619, longitude: -76.6096862)),
            Building(name: "Academic Advising", image: "1pin", risk: "3", location: Location(latitude:  39.3941533, longitude: -76.6089873)),
            Building(name: "Freedom Square", image: "1pin", risk: "3", location:  Location(latitude:  39.3941533, longitude: -76.6089873)),
            Building(name: "Liberal Arts Building", image: "4pin", risk: "3", location:  Location(latitude:  39.3948443, longitude: -76.6096412)),
            Building(name: "Towson Town Garage", image: "3pin", risk: "3", location:  Location(latitude:  39.3960833, longitude: -76.6109245)),
            Building(name: "Burdick Hall", image: "10pin", risk: "3", location:  Location(latitude:  39.3944498, longitude: -76.6121875)),
            Building(name: "Carroll Hall", image: "4pin", risk: "3", location:  Location(latitude:  39.3940218, longitude: -76.6184434)),
            Building(name: "Tubman and Paca House", image: "5pin", risk: "3", location:  Location(latitude:  39.3944993, longitude: -76.6186892)),
            Building(name: "Marshall Hall", image: "1pin", risk: "3", location:  Location(latitude:  39.3946746, longitude: -76.6194628)),
            Building(name: "West Village Garage", image: "9pin", risk: "3", location:  Location(latitude:  39.3947254, longitude: -76.6204467)),
            Building(name: "Enrollment Services", image: "3pin", risk: "3", location:  Location(latitude:  39.3949443, longitude: -76.6178101)),
            Building(name: "University Village", image: "9pin", risk: "3", location:  Location(latitude:  39.3933607, longitude: -76.6188616)),
            Building(name: "Johny Unitas Stadium", image: "3pin", risk: "3", location:  Location(latitude:  39.388137, longitude: -76.6172737)),
            Building(name: "SECU", image: "8pin", risk: "3", location:  Location(latitude:  39.3864039, longitude: -76.6178852))
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
        self.building = marker.userData as! Building
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
    @State var building: Building
    @State var isClicked: Bool = false
    @State var numClicks: Int = 0
    @State private var showBottomSheet = false
    @State var cameraClicked: Bool = false
    
    var body: some View {
        ZStack (alignment: Alignment.top)  {
            GoogleMapControllerRepresentable(isClicked: $isClicked, numClicks: $numClicks, school: $school, building: $building)
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
                                    .resizable()
                                    .frame(width: 90, height: 90)
                                    .aspectRatio(contentMode: .fit)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .sheet(isPresented: self.$cameraClicked) {
                                ProgressView()
                            }
                        }
                    }
                }
            )
            BottomSheetModal(display: $isClicked, backgroundColor: .constant(Color.gray), rectangleColor: .constant(Color.white)) {
                HStack {
                    Image("7800YorkRoad")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                    VStack {
                        HStack {
                            Text("7800 York Road")
                                .bold()
                                .foregroundColor(Color.white)
                        }
                        HStack {
                            Text("Rating: 5")
                                .bold()
                                .foregroundColor(Color.white)
                        }
                        HStack {
                            Text("Estimated occupants: 198")
                                .bold()
                                .foregroundColor(Color.white)
                        }
                    }
                    Spacer()
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
    @Binding var building: Building
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<GoogleMapControllerRepresentable>) -> GoogleMapController {
        return GoogleMapController(isClicked: $isClicked, numClicks: $numClicks, school: $school, building: $building)
    }

    func updateUIViewController(_ uiViewController: GoogleMapController, context: UIViewControllerRepresentableContext<GoogleMapControllerRepresentable>) {
        print(isClicked)
        print(numClicks)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(school: School(id: 4, shortHand: "TU", name: "Towson University", location: CLLocationCoordinate2D(latitude: 39.3925162, longitude: -76.6148279)), building: Building(name: "Test", image: "10pin", risk: "10", location: Location(latitude: 36.983298, longitude: -76.321233)))
    }
}
