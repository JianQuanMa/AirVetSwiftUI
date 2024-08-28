//
//  TaskListViewModel.swift
//  AirVetSwiftUI
//
//  Created by Jian Ma on 8/27/24.
//

import Combine

class TaskListViewModel: ObservableObject {
    @Published var tasks: [Task] = []

    func addTask(name: String, description: String) {
        let newTask = Task(name: name, description: description)
        tasks.append(newTask)
    }

    func toggleTaskCompletion(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
}
