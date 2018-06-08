//
//  ImagenViewController.swift
//  Snapchat
//
//  Created by Mac Tecsup on 16/05/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import Firebase

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var elegirContactoBoton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ElegirUsuarioViewController
        siguienteVC.imagenURL = sender as! String
        siguienteVC.descrip = descripcionTextField.text!
        siguienteVC.imagenID = imagenID
        
    }
}















