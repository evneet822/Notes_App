//
//  Notes.swift
//  NotesApp
//
//  Created by Evneet kaur on 2020-01-22.
//  Copyright © 2020 Evneet kaur. All rights reserved.
//

import Foundation
import  PhotosUI

class Note{
     init(title: String, desc: String, image: UIImage, latitude: Double, longitude: Double, date: Date, recordedUrl: URL) {
        self.title = title
        self.desc = desc
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.recordedUrl = recordedUrl
    }
    
    init(title: String, desc: String, image: UIImage, latitude: Double, longitude: Double, date: Date, recordedUrl: URL , editdate : Date) {
        self.title = title
        self.desc = desc
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.recordedUrl = recordedUrl
        self.editeddate = editdate
    }
    
    init(title:String, desc: String, latitude: Double, longitude: Double,date : Date,image: UIImage) {
       self.title = title
       self.desc = desc
       self.latitude = latitude
       self.longitude = longitude
       self.date = date
        self.image = image
   }
    
    init(title:String, desc: String, latitude: Double, longitude: Double,date : Date,image: UIImage , editdate : Date) {
        self.title = title
        self.desc = desc
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
         self.image = image
        self.editeddate = editdate
    }
    
    
    
    init(title:String, desc: String, latitude: Double, longitude: Double,date : Date) {
        self.title = title
        self.desc = desc
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
    }
    
    init(title:String, desc: String, latitude: Double, longitude: Double,date : Date , editdate : Date) {
        self.title = title
        self.desc = desc
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.editeddate = editdate
    }
    
    init(title:String, desc: String, latitude: Double, longitude: Double,date : Date,record: URL) {
        self.title = title
        self.desc = desc
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.recordedUrl = record
    }
    init(title:String, desc: String, latitude: Double, longitude: Double,date : Date,record: URL,editdate : Date) {
        self.title = title
        self.desc = desc
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.recordedUrl = record
        self.editeddate = editdate
    }
    
    
    
    var title :String
    var desc: String
    var image: UIImage?
    var latitude: Double
    var longitude : Double
    var date : Date
    var recordedUrl : URL?
    var editeddate : Date?

    
//    static var notesdata = [Note]()
    
}
