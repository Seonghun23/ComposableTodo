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
        let publisher = Just(todos)
            .map { todos -> [Todo] in
                let data = try? JSONEncoder().encode(todos)
                self.userDefault.set(data, forKey: "Todos")
                return todos
            }
            .subscribe(on: DispatchQueue.global())

        
        return Effect(publisher)
    }

    func load() -> Effect<[Todo], CodableError> {
        let publisher = Just(Void())
            .tryMap { _ -> [Todo] in
                guard let data = userDefault.data(forKey: "Todos") else {
                    throw CodableError.noData
                }

                return try JSONDecoder().decode([Todo].self, from: data)
            }
            .mapError { error -> CodableError in
                guard let error = error as? CodableError else {
                    return CodableError.unknown
                }

                return error
            }
            .subscribe(on: DispatchQueue.global())

        return Effect(publisher)
    }
}

enum CodableError: Error {
    case unknown
    case noData
}
