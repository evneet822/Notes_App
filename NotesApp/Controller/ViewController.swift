//
//  ViewController.swift
//  NotesApp
//
//  Created by Evneet kaur on 2020-01-22.
//  Copyright © 2020 Evneet kaur. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate{
    
    
    
    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var image_view: UIImageView!
    @IBOutlet weak var titletxt: UITextField!
    @IBOutlet weak var desctxt: UITextView!
    var notesDelegate: NotesTableViewController?
    var imageSelected : UIImage?
    var noteDetail : Note?
    var createdDate : Date?
    var objectSelected = false
    var lat : CLLocationDegrees?
    var long : CLLocationDegrees?
    var imagePicker = UIImagePickerController()
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if objectSelected{
        
        titletxt.text = noteDetail?.title
        desctxt.text = noteDetail?.desc
        convertDate(date: (noteDetail?.date)!)
        image_view.image = noteDetail?.image
            lat = noteDetail?.latitude
            long = noteDetail?.longitude
            imageSelected = noteDetail?.image
            createdDate = noteDetail?.date
            
        
        }
        
        
    }
    
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageSelected = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        image_view.image = imageSelected
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userlocation : CLLocation =  locations[0]
        if !objectSelected{
            lat = userlocation.coordinate.latitude
            long = userlocation.coordinate.longitude
        }
        
    }
   
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if objectSelected{
            let title = titletxt.text
                       let desc = desctxt.text
//                       print(lat,long)
//                   print(imageSelected?.size)
               
                       let n = Note(title: title!, desc: desc!, image: imageSelected!, latitude: lat!, longitude: long!, date: createdDate!)
                       notesDelegate?.updateNotes(note: n)
        }else{
        
            let title = titletxt.text
            let desc = desctxt.text
//            print(lat,long)
//        print(imageSelected?.size)
    
            let n = Note(title: title!, desc: desc!, image: imageSelected!, latitude: lat!, longitude: long!, date: Date())
            notesDelegate?.updateNotes(note: n)
        
        }
    }
    


    @IBAction func chooseImage(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func convertDate(date : Date) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "EEE, MMM,dd"
        let hourformatter = DateFormatter()
        hourformatter.dateFormat = "h:mm a"
        datelbl.text = dateformatter.string(from: date)
        timelbl.text = hourformatter.string(from: date)
        
    }
}

