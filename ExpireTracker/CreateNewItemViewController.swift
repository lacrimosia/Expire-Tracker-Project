//
//  CreateNewItemViewController.swift
//  ExpireTracker
//
//  Created by Shatilla Prayer on 3/13/21.
//

import UIKit

class CreateNewItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var itemNameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var plusMinusButton: UIStepper!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var quantityTextField: UILabel!
    var quantityValue : Int16 = 1
    
    var pickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerController.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            photoImageView.image = selectedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func openExistingPhoto(_ sender: Any) {
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func updateQuantity(_ sender: UIStepper) {
        sender.minimumValue = 1
        quantityValue = Int16(sender.value)
        quantityTextField.text = String(quantityValue)
    }

    // save new items to core data
    @IBAction func saveItem(_ sender: Any) {
        if(itemNameField.text!.isEmpty){
            let alert = UIAlertController(title: "Error", message: "Please enter a name for your item. This is required.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let item = FoodItem(context: context)
                item.name = itemNameField.text
                item.date = datePicker.date
                item.image = photoImageView.image?.jpegData(compressionQuality: 1.0)
                item.quantity = quantityValue
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            }
            
            navigationController?.popViewController(animated: true)
        }
    }
}
