//
//  MockTodoListEnvironment.swift
//  ComposableTodoTests
//
//  Created by Sunny.K on 2021/01/28.
//

import Foundation
import ComposableArchitecture

@testable import ComposableTodo
class MockTodoListEnvironment: TodoListEnvironmentType {

    var isSaveCalled = false
    var isLoadCalled = false

    var expectedLoad: Effect<[Todo], Never>?

    func save(_ todos: [Todo]) {
        isSaveCalled = true
    }

    func load() -> Effect<[Todo], Never> {
        isLoadCalled = true
        return expectedLoad ?? .none
    }
}
