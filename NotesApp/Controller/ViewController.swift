//
//  ViewController.swift
//  NotesApp
//
//  Created by Evneet kaur on 2020-01-22.
//  Copyright © 2020 Evneet kaur. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,AVAudioRecorderDelegate{
    
    
    
    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var image_view: UIImageView!
    @IBOutlet weak var titletxt: UITextField!
    @IBOutlet weak var desctxt: UITextView!
    @IBOutlet weak var recordLbl: UIButton!
    var notesDelegate: NotesTableViewController?
    var imageSelected : UIImage?
    var noteDetail : Note?
    var createdDate : Date?
    var objectSelected = false
    var lat : CLLocationDegrees?
    var long : CLLocationDegrees?
    var imagePicker = UIImagePickerController()
    var locationManager = CLLocationManager()
    var viewIndex = -1
    var audioRecorder: AVAudioRecorder!
    var recordUrl : URL?
    var player:AVAudioPlayer?

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
        lat = noteDetail?.latitude
        long = noteDetail?.longitude
        createdDate = noteDetail?.date
            
            if noteDetail?.image != nil{
                image_view.image = noteDetail?.image
                imageSelected = noteDetail?.image
            }
            if noteDetail?.recordedUrl != nil{
                recordUrl = noteDetail?.recordedUrl
                recordLbl.setTitle("Play", for: .normal)
                let s = recordUrl?.absoluteString
                print(s!)
            }
            
            
            
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
        notesDelegate?.notesReload()
    }
   
    
    @IBAction func saveNote(_ sender: UIButton) {
        if titletxt.text == "" && desctxt.text == "description"{
            print("inside alert")
            let alert = UIAlertController(title: "Empty Feilds", message: "Please fill the required feilds", preferredStyle: .alert)
            print("after alert controller")
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            print("ok action")
            alert.addAction(okAction)
            print("ok action added")
            self.present(alert, animated: true, completion: nil)
            print("alert ended")
        }else{
            
            print("inside else")
                if imageSelected != nil && recordUrl == nil{
                    let title = titletxt.text
                    let desc = desctxt.text
                        
                    let nimage = Note(title: title!, desc: desc!, latitude: lat!, longitude: long!, date: Date(), image: imageSelected!)
                    if objectSelected{
                        CategoryModel.categoryData[notesDelegate!.notesSelectedIndex].notes[notesDelegate!.notesSelectedIndex] = nimage
                    }else{
                    
                        CategoryModel.categoryData[notesDelegate!.notesCurrentIndx].notes.append(nimage)
                    }
            
                }else if recordUrl != nil && imageSelected == nil{
                    let t = titletxt.text
                    let d = desctxt.text
                               
                    let nr = Note(title: t!, desc: d!, latitude: lat!, longitude: long!, date: Date(), record: recordUrl!)
                    
                    if objectSelected{
                        
                        CategoryModel.categoryData[notesDelegate!.notesSelectedIndex].notes[notesDelegate!.notesSelectedIndex] = nr
                        
                    }else{
                    
                        CategoryModel.categoryData[notesDelegate!.notesCurrentIndx].notes.append(nr)
                    }
            
                }else {
                    let tt = titletxt.text
                    let dd = desctxt.text
                               
                    let nn = Note(title: tt!, desc: dd!, image: imageSelected!, latitude: lat!, longitude: long!, date: Date(), recordedUrl: recordUrl!)
                    
                    if objectSelected{
                        
                        CategoryModel.categoryData[notesDelegate!.notesSelectedIndex].notes[notesDelegate!.notesSelectedIndex] = nn
                        
                    }else{
                        CategoryModel.categoryData[notesDelegate!.notesCurrentIndx].notes.append(nn)
                   }
             }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  let destination = segue.destination as? MapViewController{
            destination.notelatitude = lat
            destination.notelongitude = long
        }
    }
    
    @IBAction func recordAction(_ sender: UIButton) {
        
        if recordLbl.titleLabel?.text == "Record" {
            startRecording()
        }else if recordLbl.titleLabel?.text == "Stop"{
            finishRecording(success: true)
        }else if recordLbl.titleLabel?.text == "Play"{
            do{
                player = try AVAudioPlayer(contentsOf: recordUrl!)
                player?.play()
            }catch{
                print("not played")
            }
        }
        

    }
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("\(titletxt.text).m4a")
        recordUrl = audioFilename
        print("recording saved with file name \(recordUrl?.absoluteString)")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            
            print("recording started")
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recordLbl.setTitle("Stop", for: .normal)

        } catch {
            finishRecording(success: false)
        }
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    func finishRecording(success: Bool) {
        print("recording ended")
        audioRecorder.stop()
        audioRecorder = nil
        recordLbl.setTitle("Record", for: .normal)

    }
    
   
}

