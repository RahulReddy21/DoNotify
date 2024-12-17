//
//  Untitled.swift
//  ch-3 trail
//
//  Created by Rahul Reddy Karri on 17/12/24.
//



import SwiftUI
// MARK: - Other Views (Edit/Add Item Modal and Notes Modal)

struct EditItemModal: View {
    @Binding var items: [String]
    var selectedItem: String? // Nil means "Add Mode"; non-nil means "Edit Mode"
    @State private var itemName: String = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter item name", text: $itemName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding()

                Button(action: {
                    if let selectedItem = selectedItem, let index = items.firstIndex(of: selectedItem) {
                        items[index] = itemName
                    } else {
                        items.append(itemName)
                    }
                    dismiss()
                }) {
                    Text(selectedItem == nil ? "Add Item" : "Save Changes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                Spacer()
            }
            .navigationTitle(selectedItem == nil ? "Add New Item" : "Edit Item")
            .navigationBarItems(trailing: Button("Close") {
                dismiss()
            })
            .onAppear {
                if let selectedItem = selectedItem {
                    itemName = selectedItem
                }
            }
        }
    }
}




