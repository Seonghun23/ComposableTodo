//
//  MockTodoManager.swift
//  ComposableTodoTests
//
//  Created by Sunny.K on 2021/01/29.
//

import Foundation

@testable import ComposableTodo
final class MockTodoManager: TodoStorable {
    var todoPublisher: Published<[Todo]>.Publisher { $todos }

    @Published var todos: [Todo] = []

    var isAddCalled = false
    var isSaveCalled = false

    func add(todo: String) {
        isAddCalled = true
    }

    func save(todos: [Todo]) {
        isSaveCalled = true
    }
}
