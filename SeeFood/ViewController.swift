//
//  ViewController.swift
//  SeeFood
//
//  Created by Dhruv Shah on 2020-06-22.
//  Copyright © 2020 Dhruv Shah. All rights reserved.
//

import UIKit
import CoreML
import Vision //help proccess images and use images with CoreML


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera //creates the camera as the image picker
        imagePicker.allowsEditing = true // allows the user to crop the image
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //make sure image is picked we have acces of the image they picked
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            //change to CI Image to use Vission and CoreML
            //use guard statement to avoid errors where UI Image can not convert into CI Image
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CI Image")
            }
            detect(image: ciImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    //using ML Model
    func detect(image: CIImage){
        //model = the model used to clasify the image
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model)else {
            fatalError("Loading CoreML Model Failed...") //allows the app to exit
        }
        
        //will only happen if model is not nill
        let request = VNCoreMLRequest(model: model) { (request, error) in
            //process the results of the requests
            let results = request.results as? [VNClassificationObservation]
            print(results ?? "No Value")
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        }catch{
            print("Error")
        }
        
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
}

