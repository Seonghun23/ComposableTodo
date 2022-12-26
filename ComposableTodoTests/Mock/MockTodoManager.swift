//
//  MockTodoManager.swift
//  ComposableTodoTests
//
//  Created by Sunny.K on 2021/01/29.
//

import Foundation

@testable import ComposableTodo
final class MockTodoManager: TodoStorable {
    var todos: [Todo] = []

    var isAddCalled = false
    var isSaveCalled = false

    func todos() async -> [Todo] {
        todos
    }
    
    func add(todo: String) async {
        isAddCalled = true
    }
    
    func save(todos: [Todo]) async {
        isSaveCalled = true
    }
}
