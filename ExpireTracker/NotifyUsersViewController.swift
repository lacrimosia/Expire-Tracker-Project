//
//  NotifyUsersViewController.swift
//  ExpireTracker
//
//  Created by Shatilla Prayer on 3/14/21.
//

import UserNotifications
import UIKit


class NotifyUsersViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var enableSwitchButton: UISwitch!
    
    // get the data from the current items
    var updates: [FoodItem] = []
    var notif: [Notify] = []
    var isNotifEnabled : Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(notif.isEmpty){
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let initalSetup = Notify(context: context)
                initalSetup.notifyEnabled = true
                isNotifEnabled = initalSetup.notifyEnabled
                
                notif.append(initalSetup)
                print("yes this is empty - \(notif)")
                enableSwitchButton.isOn = isNotifEnabled
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            }
        }
        
        getCoreDataInfo()
        
        // fetch to see if core data notify enabled
        // enable notifications
        // enable permission for notifications
//        let center = UNUserNotificationCenter.current()
//
//        // notification content
//        let content = UNMutableNotificationContent()
//        content.title = "Expire Tracker Alert"
//        content.body = "Your item is expiring soon..."
//        content.sound = UNNotificationSound.default
//
//
//        // create the notification trigger
//        let date = Date(timeIntervalSinceNow: 5)
//        print(date)
//        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//
//        // calendar trigger
//        let triggerRequest = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
//
//        // create notification request
//        let uuid = UUID().uuidString
//        //let identifier = "foodItemNotifications"
//        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: triggerRequest)
//
//        center.add(request) { (error) in
//           if error != nil {
//              // Handle any errors.
//           }
//        }
    }
    

    func getCoreDataInfo() {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let coreDataFoodUpdates = try? context.fetch(FoodItem.fetchRequest()) as? [FoodItem] {
                updates = coreDataFoodUpdates
            }
        }
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let coreDataNotifyUpdates = try? context.fetch(Notify.fetchRequest()) as? [Notify] {
                notif = coreDataNotifyUpdates
                isNotifEnabled = notif[0].notifyEnabled
                enableSwitchButton.isOn = isNotifEnabled
            }
        }
    }
    @IBAction func enableNotifications(_ sender: UISwitch) {
        // Save the switch settings to core data
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let item = Notify(context: context)
            item.notifyEnabled = sender.isOn
            isNotifEnabled = item.notifyEnabled
            notif[0].notifyEnabled = isNotifEnabled
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        }
        
        if(isNotifEnabled == false){
            // disable
           // UNUserNotificationCenter.current().removeAllDeliveredNotifications()
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
}
