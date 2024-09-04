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
        let expectation = self.expectation(description: "Task added after delay")
        
        // When
        viewModel.onAddSaveTapped(AddTaskViewModel(id: UUID(), name: taskName, description: taskDescription))
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Then
            XCTAssertEqual(self.viewModel.tasks.count, 1)
            XCTAssertEqual(self.viewModel.tasks.first?.name, taskName)
            XCTAssertEqual(self.viewModel.tasks.first?.description, taskDescription)
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled, or timeout after 1 second
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_addingTask_failure() {
        // Given
        let taskName = "New Task"
        let taskDescription = "Task Description"
        
        let expectation = self.expectation(description: "Task added after delay")
        
        let viewModel = TaskListViewModel()
        
        // When
        viewModel.onAddSaveTapped(AddTaskViewModel(id: UUID(), name: taskName, description: taskDescription))
        
        // Wait for the delay to pass
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Then
            XCTAssertNotEqual(viewModel.tasks.count, 2, "Task count should not be 2 after adding one task")
            XCTAssertNotEqual(viewModel.tasks.first?.name, taskName + "9", "Task name should not match the incorrect expected name")
            XCTAssertNotEqual(viewModel.tasks.first?.description, taskDescription + "9", "Task description should not match the incorrect expected description")
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled, or timeout after 1 second
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_delete_task_success() {
        // Given
        let t1 = AddTaskViewModel(id: UUID(), name: "Task 1", description: "Description 1")
        viewModel.onAddSaveTapped(t1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let t2 = AddTaskViewModel(id: UUID(), name: "Task 2", description: "Description 2")
            self.viewModel.onAddSaveTapped(t2)
        }
        
        // When
        let expectation = self.expectation(description: "Tasks added and deleted successfully")
        
        // Ensure tasks are added
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Perform deletion
            self.viewModel.onDelete(IndexSet(arrayLiteral: 0))

            // Wait a bit longer to ensure the deletion has processed
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // Then
                print("-=-", self.viewModel.tasks)
                XCTAssertEqual(self.viewModel.tasks.count, 1, "There should be only one task after deletion")
                XCTAssertEqual(self.viewModel.tasks.first?.name, "Task 2", "The remaining task should be 'Task 2'")
                
                expectation.fulfill()
            }
        }
        
        // Wait for the expectation to be fulfilled, or timeout after 2 seconds
        wait(for: [expectation], timeout: 2.5)
    }
    
    func test_delete_task_failure() {
        // Given
        let t1 = AddTaskViewModel(id: UUID(), name: "Task 1", description: "Description 1")
        viewModel.onAddSaveTapped(t1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let t2 = AddTaskViewModel(id: UUID(), name: "Task 2", description: "Description 2")
            self.viewModel.onAddSaveTapped(t2)
        }

        // When
        let expectation = self.expectation(description: "Tasks added and deletion tested for failure")
        
        // Ensure tasks are added before attempting to delete
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel.onDelete(IndexSet(arrayLiteral: 0))
            
            // Wait a bit longer for the deletion to process
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                // Then
                print("-=- " , self.viewModel.allFilteredTasks.count, self.viewModel.tasks.count)
                XCTAssertNotEqual(self.viewModel.allFilteredTasks.count, 2, "The task count should not be 2 after deletion")
                XCTAssertEqual(self.viewModel.allFilteredTasks.count, 1, "Expected task count to be 1 after deletion")
                XCTAssertNotEqual(self.viewModel.allFilteredTasks.first?.name, "Task 1", "The remaining task should not be 'Task 1'")
                
                expectation.fulfill()
            }
        }
        
        // Wait for the expectation to be fulfilled, or timeout after 2 seconds
        wait(for: [expectation], timeout: 3.0)
    }

    
    func test_filteringTasks_unfinishedOnly_success() {
        // Given
        let t1 = AddTaskViewModel(id: UUID(), name: "Task 1", description: "Description 1")
        let t2 = AddTaskViewModel(id: UUID(), name: "Task 2", description: "Description 2")
        let t3 = AddTaskViewModel(id: UUID(), name: "Task 3", description: "Description 3")
        
        let expectation = self.expectation(description: "Tasks added and filtered successfully")

        // Add tasks
        viewModel.onAddSaveTapped(t1)
        viewModel.onAddSaveTapped(t2)
        viewModel.onAddSaveTapped(t3)
        
        // Ensure tasks are added
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Mark one task as completed
            if let taskToComplete = self.viewModel.allFilteredTasks.first {
                self.viewModel.toggleTaskCompletion(task: taskToComplete)
            }
            
            // Wait a bit longer for the completion to process
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // When
                self.viewModel.showUnfinishedOnly = true
                
                // Then
                print("-=-,", self.viewModel.allFilteredTasks)
                XCTAssertEqual(self.viewModel.allFilteredTasks.filter { !$0.isCompleted }.count, 2, "Expected only 2 unfinished tasks")
                XCTAssertFalse(self.viewModel.allFilteredTasks.allSatisfy { !$0.isCompleted }, "Expected not all filtered tasks to be incomplete")
                
                expectation.fulfill()
            }
        }
        
        // Wait for the expectation to be fulfilled, or timeout after 2.5 seconds
        wait(for: [expectation], timeout: 2.5)
    }


    
    func test_filteringTasks_unfinishedOnly_failure() {
        // Given
        let t1 = AddTaskViewModel(id: UUID(), name: "Task 1", description: "Description 1")
        let t2 = AddTaskViewModel(id: UUID(), name: "Task 2", description: "Description 2")
        let t3 = AddTaskViewModel(id: UUID(), name: "Task 3", description: "Description 3")
        
        let expectation = self.expectation(description: "Tasks added and filtered for failure")
        
        viewModel.onAddSaveTapped(t1)
        viewModel.onAddSaveTapped(t2)
        viewModel.onAddSaveTapped(t3)
        
        // Wait for the tasks to be added
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // When
            self.viewModel.showUnfinishedOnly = true
            
            // Then
            XCTAssertFalse(self.viewModel.tasks.allSatisfy { $0.isCompleted }, "Expected some tasks to be incomplete")
            
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled, or timeout after 1.5 seconds
        wait(for: [expectation], timeout: 1.5)
    }


    
    func test_filteringTasks_showAll_success() {
        // Given
        let t1 = AddTaskViewModel(id: UUID(), name: "Task 1", description: "Description 1")
        let t2 = AddTaskViewModel(id: UUID(), name: "Task 2", description: "Description 2")
        let t3 = AddTaskViewModel(id: UUID(), name: "Task 3", description: "Description 3")
        
        let expectation = self.expectation(description: "Tasks added and filtered to show all")
        
        viewModel.onAddSaveTapped(t1)
        viewModel.onAddSaveTapped(t2)
        viewModel.onAddSaveTapped(t3)
        
        // Wait for the tasks to be added
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // When
            self.viewModel.showUnfinishedOnly = false
            
            // Then
            XCTAssertEqual(self.viewModel.tasks.count, 3, "Expected all tasks to be shown")
            
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled, or timeout after 1.5 seconds
        wait(for: [expectation], timeout: 1.5)
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
