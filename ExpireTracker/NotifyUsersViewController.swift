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
    var notif : [Notify] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        // enable notifications
        // fetch to see if core data notify enabled
        let isNotifEnabled = notif[0].notifyEnabled
        print(isNotifEnabled)
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
