//
//  TodoManager.swift
//  ComposableTodo
//
//  Created by Sunny.K on 2021/01/28.
//

import Foundation
import Combine

final class TodoManager: TodoStorable {
    static let shared = TodoManager()

    var todoPublisher: Published<[Todo]>.Publisher { $todos }

    private let userDefault = UserDefaults.standard

    @Published private var todos: [Todo] = []

    private init() {
        DispatchQueue.global().async { [self] in
            guard let data = userDefault.data(forKey: "Todos") else { return }
            guard let savedTodo = try? JSONDecoder().decode([Todo].self, from: data) else { return }
            todos = savedTodo
        }
    }

    func add(todo: String) {
        todos.append(Todo(description: todo))
        let data = try? JSONEncoder().encode(todos)
        self.userDefault.set(data, forKey: "Todos")
    }

    func save(todos: [Todo]) {
        self.todos = todos
        let data = try? JSONEncoder().encode(todos)
        self.userDefault.set(data, forKey: "Todos")
    }
}
