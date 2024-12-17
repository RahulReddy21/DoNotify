//
//  RemainderSetupView.swift
//  ch-3 trail
//
//  Created by Rahul Reddy Karri on 17/12/24.
//


import SwiftUI
import UserNotifications

struct ReminderSetupView: View {
    let item: String // List name or item name for the reminder
    @Binding var reminders: [String: Date] // Binding to save the reminder time
    @State private var selectedDate = Date() // State to store the selected reminder time
    @Environment(\.dismiss) var dismiss // For dismissing the view
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Set Reminder for \(item)")
                    .font(.headline)
                    .padding()
                
                // DatePicker: Restrict to future dates only
                DatePicker(
                    "Select Date and Time",
                    selection: $selectedDate,
                    in: Date()..., // Prevent past dates
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                
                // Save Reminder Button
                Button(action: {
                    requestNotificationPermission { granted in
                        if granted {
                            reminders[item] = selectedDate
                            scheduleNotification(for: item, at: selectedDate)
                            dismiss()
                        } else {
                            print("User denied notification permission.")
                        }
                    }
                }) {
                    Text("Save Reminder")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("Set Reminder")
            .navigationBarItems(trailing: Button("Close") {
                dismiss()
            })
        }
    }
    
    // Function to request notification permissions
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting permissions: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(granted)
            }
        }
    }
    
    // Function to schedule a notification
    func scheduleNotification(for item: String, at time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Hey, Reminder for \(item)!" // Include the list name dynamically
        content.sound = .default
        
        // Create a trigger for the specific date and time
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        // Create a notification request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // Add the request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully for \(item) at \(time).")
            }
        }
    }
}

