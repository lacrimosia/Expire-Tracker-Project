//
//  CategoryTableViewController.swift
//  ExpireTracker
//
//  Created by Shatilla Prayer on 3/13/21.
//

import UIKit
import UserNotifications

class CategoryTableViewController: UITableViewController{
    
    // get the data
    var updates: [FoodItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCoreDataInfo()
        
        // fetch to see if core data notify enabled
        // enable notifications
        // Assign the delegate
        
        // For enabled notifications
        //        let center = UNUserNotificationCenter.current()
        //        //center.delegate = self
        //
        //        // notification content
        //        let content = UNMutableNotificationContent()
        //        content.title = "Expire Tracker Alert"
        //        content.body = "Your item is expiring soon..."
        //        content.sound = UNNotificationSound.default
        
        // create the notification trigger
        //let date = Date().addingTimeInterval(65)
        // let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        // calendar trigger
        // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        // test
        //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        //
        //        // create notification request
        //        let uuid = UUID().uuidString
        //        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        //        center.add(request)
        //        center.add(request, withCompletionHandler:  {(error) in
        //            if error != nil{
        //                print("Error = \(error?.localizedDescription ?? "error local notification")")
        //            }
        //        })
        
        
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
                
                let content = UNMutableNotificationContent()
                content.title = "Expire Tracker notification"
                content.body = "This is an example of the notification expiration"
                content.sound = .default
                content.userInfo = ["value": "Data with local notification"]
                
                var date = Date().addingTimeInterval(5)
                
                if(!coreDataFoodUpdates.isEmpty){
                    print("not empty")
                    date = coreDataFoodUpdates[1].date! as Date
                }
                
                let fireDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate, repeats: false)
                //UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
                
                let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
                center.add(request) { (error) in
                    if error != nil {
                        print("Error = \(error?.localizedDescription ?? "error local notification")")
                    }
                }
            }
        }
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
