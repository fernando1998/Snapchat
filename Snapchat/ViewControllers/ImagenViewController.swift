//
//  ImagenViewController.swift
//  Snapchat
//
//  Created by Mac Tecsup on 16/05/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var elegirContactoBoton: UIButton!
    @IBOutlet weak var grabarAudioBoton: UIButton!
    
    
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    var audioID = NSUUID().uuidString
    
    //variables para la implementación del audio
    var audioRecorder : AVAudioRecorder?
    var audioURL: URL?
    var audioPlayer : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        imagePicker.delegate = self
        elegirContactoBoton.isEnabled = false
        elegirContactoBoton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        elegirContactoBoton.alpha = 0.5
        elegirContactoBoton.layer.cornerRadius = 13
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        imagePicker.dismiss(animated: true, completion: nil)
        elegirContactoBoton.isEnabled = true
        elegirContactoBoton.alpha = 1
        self.elegirContactoBoton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func elegirContactoTapped(_ sender: Any) {
        elegirContactoBoton.isEnabled = false
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let audiosFolder = Storage.storage().reference().child("audios")
        let audioData = NSData(contentsOf: audioURL!)! as Data
        audiosFolder.child("\(audioID).mp4").putData(audioData, metadata: nil) {(metadata, error) in
            self.elegirContactoBoton.isEnabled = true
            
            if error != nil {
                
            } else {
                let audio = (metadata?.downloadURL()!.absoluteString)!
                self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: audio)
            }
        }
        
        let imagenData = UIImageJPEGRepresentation(imageView.image!, 0.1)!
        imagenesFolder.child("\(imagenID).jpg").putData(imagenData, metadata: nil) { (metadata, error) in
            self.elegirContactoBoton.isEnabled = true
            
            if error != nil {
                
            } else {
                let imagen = (metadata?.downloadURL()!.absoluteString)!
                self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: imagen)
            }
        }
    }
    
    func setupRecorder(){
        do{
            //creando una sesión de audio
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //creando una dirección para el archivo audio
            //_ = Storage.storage().reference().child("audios")
            
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath,"audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            print("*********************")
            print(audioURL!)
            print("*********************")
            
            //Crear opciones para el grabador de audio
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            //Crear el objeto de grabación de audio
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()

        }catch let error as NSError{
            print(error)
        }
    }
    
    @IBAction func grabarTapped(_ sender: Any) {
        if audioRecorder!.isRecording{
            //Detener Grabación
            audioRecorder?.stop()
            //Cambiar el texto el boton grabar
            grabarAudioBoton.setTitle("Record", for: .normal)
            
        }
        else{
            //empezar a grabar
            audioRecorder?.record()
            //Cambiar el titulo del boton detener
            grabarAudioBoton.setTitle("Stop", for: .normal)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ElegirUsuarioViewController
        siguienteVC.imagenURL = sender as! String
        siguienteVC.audioURL = sender as! String
        siguienteVC.descrip = descripcionTextField.text!
        siguienteVC.imagenID = imagenID
        siguienteVC.audioID = audioID
        
    }
}















