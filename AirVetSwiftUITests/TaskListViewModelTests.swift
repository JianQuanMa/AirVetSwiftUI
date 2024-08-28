//
//  TaskListViewModelTests.swift
//  AirVetSwiftUITests
//
//  Created by Jian Ma on 8/28/24.
//

import XCTest
@testable import AirVetSwiftUI

final class TaskListViewModelTests: XCTestCase {
    
    var viewModel: TaskListViewModel!
    
    
    func test_addingTask_success() {
        // Given
        let taskName = "New Task"
        let taskDescription = "Task Description"
        
        // When
        viewModel.addTask(name: taskName, description: taskDescription)
        
        // Then
        XCTAssertEqual(viewModel.tasks.count, 1)
        XCTAssertEqual(viewModel.tasks.first?.name, taskName)
        XCTAssertEqual(viewModel.tasks.first?.description, taskDescription)
    }
    
    func test_addingTask_failure() {
        // Given
        let taskName = "New Task"
        let taskDescription = "Task Description"
        
        // When
        viewModel.addTask(name: taskName, description: taskDescription)
        
        // Then
        XCTAssertNotEqual(viewModel.tasks.count, 2)
        XCTAssertNotEqual(viewModel.tasks.first?.name, taskName + "9")
        XCTAssertNotEqual(viewModel.tasks.first?.description, taskDescription + "9")
    }
    
    func test_delete_task_success() {
        // Given
        let task1 = Task(name: "Task 1", description: "Description 1")
        let task2 = Task(name: "Task 2", description: "Description 2")
        viewModel.tasks = [task1, task2]
        
        // When
        viewModel.deleteTasks(at: IndexSet(integer: 0))
        
        // Then
        XCTAssertEqual(viewModel.tasks.count, 1)
        XCTAssertEqual(viewModel.tasks.first?.name, "Task 2")
    }
    
    func test_delete_task_failure() {
        // Given
        let task1 = Task(name: "Task 1", description: "Description 1")
        let task2 = Task(name: "Task 2", description: "Description 2")
        viewModel.tasks = [task1, task2]
        
        // When
        viewModel.deleteTasks(at: IndexSet(integer: 0))
        
        // Then
        XCTAssertNotEqual(viewModel.tasks.count, 2)
        XCTAssertNotEqual(viewModel.tasks.first?.name, "Task 1")
    }
    
    func test_filteringTasks_unfinishedOnly_success() {
        // Given
        let task1 = Task(name: "Task 1", description: "Description 1", isCompleted: false)
        let task2 = Task(name: "Task 2", description: "Description 2", isCompleted: true)
        let task3 = Task(name: "Task 3", description: "Description 3", isCompleted: false)
        viewModel.tasks = [task1, task2, task3]
        
        // When
        viewModel.showUnfinishedOnly = true
        
        // Then
        XCTAssertEqual(viewModel.filteredTasks.count, 2)
        XCTAssertTrue(viewModel.filteredTasks.allSatisfy { !$0.isCompleted })
    }
    
    func test_filteringTasks_unfinishedOnly_failure() {
        // Given
        let task1 = Task(name: "Task 1", description: "Description 1", isCompleted: false)
        let task2 = Task(name: "Task 2", description: "Description 2", isCompleted: true)
        let task3 = Task(name: "Task 3", description: "Description 3", isCompleted: false)
        viewModel.tasks = [task1, task2, task3]
        
        // When
        viewModel.showUnfinishedOnly = true
        
        // Then
        XCTAssertNotEqual(viewModel.filteredTasks.count, 3)
        XCTAssertFalse(viewModel.filteredTasks.allSatisfy { $0.isCompleted })
    }
    
    func test_filteringTasks_showAll_success() {
        // Given
        let task1 = Task(name: "Task 1", description: "Description 1", isCompleted: false)
        let task2 = Task(name: "Task 2", description: "Description 2", isCompleted: true)
        let task3 = Task(name: "Task 3", description: "Description 3", isCompleted: false)
        viewModel.tasks = [task1, task2, task3]
        
        // When
        viewModel.showUnfinishedOnly = false
        
        // Then
        XCTAssertEqual(viewModel.filteredTasks.count, 3)
    }
    
    override func setUp() {
        super.setUp()
        clearUserDefaults()
        viewModel = TaskListViewModel()
    }

    override func tearDown() {
        clearUserDefaults()
        viewModel = nil
        super.tearDown()
    }

    private func clearUserDefaults() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }

}
