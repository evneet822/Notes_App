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
    
    
    
    @IBOutlet weak var minslbl: UILabel!
    @IBOutlet weak var counterlbl: UILabel!
    @IBOutlet weak var edittimelbl: UILabel!
    @IBOutlet weak var editdatelbl: UILabel!
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
//    var recordUrl : URL?
    var player:AVAudioPlayer?
    var audioFilename : URL?
    var counter = 0
    var mins = 0
    var timer = Timer()

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
//        converteditDate(date: (noteDetail?.editeddate)!)
        lat = noteDetail?.latitude
        long = noteDetail?.longitude
        createdDate = noteDetail?.date
            titletxt.isUserInteractionEnabled = false
            
            if noteDetail?.image != nil{
                image_view.image = noteDetail?.image
                imageSelected = noteDetail?.image
            }
            if noteDetail?.recordedUrl != nil{
                audioFilename = noteDetail!.recordedUrl
//                print("\(noteDetail?.recordedUrl)")
                print(" saved file \(audioFilename!)")
//                let path = audioFilename?.path
                recordLbl.setTitle("Play", for: .normal)
//                let s = recordUrl!.absoluteString
//                print(s)
            }
            if noteDetail?.editeddate != nil{
                converteditDate(date: (noteDetail?.editeddate)!)
            }
            
            
            
          }
        
        counterlbl.text = "\(counter)"
        minslbl.text = "\(mins)."
        
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
                if imageSelected != nil && audioFilename == nil{
                    let title = titletxt.text
                    let desc = desctxt.text
                        
//                    let nimage = Note(title: title!, desc: desc!, latitude: lat!, longitude: long!, date: Date(), image: imageSelected!)
                    if objectSelected{
                        
//                        noteDetail = Note(title: title!, desc: desc!, latitude: lat!, longitude: long!, date: createdDate!, image: imageSelected!)
                        
                        noteDetail = Note(title: title!, desc: desc!, latitude: lat!, longitude: long!, date: createdDate!, image: imageSelected!, editdate: Date())
                        CategoryModel.categoryData[notesDelegate!.notesCurrentIndx].notes[notesDelegate!.notesSelectedIndex] = noteDetail!
                    }else{
                    noteDetail = Note(title: title!, desc: desc!, latitude: lat!, longitude: long!, date: Date(), image: imageSelected!)
                        CategoryModel.categoryData[notesDelegate!.notesCurrentIndx].notes.append(noteDetail!)
                    }
            
                }else if audioFilename != nil && imageSelected == nil{
                    let t = titletxt.text
                    let d = desctxt.text
                               
//                    let nr = Note(title: t!, desc: d!, latitude: lat!, longitude: long!, date: Date(), record: recordUrl!)
                    
                    if objectSelected{
                        
//                        noteDetail = Note(title: t!, desc: d!, latitude: lat!, longitude: long!, date: createdDate!, record: audioFilename!);
                        
                       noteDetail = Note(title: t!, desc: d!, latitude: lat!, longitude: long!, date: createdDate!, record: audioFilename!, editdate: Date())
                        CategoryModel.categoryData[notesDelegate!.notesCurrentIndx].notes[notesDelegate!.notesSelectedIndex] = noteDetail!
                        
                        
                    }else{
                        
                        noteDetail = Note(title: t!, desc: d!, latitude: lat!, longitude: long!, date: Date(), record: audioFilename!)
                    
                        CategoryModel.categoryData[notesDelegate!.notesCurrentIndx].notes.append(noteDetail!)
                    }
            
                }else if audioFilename == nil && imageSelected == nil{
                 let t1 = titletxt.text
                 let d1 = desctxt.text
                    
//                    let n1 = Note(title: t1!, desc: d1!, latitude: lat!, longitude: long!, date: Date())
                    
                    if objectSelected{
//                        noteDetail = Note(title: t1!, desc: d1!, latitude: lat!, longitude: long!, date: createdDate!)
                        
                        noteDetail = Note(title: t1!, desc: d1!, latitude: lat!, longitude: long!, date: createdDate!, editdate: Date())
                        CategoryModel.categoryData[notesDelegate!.notesCurrentIndx].notes[notesDelegate!.notesSelectedIndex] = noteDetail!
                    }else{
                         noteDetail = Note(title: t1!, desc: d1!, latitude: lat!, longitude: long!, date: Date())
                        CategoryModel.categoryData[notesDelegate!.notesCurrentIndx].notes.append(noteDetail!)
                    }
                    
                    
                }else {
                    let tt = titletxt.text
                    let dd = desctxt.text
                               
//                    let nn = Note(title: tt!, desc: dd!, image: imageSelected!, latitude: lat!, longitude: long!, date: Date(), recordedUrl: recordUrl!)
                    
                    if objectSelected{
                        
//                        noteDetail = Note(title: tt!, desc: dd!, image: imageSelected!, latitude: lat!, longitude: long!, date: createdDate!, recordedUrl: audioFilename!)
                        
                        
                        noteDetail = Note(title: tt!, desc: dd!, image: imageSelected!, latitude: lat!, longitude: long!, date: createdDate!, recordedUrl: audioFilename!, editdate: Date())
                        
                        CategoryModel.categoryData[notesDelegate!.notesCurrentIndx].notes[notesDelegate!.notesSelectedIndex] = noteDetail!
                        
                    }else{
                        
                        noteDetail = Note(title: tt!, desc: dd!, image: imageSelected!, latitude: lat!, longitude: long!, date: Date(), recordedUrl: audioFilename!)
                        
                        CategoryModel.categoryData[notesDelegate!.notesCurrentIndx].notes.append(noteDetail!)
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
        datelbl.text = "created On: \(dateformatter.string(from: date))"
        timelbl.text = "time: \(hourformatter.string(from: date))"
        
        
    }
    
    func converteditDate(date : Date) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "EEE, MMM,dd"
        let hourformatter = DateFormatter()
        hourformatter.dateFormat = "h:mm a"
        editdatelbl.text = "last edidted: \(dateformatter.string(from: date))"
        edittimelbl.text = "time: \(hourformatter.string(from: date))"
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  let destination = segue.destination as? MapViewController{
            destination.notelatitude = lat
            destination.notelongitude = long
        }
    }
    
    @IBAction func recordAction(_ sender: UIButton) {

        audioFilename = getDocumentsDirectory().appendingPathComponent("\(titletxt.text!).m4a")
        if recordLbl.titleLabel?.text == "Record" {
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updatetimer), userInfo: nil, repeats: true)
             
            print(" created file \(audioFilename!)")
            startRecording()
            
            
        }else if recordLbl.titleLabel?.text == "Stop"{
            timer.invalidate()
            finishRecording(success: true)
        }else if recordLbl.titleLabel?.text == "Play"{
            do{
                
                player = try AVAudioPlayer(contentsOf: audioFilename!)
                player!.play()
            }catch{
                print("not played")
            }
        }
        

    }
    func startRecording() {
         
//        recordUrl = audioFilename
//        print("recording saved with file name \(recordUrl?.absoluteString)")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            
            print("recording started")
            audioRecorder = try AVAudioRecorder(url: audioFilename!, settings: settings)
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
//        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        if documentPath.count > 0 {
//            let documentDirectory = documentPath[0]
//            let filePath = documentDirectory.appending("/book.txt")
//            return filePath
//        }
//        return ""
    }
    
    
    func finishRecording(success: Bool) {
        print("recording ended")
        audioRecorder.stop()
        audioRecorder = nil
        recordLbl.setTitle("Record", for: .normal)

    }
    
    @objc func updatetimer() {
        counter = counter + 1
        counterlbl.text = "\(counter)"
        if counter == 60{
            mins = mins + 1
            minslbl.text = "\(mins)."
            counter = 0
        }
        
    }
    
   
}

