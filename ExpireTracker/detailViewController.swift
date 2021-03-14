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
        
        if let imageData = foodItem?.image {
            photoImageView.image = UIImage(data: imageData)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    /*
     
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
