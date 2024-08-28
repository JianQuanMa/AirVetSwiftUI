//
//  ContentView.swift
//  AirVetSwiftUI
//
//  Created by Jian Ma on 8/27/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = TaskListViewModel()
    @State private var showingAddTaskView = false

    var body: some View {
        NavigationView {
            VStack {
                Toggle(isOn: $viewModel.showUnfinishedOnly) {
                    Text("Unfinished Only")
                }

                List {
                    ForEach(viewModel.filteredTasks) { task in
                        NavigationLink(destination: EditTaskView(viewModel: viewModel, task: task)) {
                            TaskRowView(task: task, viewModel: viewModel)
                        }
                    }
                    .onDelete(perform: deleteTask)
                }
            }
            .navigationTitle("Tasks")
            .navigationBarItems(trailing: Button(action: {
                showingAddTaskView = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddTaskView) {
                AddTaskView(viewModel: viewModel)
            }
        }
    }

    private func deleteTask(at offsets: IndexSet) {
        viewModel.deleteTasks(at: offsets)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}



