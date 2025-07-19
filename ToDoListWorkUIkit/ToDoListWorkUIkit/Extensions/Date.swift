//
//  Date.swift
//  ToDoListWorkUIkit
//
//  Created by Abubakar on 19.07.2025.
//

import Foundation

extension Date {
    /// 19/07/25
    var shortSlash: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "dd/MM/yy"
        return fmt.string(from: self)
    }
}
