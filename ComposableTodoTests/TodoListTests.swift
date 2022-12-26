//
//  TodoListTests.swift
//  ComposableTodoTests
//
//  Created by Sunny.K on 2021/01/28.
//

import Foundation
import XCTest
import ComposableArchitecture

@testable import ComposableTodo

@MainActor
final class TodoListTests: XCTestCase {
    var todoManager: MockTodoManager!

    override func setUpWithError() throws {
        todoManager = MockTodoManager()
    }

    override func tearDownWithError() throws {
        todoManager = nil
    }

    func test_whenStoreReceiveInitialize_thenLoadShouldCalled() async {
        let store = TestStore(
            initialState: .init(),
            reducer: TodoListReducer()
        )
        store.dependencies.todoManager = todoManager
        
        todoManager.todos = [Todo(description: "initialize")]
        await store.send(.initialize)
        await store.receive(.reload(list: [Todo(description: "initialize")])) {
            $0.todoList = [Todo(description: "initialize")]
        }
    }

    func test_whenStoreReceiveToggle_thenSaveShouldCalled() async {
        let store = TestStore(
            initialState: .init(
                todoList: [Todo(description: "test")]
            ),
            reducer: TodoListReducer()
        )
        store.dependencies.todoManager = todoManager
        
        await store.send(.toggle(index: 0))
        
        XCTAssertEqual(todoManager.isSaveCalled, true)
        await store.receive(.reload(list: [Todo(description: "test", done: true)])) {
            $0.todoList = [Todo(description: "test", done: true)]
        }
    }

    func test_whenStoreReceiveToggleAddTodoPresent_thenIsAddTodoPresentedShouldBeToggled() async {
        let store = TestStore(
            initialState: .init(),
            reducer: TodoListReducer()
        )
        store.dependencies.todoManager = todoManager

        await store.send(.toggleAddTodoPresent) {
            $0.isAddTodoPresented = true
        }
        await store.send(.toggleAddTodoPresent) {
            $0.isAddTodoPresented = false
        }
    }

    func test_whenStoreReceiveReload_thenTodoListShouldBeUpdated() async {
        let store = TestStore(
            initialState: .init(),
            reducer: TodoListReducer()
        )
        store.dependencies.todoManager = todoManager

        await store.send(.reload(list: [Todo(description: "test")])) {
            $0.todoList = [Todo(description: "test")]
        }
    }
}
