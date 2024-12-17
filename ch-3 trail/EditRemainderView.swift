//
//  EditRemainderView.swift
//  ch-3 trail
//
//  Created by Rahul Reddy Karri on 17/12/24.
//



import SwiftUI

// MARK: - Edit Reminder View
struct EditReminderView: View {
    let item: String
    @State var date: Date
    @Binding var reminders: [String: Date]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Edit Reminder for \(item)")
                    .font(.headline)
                    .padding()

                DatePicker(
                    "Reminder Date & Time",
                    selection: $date,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()

                Button(action: {
                    reminders[item] = date // Update the reminder
                    dismiss()
                }) {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                Button(action: {
                    reminders.removeValue(forKey: item) // Delete the reminder
                    dismiss()
                }) {
                    Text("Delete Reminder")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .navigationTitle("Edit Reminder")
            .navigationBarItems(trailing: Button("Close") {
                dismiss()
            })
        }
    }
}




