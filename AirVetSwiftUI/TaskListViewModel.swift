//
//  TaskListViewModel.swift
//  AirVetSwiftUI
//
//  Created by Jian Ma on 8/27/24.
//
import Foundation
import Combine

class TaskListViewModel: ObservableObject {
    @Published var tasks: [Task] = [] {
        didSet {
            saveTasks()
        }
    }

    private let tasksKey = "tasksKey"

    init() {
        loadTasks()
    }

    func addTask(name: String, description: String) {
        let newTask = Task(name: name, description: description)
        tasks.append(newTask)
    }

    func toggleTaskCompletion(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }

    private func saveTasks() {
        if let encodedTasks = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodedTasks, forKey: tasksKey)
        }
    }

    private func loadTasks() {
        if let savedTasksData = UserDefaults.standard.data(forKey: tasksKey),
           let decodedTasks = try? JSONDecoder().decode([Task].self, from: savedTasksData) {
            tasks = decodedTasks
        }
    }
}

