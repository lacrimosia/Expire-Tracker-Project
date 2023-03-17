//
//  CategoryTableViewController.swift
//  ExpireTracker
//
//  Created by Shatilla Prayer on 3/13/21.
//

import UIKit
import UserNotifications
import NotificationCenter;

class CategoryTableViewController: UITableViewController{
    
    // get the data
    var updates: [FoodItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 50
        getCoreDataInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCoreDataInfo()
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return updates.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryItem", for: indexPath)
        
        // Configure the cell...
        // cell index
        let foodItemUpdate = updates[indexPath.row]
        
        // show image in table
        if let imageData = foodItemUpdate.image {
            cell.imageView?.image = UIImage(data: imageData)
        }
        
        //cell.textLabel?.textColor = .
        cell.textLabel?.text = foodItemUpdate.name
        
        return cell
    }
    
    // this is to add the SWIPE delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // get current cell
            let foodUpdate = updates[indexPath.row]
            
            // get access to core data
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                context.delete(foodUpdate)
                getCoreDataInfo()
            }
        }
    }
    
    // onselection of the table row
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewFoodItemUpdate = segue.destination as? detailViewController{
            if let foodItem = sender as? FoodItem{
                viewFoodItemUpdate.foodItem = foodItem
            }
        }
    }
    
    // send the data to the detail view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let foodItem = updates[indexPath.row] 
        performSegue(withIdentifier: "detailsView", sender: foodItem)
    }
    
    
    // update the table data and reloads the table view
    func getCoreDataInfo() {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let coreDataFoodUpdates = try? context.fetch(FoodItem.fetchRequest()) as? [FoodItem] {
                updates = coreDataFoodUpdates
                tableView.reloadData()
                
                let center = UNUserNotificationCenter.current()
                
                if(!coreDataFoodUpdates.isEmpty){
                    for x in coreDataFoodUpdates{
                        let listDate = x.date! as Date
                        let nameTitle = x.name!.capitalized as String
                        
                        let content = UNMutableNotificationContent()
                        content.title = "Expire Tracker"
                        content.body = "🍎🍇🍔 \(nameTitle) is expiring today. Please consider throwing this item out."
                        content.sound = .default
                        
                        let fireDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: listDate)
                        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate, repeats: true)
                        
                        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
                        center.add(request) { (error) in
                            if error != nil {
                                print("Error = \(error?.localizedDescription ?? "error local notification")")
                            }
                        }
                    }
                }
                
                
            }
        }
    }
    
}
