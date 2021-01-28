//
//  TodoListEnvironment.swift
//  ComposableTodo
//
//  Created by Sunny.K on 2021/01/26.
//

import Foundation
import Combine
import ComposableArchitecture

protocol TodoListEnvironmentType {
    func save(_ todos: [Todo])
    func load() -> Effect<[Todo], Never>
}

struct TodoListEnvironment: TodoListEnvironmentType {
    let todoManager: TodoStorable

    func save(_ todos: [Todo]) {
        todoManager.save(todos: todos)
    }

    func load() -> Effect<[Todo], Never> {
        let publisher = todoManager.todoPublisher
            .subscribe(on: DispatchQueue.global())

        return Effect(publisher)
    }
}

enum CodableError: Error {
    case unknown
    case noData
}
