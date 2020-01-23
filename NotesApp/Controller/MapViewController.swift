//
//  MapViewController.swift
//  NotesApp
//
//  Created by Evneet kaur on 2020-01-23.
//  Copyright © 2020 Evneet kaur. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,CLLocationManagerDelegate {
    
    var notelatitude : CLLocationDegrees?
    var notelongitude : CLLocationDegrees?
    var locationmanager = CLLocationManager()
    var detailDelegate : ViewController?
    
    @IBOutlet weak var mapview: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

      
        let latDelta: CLLocationDegrees = 10.0
        let longDelta: CLLocationDegrees = 10.0
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let location = CLLocationCoordinate2D(latitude: notelatitude!, longitude: notelongitude!)
        let region = MKCoordinateRegion(center: location, span: span)
        mapview.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = "brampton City"
        annotation.subtitle = "City of Dreams"
        annotation.coordinate = location
        mapview.addAnnotation(annotation)
        
        locationmanager.delegate = self
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.startUpdatingLocation()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        detailDelegate?.objectSelected = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
