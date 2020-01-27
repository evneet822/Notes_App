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
//    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var count = 0
    var recordUrl : URL?
    var player:AVAudioPlayer?
    var playerItem:AVPlayerItem?

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
            recordUrl = noteDetail?.recordedUrl
            recordLbl.setTitle("Play", for: .normal)
            let s = recordUrl?.absoluteString
            print(s!)
            
//            let playerItem:AVPlayerItem = AVPlayerItem(url: recordUrl!)
//            player = AVPlayer(playerItem: playerItem)
//
//            let playerLayer=AVPlayerLayer(player: player!)
//            playerLayer.frame=CGRect(x:0, y:0, width:10, height:30)
//            self.view.layer.addSublayer(playerLayer)
            
        
        }
        
//        recordingSession = AVAudioSession.sharedInstance()
//
//        do {
//            try recordingSession.setCategory(.playAndRecord, mode: .default)
//            try recordingSession.setActive(true)
//            recordingSession.requestRecordPermission() { [unowned self] allowed in
//                DispatchQueue.main.async {
//                    if allowed {
//                        print("allow")
////                        self.loadRecordingUI()
//                    } else {
//                        // failed to record!
//                    }
//                }
//            }
//        } catch {
//            // failed to record!
//        }
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
               
                       let n = Note(title: title!, desc: desc!, image: imageSelected!, latitude: lat!, longitude: long!, date: createdDate!, recordedUrl: recordUrl!)
            notesDelegate?.notesCurrentIndx = viewIndex
                       notesDelegate?.updateNotes(note: n)
        }else{
        
            let title = titletxt.text
            let desc = desctxt.text
//            print(lat,long)
//        print(imageSelected?.size)
    
            let n = Note(title: title!, desc: desc!, image: imageSelected!, latitude: lat!, longitude: long!, date: Date(),recordedUrl: recordUrl!)
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
        
//        if audioRecorder == nil{
//            startRecording()
//        }else{
//            finishRecording(success: true)
//        }
        
    }
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("\(titletxt.text).m4a")
        recordUrl = audioFilename

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

//            recordButton.setTitle("Tap to Stop", for: .normal)
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

//        if success {
//            recordButton.setTitle("Tap to Re-record", for: .normal)
//        } else {
//            recordButton.setTitle("Tap to Record", for: .normal)
//            // recording failed :(
//        }
    }
    
}

