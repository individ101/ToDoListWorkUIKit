//
//  NetworkManager.swift
//  ToDoListWorkUIkit
//
//  Created by Abubakar on 20.07.2025.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchTodo(completion: @escaping(Result<TodoResponse, Error>) -> ()) {
        let url = URL(string: "https://dummyjson.com/todos")!
        
        URLSession.shared.dataTask(with: url) { data, response, err in
            if let error = err {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            do {
                let decoder = JSONDecoder()
                let todoResponse = try decoder.decode(TodoResponse.self, from: data)
               
                    completion(.success(todoResponse))
            }
            catch {
                    completion(.failure(error))
                
            }
        }.resume()
    }
    
}
