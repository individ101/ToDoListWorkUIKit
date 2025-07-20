//
//  TodoModel.swift
//  ToDoListWorkUIkit
//
//  Created by Abubakar on 20.07.2025.
//

import Foundation

struct TodoItem: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

struct TodoResponse: Codable {
    let todos: [TodoItem]
    let total: Int
    let skip: Int
    let limit: Int
}
