//
//  NOtificationsWIthEditOrDelete.swift
//  ch-3 trail
//
//  Created by Rahul Reddy Karri on 17/12/24.
//

import SwiftUI
import SwiftUICore

// MARK: - Notifications View with Edit/Delete
struct NotificationsView: View {
    @Binding var reminders: [String: Date]
    @State private var selectedItem: String? = nil
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                ForEach(reminders.keys.sorted(), id: \.self) { key in
                    VStack(alignment: .leading) {
                        Text(key)
                            .font(.headline)
                        Text("\(reminders[key]!, style: .date) at \(reminders[key]!, style: .time)")
                            .foregroundColor(.gray)
                    }
                    .onLongPressGesture {
                        selectedItem = key
                        selectedDate = reminders[key] ?? Date()
                        showDatePicker = true
                    }
                }
            }
            .sheet(isPresented: $showDatePicker) {
                if let selectedItem = selectedItem {
                    EditReminderView(
                        item: selectedItem,
                        date: selectedDate,
                        reminders: $reminders
                    )
                }
            }
            .navigationTitle("Reminders")
            .navigationBarItems(trailing: Button("Close") {
                dismiss()
            })
        }
    }
}



