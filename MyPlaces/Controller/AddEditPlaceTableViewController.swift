//
//  AddEditPlaceTableViewController.swift
//  MyPlaces
//
//  Created by Grace Toa on 24/10/18.
//  Copyright © 2018 Grace Toa. All rights reserved.
//  UITextFieldDelegate.- protocol le dice al compilador que puede acutar como un delegado de campo de texto válido, esto significa que puede implementar métodos de protocolo para manejar entrada de texto

import UIKit
import MapKit
import CoreLocation

class AddEditPlaceTableViewController: UIViewController,UITextFieldDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //MARK: Properties
    //instancia para añadir un nuevo place y pasarlo a FirstViewController
    var place: Place?
    
    @IBOutlet weak var checkImg: UIImageView!
    var img = false
  
    //MARK: IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var addLocationButton: UIButton!
    
    @IBOutlet weak var galeryButton: UIButton!
    //MARK: PickerController
    @IBOutlet weak var imgPickerView: UIImageView!
    
    //MARK: CLLocationCoordinate2D properties
    var latitudeMap: CLLocationDegrees! = 0.0
    var longitudeMap: CLLocationDegrees! = 0.0
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        
        //config style
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "titulB.png"))
        nameTextField.layer.borderColor = UIColor.gray.cgColor
        descriptionTextField.layer.borderColor = UIColor.gray.cgColor
        nameTextField.layer.borderWidth = 1.0
        descriptionTextField.layer.borderWidth = 1.0
        addLocationButton.layer.cornerRadius = 12
        galeryButton.layer.cornerRadius = 12
        
        // Configura vistas si se edita un place existente
        if let place = place {
            navigationItem.title = place.name
            nameTextField.text = place.name
            descriptionTextField.text = place.descriptionP
            let imgDefault =  ManagerPlaces.shared.loadImgTest()
            imgPickerView.image = UIImage(data: place.image ?? imgDefault )
            latitudeMap = place.coordinate.latitude
            longitudeMap = place.coordinate.longitude
        }

    }

    
    //MARK: UITextFieldDelegate
    
    //se llama a este método cuando comienza una sesión de edición.
    //Se desabilita el botón save mientras se edita el campo de texto
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    //indica si el sistema debe procesar la presión de la tecla Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //toma la información ingresada en el campo de texto y hace algo con ella
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
  
    
    //MARK: Actions buttons
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The FirstViewController is not inside a navigation controller.")
        }
    }
    
    //open Library local system
    @IBAction func btnPickerImg(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK: PickerController permisos info.plis
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imgPickerView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.imgPickerView.contentMode = .scaleAspectFill
        self.imgPickerView.clipsToBounds = true
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: methods privates
    //Método que permite configurar datos que enviar al source ViewController (FirstViewController)
    //se usa un unwind segue(done Button) que retrocede un segmento
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if (segue.identifier == "ShowLocation"){
            let bt = segue.destination as? LocationViewController
            bt?.buttonIsHidden = true
        }
        let nameP = nameTextField.text ?? ""
        let descP = descriptionTextField.text ?? ""
        let coordinate = CLLocationCoordinate2D(latitude: latitudeMap!, longitude: longitudeMap!)
        let imgData = imgPickerView.image?.pngData()
     
        //objeto place que se pasa a FirstViewController
        place = Place(name: nameP, descriptionP: descP, image_in: imgData, location: coordinate)
    }
    
    //Datos enviados desde MapViewController
    @IBAction func unwindFromMapViewController(sender: UIStoryboardSegue) {
         if let sourceViewController = sender.source as? LocationViewController{
            latitudeMap = sourceViewController.latitude
            longitudeMap = sourceViewController.longitude
            if img == false{
                self.checkImg.image = UIImage(named: "check.png")
            }
        }
    }
    
    //MARK: buttons helper
    //método auxiliar para activar el botón done si cumple los Enabled
    private func updateSaveButtonState(){
        //desactiva el boton guardar si el textField esta vacio
        let textD = descriptionTextField.text ?? ""
        let textN = nameTextField.text ?? ""
        saveButton.isEnabled = !textD.isEmpty
        saveButton.isEnabled = !textN.isEmpty
    }

    
}//end class

