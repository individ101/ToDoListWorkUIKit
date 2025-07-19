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
    var tasks: [TodoTask] = []
    
    private init() {
        
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { storeDerscription, error in
            if let error = error as NSError? {
                fatalError("Persistent error:-- \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            }
            catch {
                let nsError = error as NSError
                fatalError("Save err:-- \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func getAllTasks() {
        let request = TodoTask.fetchRequest()
        if let tasks = try? persistentContainer.viewContext.fetch(request) {
            self.tasks = tasks
        }
    }
    
    func createNewTask(title: String, text: String) {
        let task = TodoTask(context: persistentContainer.viewContext)
        task.id = UUID().uuidString
        task.title = title
        task.text = text
        task.creationDate = Date()
        
        saveContext()
        getAllTasks()
    }
    
}
