//
//  EditTaskView.swift
//  AirVetSwiftUI
//
//  Created by Jian Ma on 8/28/24.
//

import SwiftUI

struct EditTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: TaskListViewModel
    var task: Task

    @State private var name: String
    @State private var description: String

    init(viewModel: TaskListViewModel, task: Task) {
        self.viewModel = viewModel
        self.task = task
        _name = State(initialValue: task.name)
        _description = State(initialValue: task.description)
    }

    var body: some View {
        VStack {
            Form {
                TextField("Task Name", text: $name)
                TextField("Task Description", text: $description)
            }

            Button(action: {
                viewModel.updateTask(id: task.id, name: name, description: description)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .navigationTitle("Edit Task")
        .padding(.bottom) // To add some space at the bottom of the screen
    }
}

struct EditTaskView_Previews: PreviewProvider {
    static var previews: some View {
        EditTaskView(viewModel: TaskListViewModel(), task: Task(name: "Sample Task", description: "Sample Description"))
    }
}


