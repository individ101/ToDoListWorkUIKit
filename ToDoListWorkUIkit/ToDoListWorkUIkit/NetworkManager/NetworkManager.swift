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
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                let todoResponse = try decoder.decode(TodoResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(todoResponse))
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
