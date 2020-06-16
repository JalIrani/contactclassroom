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

struct ContentView: View {
    
    var body: some View {
        VStack {
            GoogleMapsView()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct GoogleMapsView: UIViewRepresentable {
    
    @ObservedObject var locationManager = LocationManager()
    private let zoom: Float = 16.0

    
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: locationManager.latitude, longitude: locationManager.longitude, zoom: zoom)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        var heatmapLayer: GMUHeatmapTileLayer!
        heatmapLayer = GMUHeatmapTileLayer()
        heatmapLayer.map = mapView
        addHeatmap(heatmapLayer: heatmapLayer)
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        //        let camera = GMSCameraPosition.camera(withLatitude: locationManager.latitude, longitude: locationManager.longitude, zoom: zoom)
        //        mapView.camera = camera
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: locationManager.latitude, longitude: locationManager.longitude))
    }
    
    func addHeatmap(heatmapLayer: GMUHeatmapTileLayer)  {
      var list = [GMUWeightedLatLng]()
      do {
        // Get the data: latitude/longitude positions of police stations.
        if let path = Bundle.main.url(forResource: "heatmap", withExtension: "json") {
          let data = try Data(contentsOf: path)
          let json = try JSONSerialization.jsonObject(with: data, options: [])
            print("heatmap printing")
          if let object = json as? [[String: Any]] {
            for item in object {
              let lat = item["lat"]
              let lng = item["lng"]
              let coords = GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(lat as! CLLocationDegrees, lng as! CLLocationDegrees), intensity: 1.0)
              list.append(coords)
            }
          } else {
            print("Could not read the JSON.")
          }
        }
      } catch {
        print(error.localizedDescription)
      }
      // Add the latlngs to the heatmap layer.
      heatmapLayer.weightedData = list
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
