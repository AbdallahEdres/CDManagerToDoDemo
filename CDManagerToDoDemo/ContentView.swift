//
//  ContentView.swift
//  CDManagerToDoDemo
//
//  Created by Abdallah Edres on 21/11/2025.
//

import SwiftUI
import CoreData
import CDManager
import Combine

struct ContentView: View {
    @StateObject private var vm = TasksViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                
                // Add new task
                HStack {
                    TextField("Title", text: $vm.newTitle)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Add") { vm.add() }
                        .buttonStyle(.borderedProminent)
                }
                .padding()
                
                List {
                    // MARK: - Pending Tasks
                    if !vm.pending.isEmpty {
                        Section("Pending") {
                            ForEach(vm.pending, id: \.id) { task in
                                taskRow(task)
                            }
                        }
                    }
                    
                    // MARK: - Completed Tasks
                    if !vm.completed.isEmpty {
                        Section("Completed") {
                            ForEach(vm.completed, id: \.id) { task in
                                taskRow(task)
                            }
                        }
                    }
                }
                .listStyle(.grouped)
            }
            .navigationTitle("Tasks")
            .onAppear { vm.load() }
        }
    }
    
    // MARK: - Task Row with Checkbox
    func taskRow(_ task: ToDoTask) -> some View {
        HStack {
            Button {
                vm.toggle(task)
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            
            Text(task.title ?? "")
                .strikethrough(task.isCompleted)
                .frame(maxWidth: .infinity)
            
            Button {
                vm.delete(task)
            } label: {
                Image(systemName: "trash")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.red)
                    .frame(width: 24)
                
            }
            .buttonStyle(.borderless)
        }
    }
}


@MainActor
final class TasksViewModel: ObservableObject {
    @Published var completed: [ToDoTask] = []
    @Published var pending: [ToDoTask] = []
    @Published var newTitle: String = ""
    
    private let repo = ToDoTasksRepository()
    
    func load() {
        completed = repo.getTasks(isCompleted: true)
        pending  = repo.getTasks(isCompleted: false)
    }
    
    func add() {
        guard !newTitle.isEmpty else { return }
        repo.createTask(title: newTitle)
        newTitle = ""
        load()
    }
    
    func delete(_ task: ToDoTask) {
        repo.delete(task)
        load()
    }
    
    func toggle(_ task: ToDoTask) {
        repo.toggle(task)
        load()
    }
}

extension ToDoTask: ManagedEntity{}
final class ToDoTasksRepository{
    private let localDataSource = CDDataSource<ToDoTask>(
        context: PersistenceController.shared
            .context)
    func getAllTasks() -> [ToDoTask]{
        return (try? localDataSource.getAll()) ?? []
    }
    func delete(_ task: ToDoTask) {
        try? localDataSource.delete(task)
    }
    func createTask(title: String){
        let _ = try? localDataSource.create({ task in
            task.id = .init()
            task.title = title
        })
    }
    func getTasks(isCompleted: Bool) -> [ToDoTask]{
        return (try? localDataSource.filter(.where("isCompleted", isEqual: NSNumber(value: isCompleted)))) ?? []
    }
    func toggle(_ newVal: ToDoTask){
        do{
            try localDataSource.edit(newVal, { task in
                newVal.isCompleted.toggle()
            })
        } catch{
            print(error)
        }
    }
}
