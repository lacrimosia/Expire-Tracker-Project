//
//  NotifyUsersViewController.swift
//  ExpireTracker
//
//  Created by Shatilla Prayer on 3/14/21.
//

import UIKit
import UserNotifications

class NotifyUsersViewController: UIViewController {
    
    @IBOutlet weak var enableSwitchButton: UISwitch!
    
    // get the data from the current items
    var updates: [FoodItem] = []
    var notif: [Notify] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(notif.isEmpty){
            print("yes this is empty")
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let initalSetup = Notify(context: context)
                initalSetup.notifyEnabled = false
                notif.append(initalSetup)
                enableSwitchButton.isOn = initalSetup.notifyEnabled
               (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            }
        }else{
            print("not empty \(notif)")
        }
        
        
        getCoreDataInfo()
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
                enableSwitchButton.isOn = notif[0].notifyEnabled
            }
        }
    }
    @IBAction func enableNotifications(_ sender: UISwitch) {
        // Save the switch settings to core data
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let item = Notify(context: context)
            item.notifyEnabled = sender.isOn
            notif[0].notifyEnabled = item.notifyEnabled
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            
        }
        
        // fetch to see if core data notify enabled
        let isNotifEnabled = notif[0].notifyEnabled
        
        // enable notifications
        if(isNotifEnabled){
            print("enabled button")
            // enable permission for notifications
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .sound, .alert, .carPlay,.announcement]) { (granted, error) in
                if error == nil{
                    print("User permission is granted for notifications - \(granted)")
                }
            }
        }
        
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
