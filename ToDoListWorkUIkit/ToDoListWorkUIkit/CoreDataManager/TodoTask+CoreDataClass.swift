//
//  TodoTask+CoreDataClass.swift
//  ToDoListWorkUIkit
//
//  Created by Abubakar on 18.07.2025.
//
//

import Foundation
import CoreData

@objc(TodoTask)
public class TodoTask: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoTask> {
        return NSFetchRequest<TodoTask>(entityName: "TodoTask")
    }

    @NSManaged public var creationDate: Date?
    @NSManaged public var id: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var text: String?
    @NSManaged public var title: String?
}

extension TodoTask {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: self.creationDate ?? Date())
    }
}
