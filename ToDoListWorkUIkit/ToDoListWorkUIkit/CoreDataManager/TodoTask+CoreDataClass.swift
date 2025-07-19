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
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: self.creationDate ?? Date())
    }
}
