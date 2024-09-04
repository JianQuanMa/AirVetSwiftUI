//
//  ContentView.swift
//  AirVetSwiftUI
//
//  Created by Jian Ma on 8/27/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = TaskListViewModel()

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            VStack {
                Toggle(isOn: $viewModel.showUnfinishedOnly.animation(.default)) {
                    Text("Unfinished Only")
                }
                .padding(.horizontal, 16)
                
                List {
                    ForEach(viewModel.tasks) { task in
                        ZStack {
                            TaskRowView(task: task, viewModel: viewModel)
                        }
                        .contentShape(Rectangle())
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            viewModel.onTaskTapped(task)
                        }
                    }
                    .onDelete { indexSet in
                        viewModel.onDelete(indexSet)
                    }
                }
            }
            .navigationTitle("Tasks")
            .navigationBarItems(trailing: Button(action: {
                viewModel.onAddTaskButtonTapped()
            }) {
                Image(systemName: "plus")
            })
            .onAppear {
                viewModel.onAppear()
            }
            .sheet(item: $viewModel.addTaskView) { taskViewModel in
                NavigationStack {
                    Form {
                        TextField("Task Name", text: .init(
                            get: { taskViewModel.name },
                            set: viewModel.onNewName
                        ))
                        TextField("Task Description", text: .init(
                            get: { taskViewModel.description },
                            set: viewModel.onNewDescription
                        ))
                    }
                    .navigationTitle("Add Task")
                    .navigationBarItems(trailing: Button("Save") {
                        if taskViewModel.passesValidation {
                            viewModel.onAddSaveTapped(taskViewModel)
                        }
                    }.disabled(!taskViewModel.passesValidation))
                }
            }
            
            .navigationDestination(for: TaskListViewModel.PushedDestination.self) { dest in
                switch dest {
                case .edit(let task):
                    EditTaskView(task: task, onSave: { edited in
                        viewModel.onEditSaveTapped(edited)
                    })
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}



