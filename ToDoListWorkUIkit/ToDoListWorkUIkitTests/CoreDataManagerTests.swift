//
//  CoreDataManagerTests.swift
//  CoreDataManagerTests
//
//  Created by Abubakar on 21.07.2025.
//

import XCTest

import XCTest
import CoreData
@testable import ToDoListWorkUIkit

class CoreDataManagerTests: XCTestCase {
    
    var coreDataManager: CoreDataManager!
    var persistentContainer: NSPersistentContainer!
    
    override func setUp() {
        super.setUp()
        
        persistentContainer = NSPersistentContainer(name: "CoreData")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load store: \(error)")
            }
        }
        coreDataManager = CoreDataManager(persistentContainer: persistentContainer)
    }
    
    override func tearDown() {
        coreDataManager = nil
        persistentContainer = nil
        super.tearDown()
    }
    
    func testCreateTask() {
        let expectation = XCTestExpectation(description: "Create task")
        let title = "Test Task"
        let text = "This is a test task"
        
        coreDataManager.createTask(title: title, text: text) {
            self.coreDataManager.fetchAllTasks { tasks in
                XCTAssertEqual(tasks.count, 1, "Должна быть создана одна задача")
                XCTAssertEqual(tasks.first?.title, title, "Название задачи должно совпадать")
                XCTAssertEqual(tasks.first?.text, text, "Текст задачи должен совпадать")
                XCTAssertFalse(tasks.first?.isCompleted ?? true, "Задача не должна быть завершена")
                XCTAssertNotNil(tasks.first?.creationDate, "Дата создания должна быть установлена")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    func testUpdateTask() {
        // Given
        let expectation = XCTestExpectation(description: "Update task")
        let title = "Original Task"
        let text = "Original text"
        let newTitle = "Updated Task"
        let newText = "Updated text"
        
        coreDataManager.createTask(title: title, text: text) {
            self.coreDataManager.fetchAllTasks { tasks in
                guard let task = tasks.first else {
                    XCTFail("Задача не создана")
                    return
                }
                
                // When
                self.coreDataManager.updateTask(task, title: newTitle, text: newText) {
                    // Then
                    self.coreDataManager.fetchAllTasks { updatedTasks in
                        XCTAssertEqual(updatedTasks.count, 1, "Количество задач не должно измениться")
                        XCTAssertEqual(updatedTasks.first?.title, newTitle, "Название задачи должно обновиться")
                        XCTAssertEqual(updatedTasks.first?.text, newText, "Текст задачи должен обновиться")
                        expectation.fulfill()
                    }
                }
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
