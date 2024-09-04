//
//  EditTaskView.swift
//  AirVetSwiftUI
//
//  Created by Jian Ma on 8/28/24.
//

import SwiftUI

struct EditTaskView: View {
    @State private var name: String
    @State private var description: String

    private let onSave: (AddTaskViewModel) -> Void
    private let taskID: UUID

    init(
        task: UserTask,
        onSave: @escaping (AddTaskViewModel) -> Void
    ) {
        self.onSave = onSave
        self.taskID = task.id
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
                onSave(.init(id: taskID, name: name, description: description))
//                viewModel.updateTask(id: task.id, name: name, description: description)
//                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .disabled(!isValid)
                    .opacity(isValid ? 1.0 : 0.5)
            }
        }
        .navigationTitle("Edit Task")
        .padding(.bottom) // To add some space at the bottom of the screen
    }
    
    private var isValid: Bool {
        !name.isEmpty && !description.isEmpty
    }
}

//struct EditTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditTaskView(viewModel: TaskListViewModel(), task: Task(name: "Sample Task", description: "Sample Description"))
//    }
//}


