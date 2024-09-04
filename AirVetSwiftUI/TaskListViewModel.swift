//
//  TaskListViewModel.swift
//  AirVetSwiftUI
//
//  Created by Jian Ma on 8/27/24.
//
import Foundation
import Combine

struct AddTaskViewModel: Identifiable {
    
    let id: UUID
    var name = ""
    var description = ""

    init(
        id: UUID = UUID(),
        name: String = "",
        description: String = ""
    ) {
        self.id = id
        self.name = name
        self.description = description
    }
    
    // TODO: - delete this
    var passesValidation: Bool {
        !name.isEmpty && !description.isEmpty
    }
}

import SwiftUI

class TaskListViewModel: ObservableObject {
    enum PushedDestination: Hashable {
        case edit(UserTask)
    }
    
    @Published var showUnfinishedOnly: Bool = false
    @Published var addTaskView: AddTaskViewModel?
    @Published var path = NavigationPath()
    @Published private var _tasks: [UserTask] = [] {
        didSet {
            saveTasks()
        }
    }
    
    let userDefaults: UserDefaults

    var tasks: [UserTask] {
        if showUnfinishedOnly {
            return _tasks.filter { !$0.isCompleted }
        } else {
            return _tasks
        }
    }

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func onAppear() {
        if let savedTasksData = userDefaults.data(forKey: tasksKey),
           let decodedTasks = try? JSONDecoder().decode([UserTask].self, from: savedTasksData) {
            
            _tasks = decodedTasks
        }
    }
    
    func onAddTaskButtonTapped() {
        addTaskView = AddTaskViewModel()
    }
    
    func onTaskTapped(_ task: UserTask) {
        path.append(PushedDestination.edit(task))
    }

    func onAddSaveTapped(_ new: AddTaskViewModel) {
        addTaskView = nil
        
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(0.5))
            
            withAnimation(.default) {
                _tasks.append(.init(
                    id: UUID(),
                    name: new.name,
                    description: new.description,
                    isCompleted: false
                ))
            }
        }
    }
    
    func onNewDescription(_ description: String) {
        self.addTaskView?.description = description
    }
    
    func onEditSaveTapped(_ edited: AddTaskViewModel) {
        if let index = _tasks.firstIndex(where: {
            $0.id == edited.id
        }) {
            let old = _tasks[index]
            
            _tasks[index] = .init(
                id: edited.id,
                name: edited.name,
                description: edited.description,
                isCompleted: old.isCompleted
            )
        }
        
        path.removeLast()
    }
    
    var allFilteredTasks: [UserTask] {
        _tasks
    }
    
    func onNewName(_ newName: String) {
        self.addTaskView?.name = newName
    }
    
    func onDelete(_ offsets: IndexSet) {
        _tasks.remove(atOffsets: offsets)
    }

    func toggleTaskCompletion(task: UserTask) {
        if let index = _tasks.firstIndex(where: { $0.id == task.id }) {
            _tasks[index].isCompleted.toggle()
        }
    }

    func updateTask(id: UUID, name: String, description: String) {
        if let index = _tasks.firstIndex(where: { $0.id == id }) {
            _tasks[index].name = name
            _tasks[index].description = description
        }
    }

    private func saveTasks() {
        if let encodedTasks = try? JSONEncoder().encode(_tasks) {
            userDefaults.set(encodedTasks, forKey: tasksKey)
        }
    }
}

private let tasksKey = "tasksKey"

