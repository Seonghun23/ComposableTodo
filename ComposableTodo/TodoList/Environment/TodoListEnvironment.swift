//
//  TodoListEnvironment.swift
//  ComposableTodo
//
//  Created by Sunny.K on 2021/01/26.
//

import Foundation
import Combine
import ComposableArchitecture

struct TodoListEnvironment {
    let userDefault: UserDefaults

    let sampleData = [
        Todo(description: "first"),
        Todo(description: "second"),
        Todo(description: "third")
    ]

    func save(_ todos: [Todo]) -> Effect<[Todo], Never> {
        let data = try? JSONEncoder().encode(todos)
        userDefault.set(data, forKey: "Todos")
        return Effect(value: todos)
    }

    func load() -> Effect<[Todo], CodableError> {
        guard let data = userDefault.data(forKey: "Todos") else { return Effect(error: CodableError.noData) }
        let todos = try? JSONDecoder().decode([Todo].self, from: data)
        return Effect(value: todos ?? sampleData)
    }
}

enum CodableError: Error {
    case noData
}
