//
//  detailViewController.swift
//  ExpireTracker
//
//  Created by Shatilla Prayer on 3/13/21.
//

import UIKit

class detailViewController: UIViewController {

    @IBOutlet weak var quantityField: UILabel!
    @IBOutlet weak var dateField: UILabel!
    @IBOutlet weak var itemFieldName: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    var quan : Int16 = 0;
    var foodItem : FoodItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = foodItem?.name
        itemFieldName.text = foodItem?.name
        quan = foodItem?.quantity ?? 0
        quantityField.text = String(quan)
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY h:m a"
        dateFormatter.locale = Locale(identifier: "en_US")
        let foodItemDate = dateFormatter.string(from: foodItem?.date ?? currentDate)
        
        dateField.text = foodItemDate
        
        if let imageData = foodItem?.image {
            photoImageView.image = UIImage(data: imageData)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
}
