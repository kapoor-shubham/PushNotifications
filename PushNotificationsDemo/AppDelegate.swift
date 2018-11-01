//
//  AppDelegate.swift
//  PushNotificationsDemo
//
//  Created by Shubham Kapoor on 31/10/18.
//  Copyright © 2018 Shubham Kapoor. All rights reserved.
//

import UIKit
import UserNotifications

// Constants
var defaults = UserDefaults.standard
var notificationList = "NotificationList"
//

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var badgeCount = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        registerForPushNotifications()
        notificationPresentInCenter()   // Get Notification Data whenever App is Launched
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        notificationPresentInCenter()
    }
    
    ///  Register Push Notification
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        UIApplication.shared.applicationIconBadgeNumber = badgeCount+1
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    /// Checks if notification is present in Notification Center.
    func notificationPresentInCenter() {
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.getDeliveredNotifications { (delivered) in
            
            var previousNotificationsArray = defaults.stringArray(forKey: notificationList)
            for i in 0..<delivered.count {
                previousNotificationsArray?.append(delivered[i].request.content.body)
            }
            
            defaults.set(previousNotificationsArray, forKey: notificationList)
            center.removeAllDeliveredNotifications()    // Deletes Notifications From Notification Center
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Called when App is in Forground Running State.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        var presentNotificationList = defaults.stringArray(forKey: notificationList)
        presentNotificationList?.append(notification.request.content.body)
        defaults.set(presentNotificationList, forKey: notificationList)
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        
        completionHandler([.alert, .badge, .sound])
    }
    
    // Called when user taps on Notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.content.body)
    }
}

