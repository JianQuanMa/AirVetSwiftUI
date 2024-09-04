//
//  AddTaskView.swift
//  AirVetSwiftUI
//
//  Created by Jian Ma on 8/27/24.
//

import SwiftUI

//struct AddTaskView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @ObservedObject var viewModel: TaskListViewModel
//
//    @State private var name: String = ""
//    @State private var description: String = ""
//
//    var body: some View {
//        NavigationView {
//            Form {
//                TextField("Task Name", text: $name)
//                TextField("Task Description", text: $description)
//            }
//            .navigationTitle("Add Task")
//            .navigationBarItems(trailing: Button("Save") {
//                if !name.isEmpty && !description.isEmpty {
//                    viewModel.addTask(name: name, description: description)
//                    presentationMode.wrappedValue.dismiss()
//                }
//            })
//        }
//    }
//}
//
//struct AddTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTaskView(viewModel: TaskListViewModel())
//    }
//}

