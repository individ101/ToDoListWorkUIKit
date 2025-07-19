//
//  TodoTask+CoreDataProperties.swift
//  ToDoListWorkUIkit
//
//  Created by Abubakar on 18.07.2025.
//
//

import Foundation
import CoreData


extension TodoTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoTask> {
        return NSFetchRequest<TodoTask>(entityName: "TodoTask")
    }

    @NSManaged public var creationDate: Date?
    @NSManaged public var id: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var text: String?
    @NSManaged public var title: String?

}

extension TodoTask : Identifiable {
    func updateTask(title: String, text: String) {
        self.title = title
        self.text = text
        self.creationDate = Date()
        
        try? managedObjectContext?.save()
    }
    
    func deleteTask() {
        managedObjectContext?.delete(self)
        try? managedObjectContext?.save()
    }
    
}
