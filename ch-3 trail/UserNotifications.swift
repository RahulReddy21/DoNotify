//
//  UserNotifications.swift
//  ch-3 trail
//
//  Created by Rahul Reddy Karri on 17/12/24.
//

import UserNotifications

// Call this function to request notification permissions
func requestNotificationPermissions() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if granted {
            print("Notification permission granted.")
        } else {
            print("Notification permission denied.")
        }
    }
}


