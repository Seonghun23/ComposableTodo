//
//  TodoManager.swift
//  ComposableTodo
//
//  Created by Sunny.K on 2021/01/28.
//

import Foundation
import Combine

actor TodoManager: TodoStorable {
    static let shared = TodoManager()
    
    func todos() async -> [Todo] {
        todos
    }
    
    func add(todo: String) async {
        todos.append(Todo(description: todo))
        let data = try? JSONEncoder().encode(todos)
        self.userDefault.set(data, forKey: "Todos")
    }

    func save(todos: [Todo]) async {
        self.todos = todos
        let data = try? JSONEncoder().encode(todos)
        self.userDefault.set(data, forKey: "Todos")
    }
    
    private let userDefault = UserDefaults.standard
    
    private var todos: [Todo] = []
    
    private init() {
        guard let data = userDefault.data(forKey: "Todos") else { return }
        guard let savedTodo = try? JSONDecoder().decode([Todo].self, from: data) else { return }
        todos = savedTodo
    }
}
