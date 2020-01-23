//
//  Notes.swift
//  NotesApp
//
//  Created by Evneet kaur on 2020-01-22.
//  Copyright © 2020 Evneet kaur. All rights reserved.
//

import Foundation
import  PhotosUI
import MapKit

class Note{
    internal init(title: String, desc: String, image: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees, date: Date) {
        self.title = title
        self.desc = desc
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
    }
    
    var title :String
    var desc: String
    var image: UIImage
    var latitude: CLLocationDegrees
    var longitude : CLLocationDegrees
    var date : Date
    
}
