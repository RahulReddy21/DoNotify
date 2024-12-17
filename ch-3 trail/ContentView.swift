//
//  ContentView.swift
//  ch-3 trail
//
//  Created by Rahul Reddy Karri on 16/12/24.
//

//
//import SwiftUI
//import UserNotifications
//
//struct ContentView: View {
//    @State private var items = ["Item 1", "Item 2", "Item 3"] // List items
//    @State private var reminders: [String: Date] = [:]        // Dictionary to store reminders
//    @State private var notes: [String: String] = [:]          // Dictionary to store notes for each item
//    @State private var showReminderSetup = false              // Toggle to show reminder setup view
//    @State private var showNotifications = false              // Toggle to show all reminders
//    @State private var showNotesModal = false                 // Toggle to show notes modal
//    @State private var showEditItemModal = false              // Toggle to show edit item modal
//    @State private var selectedItem: String? = nil            // Track selected item
//    @State private var actionSheetPresented = false           // Action sheet for edit/delete options
//    
//    var body: some View {
//        NavigationView{
//            VStack {
//                // Custom Navigation Bar
//                HStack {
//                    // Custom Logo Instead of Home Icon
//                      Image("CALC") // Use the name of your logo in Assets
//                          .resizable()
//                          .background(Color.gray.opacity(0.2))
//                          .scaledToFit()
//                          .frame(width: 30, height: 30) // Adjust the size to fit your navigation bar
//                          .clipShape(Circle())
//                          .overlay(
//                                    Circle()
//                                    .stroke(Color.gray, lineWidth: 1) // Optional border
//                            )
//                            .shadow(radius: 2) // Optional shadow
//                    Spacer()
//                    TextField("Search...", text: .constant(""))
//                        .padding(8)
//                        .background(Color(.systemGray6))
//                        .cornerRadius(10)
//                        .frame(maxWidth: .infinity)
//                    Spacer()
//                    // Notification Bell Button
//                    Button(action: {
//                        showNotifications = true
//                    }) {
//                        Image(systemName: "bell.fill")
//                            .font(.title2)
//                            .foregroundColor(.blue)
//                    }
//                }
//                .padding()
//                .background(Color(.systemGray5))
//
//                // List of Items
//                List {
//                  
//                    Section(header: Text("My Folder").font(.headline)) {
//                        ForEach(items, id: \.self) { item in
//                            HStack {
//                                
//                                Text(item)
//                                    .padding(.horizontal,10)
//                                    .padding(.vertical,4)
//                                    .cornerRadius(10)
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    .background(Color.white) // Background color
//                                    .cornerRadius(12) // Rounded corners
//                                
//                                    .onTapGesture {
//                                        selectedItem = item
//                                        showNotesModal = true
//                                    }
//                                    .onLongPressGesture {
//                                        selectedItem = item
//                                        actionSheetPresented = true
//                                    }
//                                
//                                Spacer()
//                                
//                                // Bell Icon to Open Reminder Setup
//                                Button(action: {
//                                    selectedItem = item
//                                    showReminderSetup = true
//                                })
//                                {
//                                    Image(systemName: "bell.fill")
//                                        .foregroundColor(.blue)
//                                }
//                            }
//                        }
//                    }
//                }
//                .listStyle(PlainListStyle())
//                .padding(.horizontal,10)
//                
//                
//               
//                
//
//                Spacer()
//
//                // Plus Button at the Bottom
//                Button(action: {
//                    selectedItem = nil // Add mode
//                    showEditItemModal = true
//                }) {
//                    Image(systemName: "plus.circle.fill")
//                        .font(.system(size: 50))
//                        .foregroundColor(.blue)
//                        .padding()
//                }
//            }
//            .navigationTitle("My App")
//            .navigationBarHidden(true)
//            .background(Color(.gray.opacity(0.1)))
//            // Reminder Setup View
//            .sheet(isPresented: $showReminderSetup) {
//                if let selectedItem = selectedItem {
//                    ReminderSetupView(item: selectedItem, reminders: $reminders)
//                }
//            }
//            // Notifications View
//            .sheet(isPresented: $showNotifications) {
//                NotificationsView(reminders: $reminders)
//            }
//            // Notes Modal View
//            .sheet(isPresented: $showNotesModal) {
//                if let selectedItem = selectedItem {
//                    NotesModal(item: selectedItem, notes: $notes)
//                }
//            }
//            // Edit Item Modal
//            .sheet(isPresented: $showEditItemModal) {
//                EditItemModal(items: $items, selectedItem: selectedItem)
//            }
//            // Action Sheet for Edit/Delete Options
//            .actionSheet(isPresented: $actionSheetPresented) {
//                ActionSheet(
//                    title: Text("Manage Item"),
//                    message: Text("What would you like to do?"),
//                    buttons: [
//                        .default(Text("Edit")) {
//                            showEditItemModal = true
//                        },
//                        .destructive(Text("Delete")) {
//                            if let selectedItem = selectedItem {
//                                deleteItemByName(selectedItem)
//                            }
//                        },
//                        .cancel()
//                        
//                    ]
//                )
//            }
//        }
//    }
//        
//    
//    // MARK: - Functions
//    
//    // Function to delete an item by name
//    func deleteItemByName(_ name: String) {
//        if let index = items.firstIndex(of: name) {
//            items.remove(at: index)
//            reminders.removeValue(forKey: name)
//            notes.removeValue(forKey: name)
//        }
//    }
//}
//
//
//
//
//#Preview {
//    ContentView()
//}
//
//
//
//
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var items = ["Party Night", "College", "Work", "Birthday"] // List items
    @State private var reminders: [String: Date] = [:]        // Dictionary to store reminders
    @State private var notes: [String: String] = [:]          // Dictionary to store notes for each item
    @State private var showReminderSetup = false              // Toggle to show reminder setup view
    @State private var showNotifications = false              // Toggle to show all reminders
    @State private var showNotesModal = false                 // Toggle to show notes modal
    @State private var showEditItemModal = false              // Toggle to show edit item modal
    @State private var selectedItem: String? = nil            // Track selected item
    @State private var actionSheetPresented = false           // Action sheet for edit/delete options
    @State private var searchText: String = ""                // State for search query
    
    var filteredItems: [String] {
        // Filter items that match the search text
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Custom Navigation Bar
                HStack {
                    // Custom Logo Instead of Home Icon
                    Image("CALC") // Use the name of your logo in Assets
                        .resizable()
                        .background(Color.gray.opacity(0.2))
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .shadow(radius: 2)
                    
                    Spacer()
                    
                    // Search TextField
                    TextField("Search...", text: $searchText)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    // Notification Bell Button
                    Button(action: {
                        showNotifications = true
                    }) {
                        Image(systemName: "bell.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color(.systemGray5))
                
                // List of Items
                List {
                    Section(header: Text("My Folder").font(.headline)) {
                        ForEach(filteredItems, id: \.self) { item in
                            HStack {
                                Text(item)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .onTapGesture {
                                        selectedItem = item
                                        showNotesModal = true
                                    }
                                    .onLongPressGesture {
                                        selectedItem = item
                                        actionSheetPresented = true
                                    }
                                
                                Spacer()
                                
                                // Bell Icon to Open Reminder Setup
                                Button(action: {
                                    selectedItem = item
                                    showReminderSetup = true
                                }) {
                                    Image(systemName: "bell.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal, 10)
                
                Spacer()
                
                // Plus Button at the Bottom
                Button(action: {
                    selectedItem = nil
                    showEditItemModal = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .navigationTitle("My App")
            .navigationBarHidden(true)
            .background(Color(.gray.opacity(0.1)))
            // Reminder Setup View
            .sheet(isPresented: $showReminderSetup) {
                if let selectedItem = selectedItem {
                    ReminderSetupView(item: selectedItem, reminders: $reminders)
                }
            }
            // Notifications View
            .sheet(isPresented: $showNotifications) {
                NotificationsView(reminders: $reminders)
            }
            // Notes Modal View
            .sheet(isPresented: $showNotesModal) {
                if let selectedItem = selectedItem {
                    NotesModal(item: selectedItem, notes: $notes)
                }
            }
            // Edit Item Modal
            .sheet(isPresented: $showEditItemModal) {
                EditItemModal(items: $items, selectedItem: selectedItem)
            }
            // Action Sheet for Edit/Delete Options
            .actionSheet(isPresented: $actionSheetPresented) {
                ActionSheet(
                    title: Text("Manage Item"),
                    message: Text("What would you like to do?"),
                    buttons: [
                        .default(Text("Edit")) {
                            showEditItemModal = true
                        },
                        .destructive(Text("Delete")) {
                            if let selectedItem = selectedItem {
                                deleteItemByName(selectedItem)
                            }
                        },
                        .cancel()
                    ]
                )
            }
        }
    }
    
    // MARK: - Functions
    
    // Function to delete an item by name
    func deleteItemByName(_ name: String) {
        if let index = items.firstIndex(of: name) {
            items.remove(at: index)
            reminders.removeValue(forKey: name)
            notes.removeValue(forKey: name)
        }
    }
}

#Preview {
    ContentView()
}


