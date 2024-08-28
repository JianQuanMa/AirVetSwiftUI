//
//  TaskRowView.swift
//  AirVetSwiftUI
//
//  Created by Jian Ma on 8/27/24.
//

import SwiftUI

struct TaskRowView: View {
    var task: Task
    var viewModel: TaskListViewModel

    var body: some View {
        HStack {
            Button(action: {
                viewModel.toggleTaskCompletion(task: task)
            }) {
                Image(systemName: task.isCompleted ? "checkmark.square" : "square")
            }
            .buttonStyle(PlainButtonStyle())

            VStack(alignment: .leading) {
                Text(task.name)
                    .font(.headline)
                Text(task.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(task: Task(name: "Sample Task", description: "Sample Description"), viewModel: TaskListViewModel())
    }
}
