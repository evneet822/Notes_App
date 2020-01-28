//
//  MapViewController.swift
//  NotesApp
//
//  Created by Evneet kaur on 2020-01-23.
//  Copyright © 2020 Evneet kaur. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    var notelatitude : CLLocationDegrees?
    var notelongitude : CLLocationDegrees?
    var locationmanager = CLLocationManager()
    var detailDelegate : ViewController?
    var  destination : CLLocationCoordinate2D?
    var usersource : CLLocationCoordinate2D?
    
    @IBOutlet weak var mapview: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

      
        let latDelta: CLLocationDegrees = 60.0
        let longDelta: CLLocationDegrees = 60.0
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let location = CLLocationCoordinate2D(latitude: notelatitude!, longitude: notelongitude!)
        destination = location
        let region = MKCoordinateRegion(center: location, span: span)
        mapview.setRegion(region, animated: true)
        mapview.delegate = self
        
        let annotation = MKPointAnnotation()
        annotation.title = "Note saved"
        annotation.coordinate = location
        mapview.addAnnotation(annotation)
        
        locationmanager.delegate = self
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.startUpdatingLocation()
        
//        let source = mapview.annotations[0].coordinate
        
        print("view did load")
        

    }

//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//
//        print("renderer")
//
//
//            let renderer = MKPolylineRenderer(overlay: overlay)
//            renderer.strokeColor = UIColor.red
//            renderer.lineWidth = 4.0
//
//                       return renderer
//
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        detailDelegate?.objectSelected = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("location manager")
        let userlocation : CLLocation = locations[0]
        
        let lat = userlocation.coordinate.latitude
        let long = userlocation.coordinate.longitude
        usersource = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func route(_ sender: UIButton) {
        
        print("show route")
        
        let source = usersource
//        let source = CLLocationCoordinate2D(latitude: 43.683334, longitude: -79.766670)
        //
        //
                                      let sourceplacemark = MKPlacemark(coordinate: source!)
                                      let destinationplacemark = MKPlacemark(coordinate: destination!)

                                      let sourceMapItem = MKMapItem(placemark: sourceplacemark)
                                      let destinationMapItem = MKMapItem(placemark: destinationplacemark)


                                      let directionRequest = MKDirections.Request()
                                      directionRequest.source = sourceMapItem
                                      directionRequest.destination = destinationMapItem
                directionRequest.transportType = .automobile

                 let directions = MKDirections(request: directionRequest)

                                       directions.calculate { (response, error) in
                                           guard let response = response else{
                                               if let error = error{
                                                let alert = UIAlertController(title: "OOPS", message: "Directions not available", preferredStyle: .alert)
                                                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                                alert.addAction(okAction)
                                                self.present(alert, animated: true, completion: nil)
                                                   print("Error: \(error)")
                                               }
                                               return
                                           }

                                           print("in calculate")

                                           let route = response.routes[0]
//                                        let ov = route.polyline
                                        self.mapview.addOverlay(route.polyline)
//                                        self.mapview.addOverlay((route.polyline))
//                                           self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
                                           print("add overlay")

//                                           let rect = route.polyline.boundingMapRect
//                                           self.mapview.setRegion(MKCoordinateRegion(rect), animated: true)
//                                           print("set region")

                                       }

    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        print("renderer")
        if overlay is MKPolyline{
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .red
        renderer.lineWidth = 4.0
        return renderer
        }
    return MKOverlayRenderer()
    }
}
