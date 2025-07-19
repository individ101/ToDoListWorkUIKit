//
//  CoreDataManager.swift
//  ToDoListWorkUIkit
//
//  Created by Abubakar on 19.07.2025.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() { }
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Store error:-- \(error)")
            }
            container.viewContext.automaticallyMergesChangesFromParent = true
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
        return container
    }()
    
    lazy var bgContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    func fetchAllTasks(completion: @escaping ([TodoTask]) -> ()) {
        let request: NSFetchRequest<TodoTask> = TodoTask.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        bgContext.perform {
            do {
                let objects = try self.bgContext.fetch(request)
                let ids = objects.map { $0.objectID }
                DispatchQueue.main.async {
                    let viewContext = self.persistentContainer.viewContext
                    let result = ids.compactMap { viewContext.object(with: $0) as? TodoTask }
                    completion(result)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    func createTask(title: String, text: String, completion: (() -> Void)? = nil) {
        bgContext.perform {
            let task = TodoTask(context: self.bgContext)
            task.id = UUID().uuidString
            task.title = title
            task.text = text
            task.creationDate = Date()
            task.isCompleted = false
            self.save(bg: true) {
                completion?()
            }
        }
    }
    
    func updateTask(_ task: TodoTask, title: String, text: String, completion: (() -> Void)? = nil) {
        let id = task.objectID
        bgContext.perform {
            if let bgTask = try? self.bgContext.existingObject(with: id) as? TodoTask {
                bgTask.title = title
                bgTask.text = text
                self.save(bg: true, completion: completion)
            } else {
                DispatchQueue.main.async {
                    completion?()
                }
            }
        }
    }
    
    func toggleCompleted(_ task: TodoTask, completion: (() -> Void)? = nil) {
            let id = task.objectID
            bgContext.perform {
                if let bgTask = try? self.bgContext.existingObject(with: id) as? TodoTask {
                    bgTask.isCompleted.toggle()
                    self.save(bg: true, completion: completion)
                } else {
                    DispatchQueue.main.async { completion?() }
                }
            }
        }
    
    func deleteTask(_ task: TodoTask, completion: (() -> Void)? = nil) {
            let id = task.objectID
            bgContext.perform {
                if let bgTask = try? self.bgContext.existingObject(with: id) {
                    self.bgContext.delete(bgTask)
                    self.save(bg: true, completion: completion)
                } else {
                    DispatchQueue.main.async { completion?() }
                }
            }
        }
    
    func searchTasks(query: String, completion: @escaping ([TodoTask]) -> Void) {
           let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
           guard !trimmed.isEmpty else {
               fetchAllTasks(completion: completion)
               return
           }
           let request: NSFetchRequest<TodoTask> = TodoTask.fetchRequest()
           request.predicate = NSPredicate(format: "(title CONTAINS[cd] %@) OR (text CONTAINS[cd] %@)", trimmed, trimmed)
           request.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
           bgContext.perform {
               let ids: [NSManagedObjectID]
               do {
                   let found = try self.bgContext.fetch(request)
                   ids = found.map { $0.objectID }
               } catch {
                   ids = []
               }
               DispatchQueue.main.async {
                   let viewContext = self.persistentContainer.viewContext
                   let result = ids.compactMap { viewContext.object(with: $0) as? TodoTask }
                   completion(result)
               }
           }
       }
    
    private func save(bg: Bool, completion: (() -> ())?) {
        let context = bg ? bgContext : persistentContainer.viewContext
        do {
            if context.hasChanges { try context.save() }
            DispatchQueue.main.async { completion?() }
        }
        catch {
            DispatchQueue.main.async { completion?() }
        }
    }
}
