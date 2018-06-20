//
//  VerSnapViewController.swift
//  Snapchat
//
//  Created by Mac Tecsup on 30/05/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import AVFoundation
class VerSnapViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var btnReproducir: UIButton!
    
    var audioPlayer : AVAudioPlayer?
    var snap = Snap()
    var destinationUrl = URL(string: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnReproducir.layer.cornerRadius = 10
        label.text? = snap.descrip
        imageView.sd_setImage(with: URL(string: snap.imagenURL))
        btnReproducir.isHidden = true
        downloadFileFromURL(url: URL(string: snap.audioURL)!)
    }
    
    @IBAction func reproducirTapped(_ sender: Any) {
        play(url: destinationUrl!)
    }
    override func viewWillDisappear(_ animated: Bool) {
//        Database.database().reference().child("usuarios").child(Auth.auth().currentUser!.uid).child("snaps").child(snap.id).removeValue()
//
//        Storage.storage().reference().child("imagenes").child("\(snap.imagenID).jpg").delete{(error) in
//            print("Se eliminó la imagen correctamente ;)")
//        }
    }
    func downloadFileFromURL(url:URL){
        URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
            guard let location = location, error == nil else { return }
            do {
                let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                self.destinationUrl = documentsDirectoryURL.appendingPathComponent(self.snap.audioID)
                try FileManager.default.moveItem(at: location, to: self.destinationUrl!)
                print("File moved to documents folder")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.btnReproducir.isHidden = false
            }
        }).resume()
    }
    
    func play(url: URL) {
        do {
            if audioPlayer == nil {
                self.audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.delegate = self
            }
            if audioPlayer!.isPlaying {
                audioPlayer?.pause()
                btnReproducir.setTitle("Reproducir", for: .normal)
            } else {
                audioPlayer?.prepareToPlay()
                audioPlayer?.volume = 1.0
                audioPlayer?.play()
                btnReproducir.setTitle("Pausar", for: .normal)
            }
        } catch let error as NSError {
            print(error.description)
        } catch {
            print( "Ocurrio un error al intentar reproducir el audio")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        btnReproducir.setTitle("Reproducir", for: .normal)
    }
    

    
}
