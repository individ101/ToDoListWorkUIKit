//
//  MainViewModel.swift
//  ToDoListWorkUIkit
//
//  Created by Abubakar on 19.07.2025.
//

import Foundation

final class MainViewModel {
    private let manager = CoreDataManager.shared
    private(set) var tasks: [TodoTask] = []
    private var searchItem: DispatchWorkItem?
    private let searchQueue = DispatchQueue(label: "com.todo.search", qos: .userInitiated)
    private let hasLoadedFromAPIKey = "hasLoadedFromAPI"
    
    func load(completion: @escaping () -> Void) {
        manager.fetchAllTasks { [weak self] arr in
            self?.tasks = arr
            completion()
        }
    }
    
    func loadFromAPI(completion: @escaping () -> Void) {
        let hasLoaded = UserDefaults.standard.bool(forKey: hasLoadedFromAPIKey)
        if hasLoaded {
            load(completion: completion)
        } else {
            manager.syncTasksFromApi { [weak self] in
                UserDefaults.standard.set(true, forKey: self?.hasLoadedFromAPIKey ?? "")
                self?.load(completion: completion)
            }
        }
    }
    
    func create(title: String, text: String, completion: @escaping () -> Void) {
        manager.createTask(title: title, text: text) { [weak self] in
            self?.load(completion: completion)
        }
    }
    
    func update(task: TodoTask, title: String, text: String, completion: @escaping () -> Void) {
        manager.updateTask(task, title: title, text: text) { [weak self] in
            self?.load(completion: completion)
        }
    }
    
    func toggle(at index: Int, completion: @escaping () -> Void) {
        manager.toggleCompleted(tasks[index]) { [weak self] in
            self?.load(completion: completion)
        }
    }
    
    func delete(at index: Int, completion: @escaping () -> Void) {
        manager.deleteTask(tasks[index]) { [weak self] in
            self?.load(completion: completion)
        }
    }
    
    func search(text: String, completion: @escaping () -> Void) {
        searchItem?.cancel()
        let item = DispatchWorkItem { [weak self] in
            self?.manager.searchTasks(query: text) { result in
                self?.tasks = result
                completion()
            }
        }
        searchItem = item
        searchQueue.asyncAfter(deadline: .now() + 0.35, execute: item)
    }
}
